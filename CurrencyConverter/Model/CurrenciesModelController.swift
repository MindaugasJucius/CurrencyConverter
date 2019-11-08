import Foundation

struct Currency: Codable {
    let identifier: String
}

struct CurrencyPair: Codable {
    let baseCurrency: Currency
    let currencyToConvertTo: Currency
}

class CurrenciesModelController {
    
    enum CurrenciesLoadError: Error {
        case noResource
        case decodeError(String)
    }
    
    enum CurrencyPairError: Error {
        case equalIdentifiers
    }
    
    private let currenciesFileName = "currencies"
    private let currenciesFileExtension = "json"

    func createCurrencyPair(base: Currency, convertTo: Currency) throws -> CurrencyPair {
        guard base.identifier != convertTo.identifier else {
            throw CurrencyPairError.equalIdentifiers
        }
        
        return CurrencyPair.init(baseCurrency: base, currencyToConvertTo: convertTo)
    }
    
    func loadCurrencies() throws -> [Currency] {
        let resourceURL = Bundle.main.url(
            forResource: currenciesFileName,
            withExtension: currenciesFileExtension
        )
        
        guard let currenciesFileURL = resourceURL else {
            throw CurrenciesLoadError.noResource
        }
        
        do {
            let currenciesFileData = try Data.init(contentsOf: currenciesFileURL)
            let decodedCurrencyIdentifiers = try JSONDecoder().decode([String].self, from: currenciesFileData)
            return decodedCurrencyIdentifiers.map(Currency.init)
        } catch let error {
            throw CurrenciesLoadError.decodeError(error.localizedDescription)
        }
    }
    
}
