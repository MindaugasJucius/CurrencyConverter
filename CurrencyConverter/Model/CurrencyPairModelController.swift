import Foundation

struct CurrencyPair: Codable, Equatable {
    
    let baseCurrency: Currency
    let currencyToConvertTo: Currency
    let creationDate: Date
    
    var queryParameter: String {
        return baseCurrency.identifier + currencyToConvertTo.identifier
    }
    
}

protocol CurrencyPairModelModifying {

    func constructCurrencyPair(base: Currency, convertTo: Currency) throws -> CurrencyPair
    func store(currencyPair: CurrencyPair) throws
    
}

protocol CurrencyPairModelRetrieving {

    func storedCurrencyPairs() throws -> [CurrencyPair]

}

class CurrencyPairModelController: CurrencyPairModelModifying, CurrencyPairModelRetrieving {
    
    private let currencyPairPersister: CurrencyPairPersisting
    
    enum CurrencyPairError: Error {
        case equalIdentifiers
        case cantDeserializeCurrencyPairs
    }
    
    init(currencyPairPersister: CurrencyPairPersisting) {
        self.currencyPairPersister = currencyPairPersister
    }
    
    func constructCurrencyPair(base: Currency, convertTo: Currency) throws -> CurrencyPair {
        guard base.identifier != convertTo.identifier else {
            throw CurrencyPairError.equalIdentifiers
        }
        
        return CurrencyPair(baseCurrency: base,
                            currencyToConvertTo: convertTo,
                            creationDate: Date())
    }
    
    func store(currencyPair: CurrencyPair) throws {
        try currencyPairPersister.store(currencyPair: currencyPair)
    }
    
    func storedCurrencyPairs() throws -> [CurrencyPair] {
        return try currencyPairPersister.storedCurrencyPairs()
    }

}
