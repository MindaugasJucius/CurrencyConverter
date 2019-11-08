import Foundation

struct CurrencyPair: Equatable {
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
    
    private let currencyPairArrayDefaultsKey = "persistedCurrencyPairs"
    
    enum CurrencyPairError: Error {
        case equalIdentifiers
    }
    
    var storedCurrencyPairs: [CurrencyPair] {
        get {
            let valueForKey = UserDefaults.standard.value(forKey: currencyPairArrayDefaultsKey)
            guard let stored = valueForKey as? [CurrencyPair] else {
                return []
            }
            
            return stored
        }
    }
    
    func createCurrencyPair(base: Currency, convertTo: Currency) throws -> CurrencyPair {
        guard base.identifier != convertTo.identifier else {
            throw CurrencyPairError.equalIdentifiers
        }
        
        return CurrencyPair.init(baseCurrency: base, currencyToConvertTo: convertTo)
    }
    
    func storeCurrencyPair(currencyPair: CurrencyPair) {
        var currentlyStoredPairs = storedCurrencyPairs
        currentlyStoredPairs.append(currencyPair)
    }
    
}
