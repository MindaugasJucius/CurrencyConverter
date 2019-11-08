//
//  CurrencyPairModelController.swift
//  CurrencyConverterTests
//
//  Created by Mindaugas Jucius on 08/11/2019.
//

import XCTest
@testable import CurrencyConverter

class CurrencyPairModelControllerTests: XCTestCase {

    let currencyPairModelController = CurrencyPairModelController()
    
    func testPassingCurrenciesWithEqualIdentifiersThrowsError() {
        do {
            let currency = Currency(identifier: "USD")
            let badPair = try currencyPairModelController.createCurrencyPair(
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
            let constructedPair = try currencyPairModelController.createCurrencyPair(
                base: baseCurrency,
                convertTo: currencyToConvertTo
            )
            
            XCTAssert(
                constructedPair.baseCurrency == baseCurrency &&
                constructedPair.currencyToConvertTo == currencyToConvertTo
            )
        } catch {
            XCTFail("failed to construct currency pair")
        }
    }
    
    func testStoredCurrencyPairsContainNewlyStoredPair() {
        do {
            let baseCurrency = Currency(identifier: "USD")
            let currencyToConvertTo = Currency(identifier: "EUR")
            let pairToStore = try currencyPairModelController.createCurrencyPair(
                base: baseCurrency,
                convertTo: currencyToConvertTo
            )
            currencyPairModelController.storeCurrencyPair(currencyPair: pairToStore)
            XCTAssert(currencyPairModelController.storedCurrencyPairs.contains(pairToStore)) 
        } catch {
            XCTFail("failed to check if pair is stored")
        }
    }
    
}
