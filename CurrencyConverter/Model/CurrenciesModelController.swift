import Foundation

struct Currency: Codable {
    let identifier: String
}

class CurrenciesModelController {
    
    enum CurrenciesError: Error {
        case noResource
        case decodeError(String)
    }
    
    private let currenciesFileName = "currencies"
    private let currenciesFileExtension = "json"

    func loadCurrencies() throws -> [Currency] {
        let resourceURL = Bundle.main.url(
            forResource: currenciesFileName,
            withExtension: currenciesFileExtension
        )
        
        guard let currenciesFileURL = resourceURL else {
            throw CurrenciesError.noResource
        }
        
        do {
            let currenciesFileData = try Data.init(contentsOf: currenciesFileURL)
            let decodedCurrencyIdentifiers = try JSONDecoder().decode([String].self, from: currenciesFileData)
            return decodedCurrencyIdentifiers.map(Currency.init)
        } catch let error {
            throw CurrenciesError.decodeError(error.localizedDescription)
        }
    }
    
}
