//
//  CurrencyPairCreationViewModelTests.swift
//  CurrencyConverterTests
//
//  Created by Mindaugas Jucius on 09/11/2019.
//

import XCTest
@testable import CurrencyConverter

private class MockCurrenciesModelController: CurrenciesModelControlling {
    
    var currenciesToReturn: [Currency] = []
    
    func loadCurrencies() throws -> [Currency] {
        return currenciesToReturn
    }
    
}

private class MockCurrencyPairModelController: CurrencyPairModelRetrieving {

    var pairsToReturn: [CurrencyPair] = []
    
    func storedCurrencyPairs() throws -> [CurrencyPair] {
        return pairsToReturn
    }
    
}

class CurrencyPairCreationViewModelTests: XCTestCase {
    
    private var currencies: [Currency] {
        return [
            Currency(identifier: "EUR"),
            Currency(identifier: "USD"),
            Currency(identifier: "HUF"),
            Currency(identifier: "MYR")
        ]
    }

    func testNoPossiblePairsForCurrencyWithExhaustedSelectionOptions() {
        let mockCurrenciesController = MockCurrenciesModelController()
        let mockCurrencyPairController = MockCurrencyPairModelController()
        
        let viewModel = CurrencyPairCreationViewModel.init(
            currenciesModelController: mockCurrenciesController,
            currencyPairModelController: mockCurrencyPairController
        )
        
        viewModel.possiblePairs(for: <#T##Currency#>)
    }
    
}
