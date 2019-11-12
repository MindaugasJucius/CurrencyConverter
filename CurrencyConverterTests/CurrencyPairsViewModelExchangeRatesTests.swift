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
    
    private lazy var viewModel = CurrencyPairsViewModel(
        pairModelModifier: pairModelRetriever,
        pairModelRetriever: pairModelRetriever,
        exhangeRateRequestPerformer: requestPerformer
    )
    
    override func setUp() {
        requestPerformer.ratesMethodInvoked = nil
        requestPerformer.returnOnCompletion = nil
        viewModel.observeStateChange = nil
    }
    
    func testThatExchangeRequestPerformerIsCalledEverySecond() {
        let fulfillmentCount = 3
        let expectation = XCTestExpectation(
            description: "request perfrormer is invoked \(fulfillmentCount) times in \(fulfillmentCount) seconds"
        )
        expectation.expectedFulfillmentCount = fulfillmentCount
        
        pairModelRetriever.pairsToReturn = [TestCurrencyPairs.mockPairToCreate]
        viewModel.pairsChanged()
        viewModel.beginRequestingExchangeRates()
        
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
        viewModel.beginRequestingExchangeRates()

        requestPerformer.ratesMethodInvoked = { _ in
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.5)
    }
    
}
