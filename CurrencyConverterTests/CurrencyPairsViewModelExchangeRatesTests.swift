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
    
    func testThatExchangeRequestPerformerIsCalledEverySecond() {
        let fulfillmentCount = 3
        let expectation = XCTestExpectation(
            description: "request perfrormer is invoked \(fulfillmentCount) times in \(fulfillmentCount) seconds"
        )
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = fulfillmentCount
        
        requestPerformer.ratesMethodInvoked = {
            expectation.fulfill()
        }
        

        wait(for: [expectation], timeout: TimeInterval(fulfillmentCount))
    }
    
}
