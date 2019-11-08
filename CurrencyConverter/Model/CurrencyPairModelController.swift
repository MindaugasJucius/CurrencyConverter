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
    
    private let currencyPairArrayDefaultsKey = "persistedCurrencyPairs"
    
    enum CurrencyPairError: Error {
        case equalIdentifiers
        case cantDeserializeCurrencyPairs
    }
    
    func createCurrencyPair(base: Currency, convertTo: Currency) throws -> CurrencyPair {
        guard base.identifier != convertTo.identifier else {
            throw CurrencyPairError.equalIdentifiers
        }
        
        return CurrencyPair.init(baseCurrency: base, currencyToConvertTo: convertTo)
    }
    
    func store(currencyPair: CurrencyPair) throws {
        var currentPairs = try storedCurrencyPairs()
        currentPairs.append(currencyPair)
        let encodedNewPairs = try JSONEncoder.init().encode(currentPairs)
        UserDefaults.standard.set(encodedNewPairs, forKey: currencyPairArrayDefaultsKey)
    }
    
    func storedCurrencyPairs() throws -> [CurrencyPair] {
        let valueForPairArrayKey = UserDefaults.standard.value(forKey: currencyPairArrayDefaultsKey)
        guard let data = valueForPairArrayKey as? Data else {
            return []
        }
        
        return try JSONDecoder.init().decode([CurrencyPair].self, from: data)
    }

}
