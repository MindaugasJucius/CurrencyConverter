//
//  CurrencyPairModelController.swift
//  CurrencyConverterTests
//
//  Created by Mindaugas Jucius on 08/11/2019.
//

import XCTest
@testable import CurrencyConverter

class CurrencyPairModelControllerTests: XCTestCase {

    let currencyPairModelController = CurrencyPairModelController(
        currencyPairPersister: CurrencyPairPersistenceController()
    )
    
    override func setUp() {
        UserDefaults.standard.set(nil, forKey: "persistedCurrencyPairs")
    }
    
    func testPassingCurrenciesWithEqualIdentifiersThrowsError() {
        do {
            let currency = Currency(identifier: "USD")
            let badPair = try currencyPairModelController.constructCurrencyPair(
                base: currency,
                convertTo: currency
            )
            XCTFail("Created currency pair with equal identifiers: \(badPair.baseCurrency.identifier)")
        } catch let currencyPairError as CurrencyPairModelController.CurrencyPairError {
            XCTAssert(currencyPairError == .equalIdentifiers)
        } catch let error {
            XCTFail("Creating currency with equal identifiers throws wrong error: \(error.localizedDescription)")
        }
    }
    
    func testConstructedCurrencyPairHasCorrectCurrencies() {
        do {
            let baseCurrency = Currency(identifier: "USD")
            let currencyToConvertTo = Currency(identifier: "EUR")
            let constructedPair = try currencyPairModelController.constructCurrencyPair(
                base: baseCurrency,
                convertTo: currencyToConvertTo
            )
            
            XCTAssert(
                constructedPair.baseCurrency == baseCurrency &&
                constructedPair.conversionTargetCurrency == currencyToConvertTo
            )
        } catch {
            XCTFail("failed to construct currency pair")
        }
    }
    
    func testStoredCurrencyPairsContainNewlyStoredPair() {
        do {
            let baseCurrency = Currency(identifier: "USD")
            let currencyToConvertTo = Currency(identifier: "EUR")
            
            let pairToStore = try currencyPairModelController.constructCurrencyPair(
                base: baseCurrency,
                convertTo: currencyToConvertTo
            )
            try currencyPairModelController.store(currencyPair: pairToStore)
            
            let newlyStoredPairs = try currencyPairModelController.storedCurrencyPairs()
            XCTAssert(newlyStoredPairs.contains(pairToStore))
        } catch {
            XCTFail("failed to check if pair is stored")
        }
    }
    
    func testDeletingCurrencyPairRemovesFromStoredPairs() {
        do {
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
            
            try currencyPairModelController.store(currencyPair: mockPairToCreate)
            try currencyPairModelController.store(currencyPair: mockPairToCreate1)
            
            let currentPairs = try currencyPairModelController.storedCurrencyPairs()
            XCTAssertEqual(currentPairs.count, 2)
            
            try currencyPairModelController.delete(currencyPair: mockPairToCreate1)
            
            let pairsAfterDeletion = try currencyPairModelController.storedCurrencyPairs()
            XCTAssertEqual(pairsAfterDeletion, [mockPairToCreate])
        } catch {
            XCTFail("failed to check if pair is stored")
        }
    }
    
}
