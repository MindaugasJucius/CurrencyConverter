import Foundation

struct CurrencyPair: Codable, Equatable {
    let baseCurrency: Currency
    let currencyToConvertTo: Currency
    
    /// _fileprivate_ forbids creation of _CurrencyPair_ not through _CurrencyPairModelController_
    fileprivate init(baseCurrency: Currency,
                     currencyToConvertTo: Currency) {
        self.baseCurrency = baseCurrency
        self.currencyToConvertTo = currencyToConvertTo
    }
    
    var urlParameter: String {
        return baseCurrency.identifier + currencyToConvertTo.identifier
    }
}

class CurrencyPairModelController {
    
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
        
        return CurrencyPair.init(baseCurrency: base, currencyToConvertTo: convertTo)
    }
    
    func store(currencyPair: CurrencyPair) throws {
        try currencyPairPersister.store(currencyPair: currencyPair)
    }
    
    func storedCurrencyPairs() throws -> [CurrencyPair] {
        return try currencyPairPersister.storedCurrencyPairs()
    }

}
