//
//  CurrencyPairsViewModelTests.swift
//  CurrencyConverterTests
//
//  Created by Mindaugas Jucius on 10/11/2019.
//

import XCTest
@testable import CurrencyConverter

class CurrencyPairsViewModelTests: XCTestCase {
    
    func testSettingObserveClosureInvokesWithState() {
        let expectation = XCTestExpectation(description: "change handler invoked")
        let observer: (CurrencyPairsViewModel.State) -> () = { state in
            expectation.fulfill()
        }
        
        let viewModel = CurrencyPairsViewModel(
            pairModelModifier: MockCurrencyPairModelModifier(),
            pairModelRetriever: MockCurrencyPairModelRetriever()
        )
        viewModel.observeStateChange = observer
        
        wait(for: [expectation], timeout: 0.1)
    }
    
}
