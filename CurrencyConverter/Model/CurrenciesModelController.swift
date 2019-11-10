import Foundation

struct Currency: Codable, Equatable, Hashable {
    
    let identifier: String

}

protocol CurrenciesModelControlling {
    
    func loadCurrencies() throws -> [Currency]
    
}

class CurrenciesModelController: CurrenciesModelControlling {
    
    enum CurrenciesLoadError: Error {
        case noResource
    }
    
    private let currenciesFileName = "currencies"
    private let currenciesFileExtension = "json"

    func loadCurrencies() throws -> [Currency] {
        let resourceURL = Bundle.main.url(
            forResource: currenciesFileName,
            withExtension: currenciesFileExtension
        )
        
        guard let currenciesFileURL = resourceURL else {
            throw CurrenciesLoadError.noResource
        }
        
        let currenciesFileData = try Data.init(contentsOf: currenciesFileURL)
        let decodedCurrencyIdentifiers = try JSONDecoder().decode([String].self, from: currenciesFileData)
        return decodedCurrencyIdentifiers.map(Currency.init)
    }
    
}
