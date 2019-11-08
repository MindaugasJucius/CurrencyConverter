import Foundation

struct CurrencyPair: Codable {
    let baseCurrency: Currency
    let currencyToConvertTo: Currency
}

class CurrencyPairModelController {
    
    enum CurrencyPairError: Error {
        case equalIdentifiers
    }
    
    func createCurrencyPair(base: Currency, convertTo: Currency) throws -> CurrencyPair {
        guard base.identifier != convertTo.identifier else {
            throw CurrencyPairError.equalIdentifiers
        }
        
        return CurrencyPair.init(baseCurrency: base, currencyToConvertTo: convertTo)
    }
    
}
