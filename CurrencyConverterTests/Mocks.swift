//
//  Mocks.swift
//  CurrencyConverterTests
//
//  Created by Mindaugas Jucius on 11/12/19.
//

import Foundation
@testable import CurrencyConverter

class MockExchangeRateRequestPerformer: ExchangeRateRequestPerforming {
    
    var returnOnCompletion: ExchangeRateResult?
    var ratesMethodInvoked: (() -> ())?
    
    func exchangeRates(for pairs: [CurrencyPair], completion: @escaping (ExchangeRateResult) -> ()) {
        guard let result = returnOnCompletion else {
            return
        }
        completion(result)
    }
    
}

class MockCurrenciesModelController: CurrenciesModelControlling {
    
    var currenciesToReturn: [Currency] = []
    
    func loadCurrencies() throws -> [Currency] {
        return currenciesToReturn
    }
    
}

class MockCurrencyPairModelRetrieverModifier: CurrencyPairModelRetrieving, CurrencyPairModelModifying {
    
    var pairsToReturn: [CurrencyPair] = []
    
    func storedCurrencyPairs() throws -> [CurrencyPair] {
        return pairsToReturn
    }
    
    func constructCurrencyPair(base: Currency, convertTo: Currency) throws -> CurrencyPair {
        fatalError("Not implemented")
    }
    
    func store(currencyPair: CurrencyPair) throws {
        fatalError("Not implemented")
    }
    
    func delete(currencyPair: CurrencyPair) throws {
        pairsToReturn.removeAll(where: { $0 == currencyPair })
    }
    
}

struct TestCurrencyPairs {

    static let mockPairToCreate = CurrencyPair(
        baseCurrency: Currency(identifier: "USD"),
        conversionTargetCurrency: Currency(identifier: "EUR"),
        creationDate: Date()
    )

    static let mockPairToCreate1 = CurrencyPair(
        baseCurrency: Currency(identifier: "EUR"),
        conversionTargetCurrency: Currency(identifier: "GBP"),
        creationDate: Date()
    )

    static let mockPairToCreate2 = CurrencyPair(
        baseCurrency: Currency(identifier: "GBP"),
        conversionTargetCurrency: Currency(identifier: "USD"),
        creationDate: Date()
    )

    static let mockPairToCreate3 = CurrencyPair(
        baseCurrency: Currency(identifier: "GBP"),
        conversionTargetCurrency: Currency(identifier: "LEU"),
        creationDate: Date()
    )
    
}

