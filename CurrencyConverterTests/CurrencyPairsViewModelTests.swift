//
//  CurrencyPairsViewModelTests.swift
//  CurrencyConverterTests
//
//  Created by Mindaugas Jucius on 10/11/2019.
//

import XCTest
@testable import CurrencyConverter

class CurrencyPairsViewModelTests: XCTestCase {
    
    let pairModelRetriever = MockCurrencyPairModelRetrieverModifier()

    let mockPairToCreate = CurrencyPair(
        baseCurrency: Currency(identifier: "USD"),
        conversionTargetCurrency: Currency(identifier: "EUR"),
        creationDate: Date()
    )
    
    let mockPairToCreate1 = CurrencyPair(
        baseCurrency: Currency(identifier: "EUR"),
        conversionTargetCurrency: Currency(identifier: "GBP"),
        creationDate: Date()
    )
    
    let mockPairToCreate2 = CurrencyPair(
        baseCurrency: Currency(identifier: "GBP"),
        conversionTargetCurrency: Currency(identifier: "USD"),
        creationDate: Date()
    )
    
    let mockPairToCreate3 = CurrencyPair(
        baseCurrency: Currency(identifier: "GBP"),
        conversionTargetCurrency: Currency(identifier: "LEU"),
        creationDate: Date()
    )
    
    private lazy var viewModel = CurrencyPairsViewModel(
        pairModelModifier: pairModelRetriever,
        pairModelRetriever: pairModelRetriever
    )
    
    override func setUp() {
        pairModelRetriever.pairsToReturn = []
        viewModel.observeStateChange = nil
    }
    
    func testSettingObserveClosureInvokesWithState() {
        let expectation = XCTestExpectation(description: "change handler invoked")
        let observer: (CurrencyPairsViewModel.State) -> () = { state in
            expectation.fulfill()
        }
        
        viewModel.observeStateChange = observer
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testAfterCreatingPairNewStateContainsPair() {
        let expectation = XCTestExpectation(description: "new pair is in state")
        
        let observer: (CurrencyPairsViewModel.State) -> () = { state in
            if case let CurrencyPairsViewModel.State.pairs(pairs) = state {
                XCTAssertTrue(pairs.contains(self.mockPairToCreate))
                expectation.fulfill()
            }
        }
        
        viewModel.observeStateChange = observer
        pairModelRetriever.pairsToReturn = [mockPairToCreate]
        viewModel.pairsChanged()
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testStateContainsStoredPairs() {
        let expectation = XCTestExpectation(description: "state contains stored pairs")
        
        let mockPairs = [mockPairToCreate, mockPairToCreate1, mockPairToCreate2]
        
        pairModelRetriever.pairsToReturn = mockPairs
        viewModel.observeStateChange = { state in
            switch state {
            case .pairs(let pairs):
                XCTAssertEqual(pairs, mockPairs)
                expectation.fulfill()
            default:
                XCTFail("bad state")
            }
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testAfterCreatingPairNewStateContainsAllPairs() {
        let expectation = XCTestExpectation(description: "state contains newly created pair and previous ones")
        expectation.expectedFulfillmentCount = 2
        var fulfillmentCount = 0
        
        let mockPairs = [mockPairToCreate, mockPairToCreate1, mockPairToCreate2]
        
        pairModelRetriever.pairsToReturn = mockPairs
        let pairsPlusNewlyCreated = mockPairs + [self.mockPairToCreate3]
        
        viewModel.observeStateChange = { state in
            switch state {
            case .pairs(let pairs):
                if fulfillmentCount == 0 {
                    XCTAssertEqual(pairs, mockPairs)
                    expectation.fulfill()
                } else if fulfillmentCount == 1 {
                    XCTAssertEqual(pairs, pairsPlusNewlyCreated)
                    expectation.fulfill()
                }
                fulfillmentCount += 1
            default:
                XCTFail("bad state")
            }
        }
        
        pairModelRetriever.pairsToReturn = pairsPlusNewlyCreated
        viewModel.pairsChanged()
        
        wait(for: [expectation], timeout: 0.1)
    }

    func testDeletingPairReturnsStateWithoutDeletedPairs() {
        let expectation = XCTestExpectation(description: "state doesn't contain deleted pair")

        let pairToDelete = mockPairToCreate2
        let remainingAfterDeletion = [mockPairToCreate, mockPairToCreate1]
        let mockPairs = remainingAfterDeletion + [pairToDelete]
        
        viewModel.observeStateChange = { state in
            if case let CurrencyPairsViewModel.State.pairs(pairs) = state {
                XCTAssertEqual(pairs, remainingAfterDeletion)
                expectation.fulfill()
            }
        }
        
        pairModelRetriever.pairsToReturn = mockPairs
        
        XCTAssertNoThrow(try viewModel.delete(pair: pairToDelete))

        wait(for: [expectation], timeout: 0.1)
    }
    
}
