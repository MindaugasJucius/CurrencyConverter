import Foundation

struct CurrencyRepresentation {
    let canSelect: Bool
    let currency: Currency
}

class CurrencyPairCreationViewModel {

    private let currenciesModelController: CurrenciesModelControlling
    private let currencyPairModelController: CurrencyPairModelRetrieving
    
    private var storedCurrencies: [Currency] = []
    private var storedCurrencyPairs: [CurrencyPair] = []
    
    init(currenciesModelController: CurrenciesModelControlling,
         currencyPairModelController: CurrencyPairModelRetrieving) {
        self.currenciesModelController = currenciesModelController
        self.currencyPairModelController = currencyPairModelController
    }

    func fetchStoredValues() throws {
        storedCurrencies = try currenciesModelController.loadCurrencies()
        storedCurrencyPairs = try currencyPairModelController.storedCurrencyPairs()
    }
    
    func currencyRepresentations() throws -> [CurrencyRepresentation] {
        return storedCurrencies.map { currency in
            let remainingPairs = possiblePairs(for: currency)
            return CurrencyRepresentation.init(canSelect: remainingPairs.count != 0, currency: currency)
        }
    }
    
    func possiblePairs(for currency: Currency) -> [Currency] {
        let allPairsWithMatchingBaseCurrency = storedCurrencyPairs.filter {
            $0.baseCurrency.identifier == currency.identifier
        }
        
        return []
    }
    
}
