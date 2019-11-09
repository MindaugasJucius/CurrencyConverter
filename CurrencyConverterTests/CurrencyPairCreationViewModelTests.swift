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
        
    private let mockCurrenciesController = MockCurrenciesModelController()
    private let mockCurrencyPairController = MockCurrencyPairModelController()

    private var currencies: [Currency] {
        return [
            Currency(identifier: "EUR"),
            Currency(identifier: "USD"),
            Currency(identifier: "HUF"),
            Currency(identifier: "MYR")
        ]
    }

    func testNoPossiblePairsForCurrencyWithExhaustedSelectionOptions() {
        let viewModel = CurrencyPairCreationViewModel.init(
            currenciesModelController: mockCurrenciesController,
            currencyPairModelController: mockCurrencyPairController
        )
        
        let currencyToTestAgainstTo = currencies[0]

        let allPossiblePairs = currencies[1...].map {
            pair(base: currencyToTestAgainstTo, second: $0)
        }
        
        mockCurrencyPairController.pairsToReturn = allPossiblePairs
        
        XCTAssertEqual(viewModel.possiblePairs(for: currencyToTestAgainstTo), [])
    }
    
    private func pair(base: Currency, second: Currency) -> CurrencyPair {
        return CurrencyPair.init(baseCurrency: base, currencyToConvertTo: second, creationDate: Date())
    }
    
}
