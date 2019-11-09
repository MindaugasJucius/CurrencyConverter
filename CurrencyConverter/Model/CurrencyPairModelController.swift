import Foundation

struct CurrencyPair: Codable, Equatable {
    let baseCurrency: Currency
    let currencyToConvertTo: Currency
    let creationDate: Date
    
    var queryParameter: String {
        return baseCurrency.identifier + currencyToConvertTo.identifier
    }
    
    /// _fileprivate_ forbids creation of _CurrencyPair_ not through _CurrencyPairModelController_
    fileprivate init(baseCurrency: Currency,
                     currencyToConvertTo: Currency,
                     creationDate: Date) {
        self.baseCurrency = baseCurrency
        self.currencyToConvertTo = currencyToConvertTo
        self.creationDate = creationDate
    }

}

protocol CurrencyPairModelControlling {
    func constructCurrencyPair(base: Currency, convertTo: Currency) throws -> CurrencyPair
    func store(currencyPair: CurrencyPair) throws
    
    func storedCurrencyPairs() throws -> [CurrencyPair]
}

class CurrencyPairModelController: CurrencyPairModelControlling {
    
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
