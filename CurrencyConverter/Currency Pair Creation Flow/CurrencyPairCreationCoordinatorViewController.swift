//
//  CurrencyPairCreationCoordinatorViewController.swift
//  CurrencyConverter
//
//  Created by Mindaugas Jucius on 09/11/2019.
//

import UIKit

class CurrencyPairCreationCoordinatorViewController: UINavigationController {

    typealias CompleteSelection = (base: Currency, target: Currency)
    
    private let currencyPairModelController = CurrencyPairModelController(
        currencyPairPersister: CurrencyPairPersistenceController()
    )
    
    private let currenciesModelController = CurrenciesModelController()
    
    private lazy var currencyPairCreationViewModel = CurrencyPairCreationViewModel(
        currenciesModelController: currenciesModelController,
        currencyPairModelController: currencyPairModelController
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
        
    }

    func performPairCreationFlow(completion: @escaping (CurrencyPair) -> ()) {
        do {
            try currencyPairCreationViewModel.fetchStoredValues()
            
            startCreationFlowSequence { [unowned self] selectedCurrencies in
                do {
                    let pair = try self.currencyPairModelController.constructCurrencyPair(
                        base: selectedCurrencies.base,
                        convertTo: selectedCurrencies.target
                    )
                    try self.currencyPairModelController.store(currencyPair: pair)
                    completion(pair)
                } catch let error {
                    
                }
            }
        } catch let error {
            
        }
    }
    
    private func startCreationFlowSequence(completion: @escaping (CompleteSelection) -> ()) {
        let selectConversionTarget = pushConversionTargetSelection(completion: completion)
        
        pushBaseCurrencySelection { base in
            selectConversionTarget(base)
        }
    }
    
    private func pushBaseCurrencySelection(completion: @escaping (Currency) -> ()) {
        let allCurrencies = currencyPairCreationViewModel.currencyRepresentations()
        let baseCurrencySelectionVC = CurrencySelectionViewController(
            currencyRepresentations: allCurrencies,
            selected: completion
        )
        pushViewController(baseCurrencySelectionVC, animated: true)
    }

    private func pushConversionTargetSelection(completion: @escaping (CompleteSelection) -> ()) -> (Currency) -> () {
        return { [unowned self] base in
            let possibleTargetCurrencies = self.currencyPairCreationViewModel.currencyRepresentations(for: base)
            let targetCurrencySelectionVC = CurrencySelectionViewController(
                currencyRepresentations: possibleTargetCurrencies,
                selected: { target in
                    completion((base, target))
                }
            )
            self.pushViewController(targetCurrencySelectionVC, animated: true)
        }
    }
    
}
