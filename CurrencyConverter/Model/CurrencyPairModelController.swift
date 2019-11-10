import Foundation

struct CurrencyPair: Codable, Equatable {
    
    let baseCurrency: Currency
    let conversionTargetCurrency: Currency
    let creationDate: Date
    
    var queryParameter: String {
        return baseCurrency.identifier + conversionTargetCurrency.identifier
    }
    
}

protocol CurrencyPairModelModifying {

    func constructCurrencyPair(base: Currency, convertTo: Currency) throws -> CurrencyPair
    func store(currencyPair: CurrencyPair) throws
    func delete(currencyPair: CurrencyPair) throws
    
}

protocol CurrencyPairModelRetrieving {

    func storedCurrencyPairs() throws -> [CurrencyPair]

}

class CurrencyPairModelController: CurrencyPairModelModifying, CurrencyPairModelRetrieving {

    private let currencyPairPersister: CurrencyPairPersisting
    
    enum CurrencyPairError: Error {
        case equalIdentifiers
    }
    
    init(currencyPairPersister: CurrencyPairPersisting) {
        self.currencyPairPersister = currencyPairPersister
    }
    
    func constructCurrencyPair(base: Currency, convertTo: Currency) throws -> CurrencyPair {
        guard base.identifier != convertTo.identifier else {
            throw CurrencyPairError.equalIdentifiers
        }
        
        return CurrencyPair(baseCurrency: base,
                            conversionTargetCurrency: convertTo,
                            creationDate: Date())
    }
    
    func store(currencyPair: CurrencyPair) throws {
        try currencyPairPersister.store(currencyPair: currencyPair)
    }
    
    func delete(currencyPair: CurrencyPair) throws {
        try currencyPairPersister.delete(currencyPair: currencyPair)
    }
    
    func storedCurrencyPairs() throws -> [CurrencyPair] {
        return try currencyPairPersister.storedCurrencyPairs()
    }

}
