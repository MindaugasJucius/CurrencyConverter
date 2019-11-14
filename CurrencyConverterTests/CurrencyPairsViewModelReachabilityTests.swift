//
//  CurrencyPairsViewModelReachabilityTests.swift
//  CurrencyConverterTests
//
//  Created by Mindaugas Jucius on 14/11/2019.
//

import XCTest
@testable import CurrencyConverter

class CurrencyPairsViewModelReachabilityTests: XCTestCase {

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
    
    func testThatCurrencyRatesPerformerIsNotInvokedIfUnreachable() {
        let expectation = XCTestExpectation(
            description: "currency rates performer not invoked when unreachable"
        )
        expectation.isInverted = true
        
        pairModelRetriever.pairsToReturn = [TestCurrencyPairs.mockPairToCreate]
        viewModel.pairsChanged()
        mockMonitor.networkReachabilityChanged?(false)
        
        requestPerformer.ratesMethodInvoked = { _ in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testThatCurrencyRatesPerformerIsInvokedIfReachable() {
        let expectation = XCTestExpectation(
            description: "currency rates performer is invoked reachable"
        )
        
        pairModelRetriever.pairsToReturn = [TestCurrencyPairs.mockPairToCreate]
        viewModel.pairsChanged()
        mockMonitor.networkReachabilityChanged?(true)
        
        requestPerformer.ratesMethodInvoked = { _ in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
}
