import XCTest
@testable import CurrencyConverter

class CurrenciesModelControllerTests: XCTestCase {

    func testCurrenciesLoad() {
        let currenciesModelController = CurrenciesModelController()
        do {
            let loadedCurrencies = try currenciesModelController.loadCurrencies()
            XCTAssert(loadedCurrencies.count != 0)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }

}
