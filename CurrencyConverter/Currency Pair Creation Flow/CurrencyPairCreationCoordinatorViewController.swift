//
//  CurrencyPairCreationCoordinatorViewController.swift
//  CurrencyConverter
//
//  Created by Mindaugas Jucius on 09/11/2019.
//

import UIKit

class CurrencyPairCreationCoordinatorViewController: UINavigationController {

    private let currencyPairModelController = CurrencyPairModelController(
        currencyPairPersister: CurrencyPairPersistenceController()
    )
    
    private let currenciesModelController = CurrenciesModelController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startPairCreationFlow { pair in
            
        }
    }
    
    func startPairCreationFlow(completion: (CurrencyPair) -> ()) {
        let currencyPairCreationViewModel = CurrencyPairCreationViewModel(
            currenciesModelController: currenciesModelController,
            currencyPairModelController: currencyPairModelController
        )
        
        let baseCurrencySelectionVC = CurrencySelectionViewController(
            currencyRepresentations: currencyPairCreationViewModel.currencyRepresentations()
        )
        
        baseCurrencySelectionVC.title = NSLocalizedString("select_first_currency", comment: "")
        
        viewControllers = [baseCurrencySelectionVC]
    }

}
