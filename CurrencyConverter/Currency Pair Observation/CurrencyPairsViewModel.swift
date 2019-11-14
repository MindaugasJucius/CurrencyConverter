//
//  CurrencyPairsViewModel.swift
//  CurrencyConverter
//
//  Created by Mindaugas Jucius on 10/11/2019.
//

import Foundation

protocol CurrencyPairsViewModelInputs {
    
}

protocol CurrencyPairsViewModelOutputs {
    
}

struct CurrencyPairExchangeRate: Equatable, Hashable {
    let currencyPair: CurrencyPair
    let exchangeRate: Double?
}

class CurrencyPairsViewModel {
    
    enum State {
        case noPairs
        case pairsWithExchangeRate([CurrencyPairExchangeRate])
        case error(Error)
    }
    
    private let exhangeRatesRequestTimeInterval: TimeInterval = 1
    private var exchangeRatesTimer: Timer?
    
    var observeStateChange: ((State) -> ())? {
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
    
    func stopRequestingExchangeRates() {
        exchangeRatesTimer?.invalidate()
    }
    
    func delete(pair: CurrencyPair) throws {
        try pairModelModifier.delete(currencyPair: pair)
        pairsChanged()
    }
    
    func pairsChanged() {
        do {
            storedPairs = try pairModelRetriever.storedCurrencyPairs()
            observeStateChange?(constructState())
        } catch let error {
            observeStateChange?(.error(error))
        }
    }

    private func constructState() -> State {
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
            self.observeStateChange?(.error(error))
        }
    }
    
}
