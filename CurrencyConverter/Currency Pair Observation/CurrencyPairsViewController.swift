//
//  CurrencyPairsViewController.swift
//  CurrencyConverter
//
//  Created by Mindaugas Jucius on 10/11/2019.
//

import UIKit

enum SectionItem: Hashable {
    case pair(CurrencyPair)
    case compactAddPair
    case expandedAddPair
}

class CurrencyPairsDataSource: UITableViewDiffableDataSource<String, SectionItem> {
    
    // No other way to provide custom behaviour to data source methods
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

class CurrencyPairsViewController: UIViewController {
        
    @IBOutlet private weak var tableView: UITableView!

    private static let pairCellReuseIdentifier = "CurrencyPairCell"
    private static let addPairCompactCellReuseIdentifier = "AddPairCompactCell"
    private static let addPairExpandedCellReuseIdentifier = "AddPairExpandedCell"
    
    private lazy var dataSource: CurrencyPairsDataSource = {
        return CurrencyPairsDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, sectionItem in
                switch sectionItem {
                case .pair(let pair):
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: CurrencyPairsViewController.pairCellReuseIdentifier,
                        for: indexPath
                    )
                    cell.textLabel?.text = pair.queryParameter
                    cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
                    return cell
                case .compactAddPair:
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: CurrencyPairsViewController.addPairCompactCellReuseIdentifier,
                        for: indexPath
                    )
                    return cell
                case .expandedAddPair:
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: CurrencyPairsViewController.addPairExpandedCellReuseIdentifier,
                        for: indexPath
                    )
                    cell.backgroundColor = .clear
                    return cell
                }
            }
        )
    }()
    
    private let viewModel: CurrencyPairsViewModel
    private let selectedCreatePair: () -> ()
    
    init(viewModel: CurrencyPairsViewModel, selectedCreatePair: @autoclosure @escaping () -> ()) {
        self.viewModel = viewModel
        self.selectedCreatePair = selectedCreatePair
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.observeStateChange = { [unowned self] state in
            self.update(to: state)
        }
        viewModel.beginRequestingExchangeRates()
    }
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: CurrencyPairsViewController.pairCellReuseIdentifier)
        
        let addPairCellNib = UINib(nibName: String(describing: AddPairTableViewCell.self), bundle: nil)
        tableView.register(addPairCellNib,
                           forCellReuseIdentifier: CurrencyPairsViewController.addPairCompactCellReuseIdentifier)
        
        let addPairExpandedCellNib = UINib(nibName: "AddPairExpandedTableViewCell", bundle: nil)
        tableView.register(addPairExpandedCellNib,
                           forCellReuseIdentifier: CurrencyPairsViewController.addPairExpandedCellReuseIdentifier)

        
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.backgroundColor = .clear
    }
    
    private func update(to state: CurrencyPairsViewModel.State) {
        switch state {
        case .pairs(let pairs):
            applySnapshot(pairs: pairs)
        case .noPairs:
            applySnapshot(pairs: [])
        default:
            print("miegam")
        }
    }

    private func deletePair(at indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath),
            case let SectionItem.pair(pair) = item else {
            return
        }
        
        try! viewModel.delete(pair: pair)
    }
    
    private func applySnapshot(pairs: [CurrencyPair]) {
        var snapshot = NSDiffableDataSourceSnapshot<String, SectionItem>.init()
        if pairs.isEmpty {
            snapshot.appendSections(["add pair expanded"])
            snapshot.appendItems([.expandedAddPair])
        } else {
            snapshot.appendSections(["add pair"])
            snapshot.appendItems([.compactAddPair])
            snapshot.appendSections(["currency pairs"])
            snapshot.appendItems(pairs.map { SectionItem.pair($0) })
        }

        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }

}

extension CurrencyPairsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            fatalError()
        }
        
        switch item {
        case .expandedAddPair:
            return tableView.bounds.height
        default:
            return UITableView.automaticDimension
        }

    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let sectionItem = dataSource.itemIdentifier(for: indexPath),
            sectionItem == .compactAddPair || sectionItem == .expandedAddPair else {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCreatePair()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard let sectionItem = dataSource.itemIdentifier(for: indexPath),
            case SectionItem.pair = sectionItem else {
            return .none
        }

        return .delete
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction.init(style: .destructive, title: nil) { [weak self] (action, view, completion) in
            self?.deletePair(at: indexPath)
        }
        action.image = UIImage.init(systemName: "trash")
        return UISwipeActionsConfiguration.init(actions: [action])
    }
    
}
