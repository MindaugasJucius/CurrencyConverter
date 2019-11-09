import Foundation

struct CurrencyRepresentation: Equatable {
    let selectable: Bool
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
    
    func currencyRepresentations() -> [CurrencyRepresentation] {
        return storedCurrencies.map { currency in
            let remainingPairs = currencyRepresentations(for: currency)
            return CurrencyRepresentation.init(selectable: remainingPairs.count != 0, currency: currency)
        }
    }
    
    /// Constructs currency representations. Marks currency representation
    /// as selectable if there's still currencies left to convert to.
    /// - Parameter currency: Perform current currency pair filter logic against this currency.
    func currencyRepresentations(for baseCurrency: Currency) -> [CurrencyRepresentation] {
        let pairsWithMatchingBaseCurrency = storedCurrencyPairs.filter {
            $0.baseCurrency.identifier == baseCurrency.identifier
        }
        
        let currencyPairConversionTarget = pairsWithMatchingBaseCurrency.map {
            $0.conversionTargetCurrency
        }
        
        // Never present passed in currency as selectable
        let currenciesWithoutBaseCurrency = storedCurrencies.filter {
            $0 != baseCurrency
        }

        return currenciesWithoutBaseCurrency.map { currency in
            let selectable = !currencyPairConversionTarget.contains(currency)
            return CurrencyRepresentation(selectable: selectable, currency: currency)
        }
    }
    
}
