//
//  CurrencyPairsViewModelExchangeRatesTests.swift
//  CurrencyConverterTests
//
//  Created by Mindaugas Jucius on 11/12/19.
//

import XCTest
@testable import CurrencyConverter

class CurrencyPairsViewModelExchangeRatesTests: XCTestCase {

    private let pairModelRetriever = MockCurrencyPairModelRetrieverModifier()
    private let requestPerformer = MockExchangeRateRequestPerformer()
    private let mockMonitor = MockReachabilityMonitor()
    
    private lazy var viewModel = CurrencyPairsViewModel(
        pairModelModifier: pairModelRetriever,
        pairModelRetriever: pairModelRetriever,
        exhangeRateRequestPerformer: requestPerformer,
        reachabilityMonitor: mockMonitor
    )
    
    override func setUp() {
        requestPerformer.ratesMethodInvoked = nil
        requestPerformer.returnOnCompletion = nil
        viewModel.observeStateChanged = nil
    }
    
    func testThatExchangeRequestPerformerIsCalledEverySecond() {
        let fulfillmentCount = 3
        let expectation = XCTestExpectation(
            description: "request performer is invoked \(fulfillmentCount) times in \(fulfillmentCount) seconds"
        )
        expectation.expectedFulfillmentCount = fulfillmentCount
        
        pairModelRetriever.pairsToReturn = [TestCurrencyPairs.mockPairToCreate]
        viewModel.pairsChanged()
        mockMonitor.networkReachabilityChanged?(true)
        
        requestPerformer.ratesMethodInvoked = { _ in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: TimeInterval(fulfillmentCount))
    }
    
    func testThatExchangeRequestPerformerIsNotInvokedWhenThereAreNoPairs() {
        let expectation = XCTestExpectation(
            description: "request performer is not invoked with empty pairs array"
        )
        expectation.isInverted = true

        pairModelRetriever.pairsToReturn = []
        viewModel.pairsChanged()
        mockMonitor.networkReachabilityChanged?(true)

        requestPerformer.ratesMethodInvoked = { _ in
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.5)
    }
    
    func testThatPairsViewModelInvokesExchangeRatesCallbackAfterObservationStart() {
        let expectation = XCTestExpectation(
            description: "pairs view model invokes exchange rates callback with rates from exchange rates API"
        )
        
        let requestPerformerResult = [
            TestCurrencyPairs.mockPairToCreate: 0.5,
            TestCurrencyPairs.mockPairToCreate1: 0.9
        ]

        requestPerformer.returnOnCompletion = requestPerformerResult
        pairModelRetriever.pairsToReturn = Array(requestPerformerResult.keys)
        viewModel.pairsChanged()
        mockMonitor.networkReachabilityChanged?(true)
        
        viewModel.exchangeRatesChanged = { pairsWithExchangeRate in
            pairsWithExchangeRate.forEach { pairWithExchangeRate in
                let exchangeRate = requestPerformerResult[pairWithExchangeRate.currencyPair]
                XCTAssertEqual(exchangeRate, pairWithExchangeRate.exchangeRate)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
    
    func testThatPairsViewModelStateContainsExchangeRates() {
        let expectation = XCTestExpectation(
            description: "pairs view model state contains exchange rates"
        )
        expectation.expectedFulfillmentCount = 2
        var fulfillCount = 0
        
        let requestPerformerResult = [
            TestCurrencyPairs.mockPairToCreate: 0.5,
            TestCurrencyPairs.mockPairToCreate1: 0.9
        ]

        requestPerformer.returnOnCompletion = requestPerformerResult
        pairModelRetriever.pairsToReturn = Array(requestPerformerResult.keys)
        viewModel.pairsChanged()
        mockMonitor.networkReachabilityChanged?(true)
        
        viewModel.observeStateChanged = { state in
            switch state {
            case .pairsWithExchangeRate(let pairsWithExchangeRate):
                if fulfillCount == 0 {
                    XCTAssertEqual(pairsWithExchangeRate.map { $0.currencyPair },
                                   self.pairModelRetriever.pairsToReturn)

                } else {
                    pairsWithExchangeRate.forEach { pairWithExchangeRate in
                        let exchangeRate = requestPerformerResult[pairWithExchangeRate.currencyPair]
                        XCTAssertEqual(exchangeRate, pairWithExchangeRate.exchangeRate)
                    }
                }
                expectation.fulfill()
                fulfillCount += 1
            default:
                XCTFail()
            }
        }
        
        // Simulate that pair change has occurs later (insertion/deletion)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.pairsChanged()
        }

        wait(for: [expectation], timeout: 1)
    }
    
}
