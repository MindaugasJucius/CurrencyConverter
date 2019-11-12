//
//  CurrencyPairsViewModelExchangeRatesTests.swift
//  CurrencyConverterTests
//
//  Created by Mindaugas Jucius on 11/12/19.
//

import XCTest
@testable import CurrencyConverter

class CurrencyPairsViewModelExchangeRatesTests: XCTestCase {

    let pairModelRetriever = MockCurrencyPairModelRetrieverModifier()
    
    private lazy var viewModel = CurrencyPairsViewModel(
        pairModelModifier: pairModelRetriever,
        pairModelRetriever: pairModelRetriever,
        exhangeRateRequestPerformer: MockExchangeRateRequestPerformer()
    )
    
    func testThatExchangeRequestPerformerIsCalledOnRequiredIntervals() {
        
    }
    
}
