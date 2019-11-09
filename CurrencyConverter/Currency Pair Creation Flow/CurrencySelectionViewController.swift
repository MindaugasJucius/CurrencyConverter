import UIKit

class CurrencySelectionViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private let selected: (CurrencyRepresentation) -> ()
    private let currencyRepresentations: [CurrencyRepresentation]
    
    private lazy var dataSource: UITableViewDiffableDataSource<String, CurrencyRepresentation> = {
        return UITableViewDiffableDataSource<String, CurrencyRepresentation>(
            tableView: tableView,
            cellProvider: { tableView, indexPath, currencyRepresentation in
                let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath)
                cell.textLabel?.text = currencyRepresentation.currency.identifier
                cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
                if !currencyRepresentation.selectable {
                    cell.textLabel?.textColor = .secondaryLabel
                } else {
                    cell.textLabel?.textColor = .label
                }
                return cell
            }
        )
    }()
    
    init(currencyRepresentations: [CurrencyRepresentation],
         selected: @escaping (CurrencyRepresentation) -> ()) {
        self.currencyRepresentations = currencyRepresentations
        self.selected = selected
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
