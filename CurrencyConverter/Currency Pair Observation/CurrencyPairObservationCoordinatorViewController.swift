//
//  CurrencyPairObservationCoordinatorViewController.swift
//  CurrencyConverter
//
//  Created by Mindaugas Jucius on 10/11/2019.
//

import UIKit

class CurrencyPairObservationCoordinatorViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let pairModelController = CurrencyPairModelController(
            currencyPairPersister: CurrencyPairPersistenceController()
        )
        
        let pairsViewModel = CurrencyPairsViewModel(
            pairModelModifier: pairModelController,
            pairModelRetriever: pairModelController
        )
        
        viewControllers = [CurrencyPairsViewController(viewModel: pairsViewModel)]
    }

}
