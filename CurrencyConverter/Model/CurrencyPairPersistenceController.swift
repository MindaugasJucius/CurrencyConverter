import Foundation

protocol CurrencyPairPersisting {
    func store(currencyPair: CurrencyPair) throws
    func delete(currencyPair: CurrencyPair) throws
    
    func storedCurrencyPairs() throws -> [CurrencyPair]
}

class CurrencyPairPersistenceController: CurrencyPairPersisting {
   
    private let currencyPairArrayDefaultsKey = "persistedCurrencyPairs"
    
    func store(currencyPair: CurrencyPair) throws {
        var currentPairs = try storedCurrencyPairs()
        currentPairs.append(currencyPair)
        let encodedNewPairs = try JSONEncoder.init().encode(currentPairs)
        UserDefaults.standard.set(encodedNewPairs, forKey: currencyPairArrayDefaultsKey)
    }
    
    func delete(currencyPair: CurrencyPair) throws {
        var currentPairs = try storedCurrencyPairs()
        currentPairs.removeAll(where: { $0 == currencyPair })
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
