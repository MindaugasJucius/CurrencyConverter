//
//  CurrencyPairCreationViewModelTests.swift
//  CurrencyConverterTests
//
//  Created by Mindaugas Jucius on 09/11/2019.
//

import XCTest
@testable import CurrencyConverter

class CurrencyPairCreationViewModelTests: XCTestCase {
        
    private let mockCurrenciesController = MockCurrenciesModelController()
    private let mockCurrencyPairController = MockCurrencyPairModelRetrieverModifier()
    
    private lazy var viewModel = CurrencyPairCreationViewModel.init(
        currenciesModelController: mockCurrenciesController,
        currencyPairModelController: mockCurrencyPairController
    )
    
    private var currencies: [Currency] {
        return [
            Currency(identifier: "EUR"),
            Currency(identifier: "USD"),
            Currency(identifier: "HUF"),
            Currency(identifier: "MYR")
        ]
    }

    func testNoPossiblePairsForCurrencyWithExhaustedSelectionOptions() {
        let baseCurrency = currencies[0]

        let allPossiblePairs = currencies[1...].map {
            pair(base: baseCurrency, second: $0)
        }
        
        mockCurrencyPairController.pairsToReturn = allPossiblePairs
        
        XCTAssertEqual(viewModel.currencyRepresentations(for: baseCurrency), [])
    }
    
    func testPossiblePairsReturnSelectableForCurrenciesThatAreNotUsed() {
        let baseCurrency = currencies[0]
        let currencyNotIncludedInPairs = CurrencyRepresentation(selectable: true,
                                                                currency: currencies[1])

        let allButOnePossiblePairs = currencies[2...].map {
            pair(base: baseCurrency, second: $0)
        }
        
        mockCurrenciesController.currenciesToReturn = currencies
        mockCurrencyPairController.pairsToReturn = allButOnePossiblePairs
        
        XCTAssertNoThrow(try viewModel.fetchStoredValues())
        
        let selectableCurrencies = viewModel.currencyRepresentations(for: baseCurrency).filter { $0.selectable }
        XCTAssertEqual(selectableCurrencies, [currencyNotIncludedInPairs])
    }
    
    func testBaseCurrencyIsNotSelectableInRepresentations() {
        let baseCurrency = currencies[2]
        let baseCurrencyRepresentation = CurrencyRepresentation(selectable: false, currency: baseCurrency)
        mockCurrenciesController.currenciesToReturn = currencies
        mockCurrencyPairController.pairsToReturn = []
        
        XCTAssertNoThrow(try viewModel.fetchStoredValues())
        
        let possibleConversionTargets = viewModel.currencyRepresentations(for: baseCurrency)
        XCTAssertTrue(possibleConversionTargets.filter { $0 == baseCurrencyRepresentation }.count != 0)
    }
    
    private func pair(base: Currency, second: Currency) -> CurrencyPair {
        return CurrencyPair.init(baseCurrency: base, conversionTargetCurrency: second, creationDate: Date())
    }
    
}
