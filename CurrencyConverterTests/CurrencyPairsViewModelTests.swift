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
    
    private lazy var viewModel = CurrencyPairsViewModel(
        pairModelModifier: pairModelRetriever,
        pairModelRetriever: pairModelRetriever,
        exhangeRateRequestPerformer: MockExchangeRateRequestPerformer()
    )
    
    override func setUp() {
        pairModelRetriever.pairsToReturn = []
        viewModel.observeStateChanged = nil
    }
    
    func testSettingObserveClosureInvokesWithState() {
        let expectation = XCTestExpectation(description: "change handler invoked")
        let observer: (PairsViewState) -> () = { state in
            expectation.fulfill()
        }
        
        viewModel.observeStateChanged = observer
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testAfterCreatingPairNewStateContainsPair() {
        let expectation = XCTestExpectation(description: "new pair is in state")
        
        let observer: (PairsViewState) -> () = { state in
            if case let PairsViewState.pairsWithExchangeRate(pairs) = state {
                XCTAssertTrue(pairs.map{ $0.currencyPair }.contains(TestCurrencyPairs.mockPairToCreate))
                expectation.fulfill()
            }
        }
        
        viewModel.observeStateChanged = observer
        pairModelRetriever.pairsToReturn = [TestCurrencyPairs.mockPairToCreate]
        viewModel.pairsChanged()
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testStateContainsStoredPairs() {
        let expectation = XCTestExpectation(description: "state contains stored pairs")
        
        let mockPairs = [TestCurrencyPairs.mockPairToCreate,
                         TestCurrencyPairs.mockPairToCreate1,
                         TestCurrencyPairs.mockPairToCreate2]
        
        pairModelRetriever.pairsToReturn = mockPairs
        viewModel.observeStateChanged = { state in
            switch state {
            case .pairsWithExchangeRate(let pairs):
                XCTAssertEqual(pairs.map { $0.currencyPair }, mockPairs)
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
        
        let mockPairs = [TestCurrencyPairs.mockPairToCreate,
                         TestCurrencyPairs.mockPairToCreate1,
                         TestCurrencyPairs.mockPairToCreate2]
        
        pairModelRetriever.pairsToReturn = mockPairs
        let pairsPlusNewlyCreated = mockPairs + [TestCurrencyPairs.mockPairToCreate3]
        
        viewModel.observeStateChanged = { state in
            switch state {
            case .pairsWithExchangeRate(let pairs):
                let currencyPairs = pairs.map { $0.currencyPair }
                if fulfillmentCount == 0 {
                    XCTAssertEqual(currencyPairs, mockPairs)
                } else if fulfillmentCount == 1 {
                    XCTAssertEqual(currencyPairs, pairsPlusNewlyCreated)
                }
                expectation.fulfill()
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

        let pairToDelete = TestCurrencyPairs.mockPairToCreate2
        let remainingAfterDeletion = [TestCurrencyPairs.mockPairToCreate,
                                      TestCurrencyPairs.mockPairToCreate1]
        let mockPairs = remainingAfterDeletion + [pairToDelete]
        
        viewModel.observeStateChanged = { state in
            if case let PairsViewState.pairsWithExchangeRate(pairs) = state {
                let currencyPairs = pairs.map { $0.currencyPair }
                XCTAssertEqual(currencyPairs, remainingAfterDeletion)
                expectation.fulfill()
            }
        }
        
        pairModelRetriever.pairsToReturn = mockPairs

        let exchangeRatePair = CurrencyPairExchangeRate(currencyPair: pairToDelete, exchangeRate: nil)
        XCTAssertNoThrow(try viewModel.delete(pair: exchangeRatePair))

        wait(for: [expectation], timeout: 0.1)
    }
    
}
