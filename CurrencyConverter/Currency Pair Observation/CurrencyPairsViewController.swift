//
//  CurrencyPairsViewController.swift
//  CurrencyConverter
//
//  Created by Mindaugas Jucius on 10/11/2019.
//

import UIKit

class CurrencyPairsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private static let cellReuseIdentifier = "CurrencySelectionCell"
    
    private lazy var dataSource: UITableViewDiffableDataSource<String, CurrencyPair> = {
        return UITableViewDiffableDataSource<String, CurrencyPair>(
            tableView: tableView,
            cellProvider: { tableView, indexPath, currencyPair in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CurrencyPairsViewController.cellReuseIdentifier,
                    for: indexPath
                )
                cell.textLabel?.text = currencyPair.queryParameter
                cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
                return cell
            }
        )
    }()
    
    private let viewModel: CurrencyPairsViewModel
    
    init(viewModel: CurrencyPairsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        configureTableView()
        viewModel.observeStateChange = { [unowned self] state in
            self.update(to: state)
        }
    }
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: CurrencyPairsViewController.cellReuseIdentifier)
        tableView.dataSource = dataSource
//        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.rowHeight = 65
    }
    
    private func update(to state: CurrencyPairsViewModel.State) {
        switch state {
        case .pairs(let pairs):
            applySnapshot(pairs: pairs)
        default:
            print("miegam")
        }
    }

    private func applySnapshot(pairs: [CurrencyPair]) {
        var snapshot = NSDiffableDataSourceSnapshot<String, CurrencyPair>.init()
        snapshot.appendSections([""])
        snapshot.appendItems(pairs)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }

}
