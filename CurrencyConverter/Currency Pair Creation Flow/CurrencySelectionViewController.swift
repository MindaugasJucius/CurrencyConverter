import UIKit

class CurrencySelectionViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private static let cellReuseIdentifier = "CurrencySelectionCell"
    
    private let selected: (Currency) -> ()
    private let currencyRepresentations: [CurrencyRepresentation]
    
    private lazy var dataSource: UITableViewDiffableDataSource<String, CurrencyRepresentation> = {
        return UITableViewDiffableDataSource<String, CurrencyRepresentation>(
            tableView: tableView,
            cellProvider: { tableView, indexPath, currencyRepresentation in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CurrencySelectionViewController.cellReuseIdentifier,
                    for: indexPath
                )
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
         selected: @escaping (Currency) -> ()) {
        self.currencyRepresentations = currencyRepresentations
        self.selected = selected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        configureTableView()
        applySnapshot()
    }

    private func configureTableView() {
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: CurrencySelectionViewController.cellReuseIdentifier)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.rowHeight = 65
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<String, CurrencyRepresentation>.init()
        snapshot.appendSections([""])
        snapshot.appendItems(currencyRepresentations)
        dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
    }
        
}

extension CurrencySelectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let currencyRepresentation = dataSource.itemIdentifier(for: indexPath),
            currencyRepresentation.selectable else {
            return nil
        }
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currencyRepresentation = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        selected(currencyRepresentation.currency)
    }
    
}
