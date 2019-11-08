import XCTest
@testable import CurrencyConverter

class CurrenciesModelControllerTests: XCTestCase {

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

    func testPassingCurrencyWithEqualIdentifiersThrowsError() {
        let currenciesModelController = CurrenciesModelController()
        do {
            let currency = Currency(identifier: "USD")
            let badPair = try currenciesModelController.createCurrencyPair(
                base: currency,
                convertTo: currency
            )
            XCTFail("Created currency pair with equal identifiers: \(badPair.baseCurrency.identifier)")
        } catch let currencyPairError as CurrenciesModelController.CurrencyPairError {
            XCTAssert(currencyPairError == .equalIdentifiers)
        } catch let error {
            XCTFail("Creating currency with equal identifiers throws wrong error: \(error.localizedDescription)")
        }
    }
    
    func testCorrectlyCreatesCurrencyPair() {
        let currenciesModelController = CurrenciesModelController()
        do {
            let loadedCurrencies = try currenciesModelController.loadCurrencies()
            XCTAssert(loadedCurrencies.count != 0)
        } catch let error {
            XCTFail(error.localizedDescription)
        }

    }
}
