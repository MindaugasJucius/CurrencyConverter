//
//  CurrencyPairsViewModel.swift
//  CurrencyConverter
//
//  Created by Mindaugas Jucius on 10/11/2019.
//

import Foundation

enum PairsViewState {
    
    case noPairs
    case pairsWithExchangeRate([CurrencyPairExchangeRate])
    case error(Error)

}

protocol CurrencyPairsViewModelViewInputs: class {

    var observeStateChanged: ((PairsViewState) -> ())? { get set }
    var exchangeRatesChanged: (([CurrencyPairExchangeRate]) -> ())? { get set }
    
    func delete(pair: CurrencyPairExchangeRate) throws
    func beginRequestingExchangeRates()
    
}

struct CurrencyPairExchangeRate: Equatable, Hashable {
    
    let currencyPair: CurrencyPair
    let exchangeRate: Double?
    
}

class CurrencyPairsViewModel: CurrencyPairsViewModelViewInputs {
    
    private let exhangeRatesRequestTimeInterval: TimeInterval = 1
    private var exchangeRatesTimer: Timer?
    
    var observeStateChanged: ((PairsViewState) -> ())? {
        didSet {
            pairsChanged()
        }
    }
    
    var exchangeRatesChanged: (([CurrencyPairExchangeRate]) -> ())?
    
    private var storedPairs: [CurrencyPair] = []
    private var pairExchangeRates: [CurrencyPair: Double] = [:]
    
    let pairModelModifier: CurrencyPairModelModifying
    let pairModelRetriever: CurrencyPairModelRetrieving
    let exhangeRateRequestPerformer: ExchangeRateRequestPerforming
    
    init(pairModelModifier: CurrencyPairModelModifying,
         pairModelRetriever: CurrencyPairModelRetrieving,
         exhangeRateRequestPerformer: ExchangeRateRequestPerforming) {
        self.pairModelModifier = pairModelModifier
        self.pairModelRetriever = pairModelRetriever
        self.exhangeRateRequestPerformer = exhangeRateRequestPerformer
    }
    
    func beginRequestingExchangeRates() {
        exchangeRatesTimer = Timer.scheduledTimer(
            withTimeInterval: exhangeRatesRequestTimeInterval, repeats: true,
            block: { [unowned self] _ in
                guard !self.storedPairs.isEmpty else {
                    return
                }
                
                self.exhangeRateRequestPerformer.exchangeRates(
                    for: self.storedPairs,
                    completion: { result in
                        DispatchQueue.main.async {
                            self.handle(exchangeRatesResult: result)
                        }
                    }
                )
            }
        )
        exchangeRatesTimer?.fire()
    }
    
    func delete(pair: CurrencyPairExchangeRate) throws {
        try pairModelModifier.delete(currencyPair: pair.currencyPair)
        pairsChanged()
    }
    
    func pairsChanged() {
        do {
            storedPairs = try pairModelRetriever.storedCurrencyPairs()
            observeStateChanged?(constructState())
        } catch let error {
            observeStateChanged?(.error(error))
        }
    }
    
    private func stopRequestingExchangeRates() {
        exchangeRatesTimer?.invalidate()
    }

    private func constructState() -> PairsViewState {
        if !storedPairs.isEmpty {
            let constructedPairs = constructCurrencyPairsWithExchangeRates(pairExchangeRates: pairExchangeRates)
            return .pairsWithExchangeRate(constructedPairs)
        } else {
            return .noPairs
        }
    }
    
    private func constructCurrencyPairsWithExchangeRates(pairExchangeRates: [CurrencyPair: Double]) -> [CurrencyPairExchangeRate] {
        return storedPairs.map { pair -> CurrencyPairExchangeRate in
            let exchangeRate = self.pairExchangeRates[pair]
            return CurrencyPairExchangeRate(currencyPair: pair, exchangeRate: exchangeRate)
        }
    }
    
    private func handle(exchangeRatesResult: Result<[CurrencyPair: Double], Error>) {
        switch exchangeRatesResult {
        case .success(let pairExchangeRates):
            self.pairExchangeRates = pairExchangeRates
            let exchangeRates = self.constructCurrencyPairsWithExchangeRates(pairExchangeRates: pairExchangeRates)
            self.exchangeRatesChanged?(exchangeRates)
        case .failure(let error):
            self.observeStateChanged?(.error(error))
        }
    }
    
}
