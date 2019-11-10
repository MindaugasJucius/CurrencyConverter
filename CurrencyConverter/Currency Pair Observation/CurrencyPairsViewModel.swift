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
    
    enum State {
        case noPairs
        case pairs([CurrencyPair])
        case error(Error)
    }
    
    // Output
    var observeStateChange: ((State) -> ())? {
        didSet {
            observeStateChange?(constructState())
        }
    }
    
    let pairModelModifier: CurrencyPairModelModifying
    let pairModelRetriever: CurrencyPairModelRetrieving
    
    init(pairModelModifier: CurrencyPairModelModifying,
         pairModelRetriever: CurrencyPairModelRetrieving) {
        self.pairModelModifier = pairModelModifier
        self.pairModelRetriever = pairModelRetriever
    }
    
    func delete(pair: CurrencyPair) throws {
        try pairModelModifier.delete(currencyPair: pair)
        pairsChanged()
    }
    
    func pairsChanged() {
        observeStateChange?(constructState())
    }

    private func constructState() -> State {
        do {
            let storedPairs = try pairModelRetriever.storedCurrencyPairs()
            if !storedPairs.isEmpty {
                return .pairs(storedPairs)
            } else {
                return .noPairs
            }
        } catch let error {
            return .error(error)
        }
    }
    
}
