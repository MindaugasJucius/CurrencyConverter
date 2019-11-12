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

class CurrencyPairsViewModel {
    
    private let exhangeRatesRequestTimeInterval: TimeInterval = 1
    
    private var exhangeRatesTimer: Timer?
    
    enum State {
        case noPairs
        case pairs([CurrencyPair])
        case error(Error)
    }
    
    // Output
    var observeStateChange: ((State) -> ())? {
        didSet {
            pairsChanged()
        }
    }
    
    private var storedPairs: [CurrencyPair] = []
    
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
        exhangeRatesTimer = Timer.scheduledTimer(
            withTimeInterval: exhangeRatesRequestTimeInterval, repeats: true,
            block: { [weak self] timer in
                self?.exhangeRateRequestPerformer.exchangeRates(for: [], completion: { result in
                    
                })
            }
        )
    }
    
    func delete(pair: CurrencyPair) throws {
        try pairModelModifier.delete(currencyPair: pair)
        pairsChanged()
    }
    
    func pairsChanged() {
        do {
            self.storedPairs = try pairModelRetriever.storedCurrencyPairs()
            observeStateChange?(constructState())
        } catch let error {
            observeStateChange?(.error(error))
        }
    }

    private func constructState() -> State {
        if !storedPairs.isEmpty {
            return .pairs(storedPairs)
        } else {
            return .noPairs
        }
    }
    
}
