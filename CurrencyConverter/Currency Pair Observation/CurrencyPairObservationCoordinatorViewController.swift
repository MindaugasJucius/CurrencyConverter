//
//  CurrencyPairObservationCoordinatorViewController.swift
//  CurrencyConverter
//
//  Created by Mindaugas Jucius on 10/11/2019.
//

import UIKit

class CurrencyPairObservationCoordinatorViewController: UINavigationController {

    private let pairModelController = CurrencyPairModelController(
        currencyPairPersister: CurrencyPairPersistenceController()
    )
    
    private lazy var pairsViewModel = CurrencyPairsViewModel(
        pairModelModifier: pairModelController,
        pairModelRetriever: pairModelController,
        exhangeRateRequestPerformer: ExchangeRateRequestPerformer()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
        let pairsViewController = CurrencyPairsViewController(viewModel: pairsViewModel,
                                                              selectedCreatePair: self.initiateCreatePairFlow())
        viewControllers = [pairsViewController]
    }

    private func initiateCreatePairFlow() {
        let pairCreationCoordinator = CurrencyPairCreationCoordinatorViewController()
        pairCreationCoordinator.performPairCreationFlow { [unowned self] _ in
            self.pairsViewModel.pairsChanged()
            self.dismiss(animated: true, completion: nil)
        }
        
        present(pairCreationCoordinator, animated: true, completion: nil)
    }
    
}
