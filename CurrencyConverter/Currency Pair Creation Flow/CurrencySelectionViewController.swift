import UIKit

class CurrencySelectionViewController: UIViewController {

    private let currencyRepresentations: [CurrencyRepresentation]
    
    init(currencyRepresentations: [CurrencyRepresentation]) {
        self.currencyRepresentations = currencyRepresentations
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }


}
