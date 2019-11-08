import XCTest
@testable import CurrencyConverter

class CurrencyConverterTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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
