//
//  CurrencyPairsViewController.swift
//  CurrencyConverter
//
//  Created by Mindaugas Jucius on 10/11/2019.
//

import UIKit

class CurrencyPairsViewController: UIViewController {
        
    @IBOutlet private weak var tableView: UITableView!
    
    enum SectionItem: Hashable {
        case pair(CurrencyPair)
        case compactAddPair
        case expandedAddPair
    }

    private static let pairCellReuseIdentifier = "CurrencyPairCell"
    private static let addPairCompactCellReuseIdentifier = "AddPairCompactCell"
    private static let addPairExpandedCellReuseIdentifier = "AddPairExpandedCell"
    
    private lazy var dataSource: UITableViewDiffableDataSource<String, SectionItem> = {
        return UITableViewDiffableDataSource<String, SectionItem>(
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
                default:
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: CurrencyPairsViewController.addPairCompactCellReuseIdentifier,
                        for: indexPath
                    )
                    return cell
                }
            }
        )
    }()
    
    private let viewModel: CurrencyPairsViewModel
    private let createPair: () -> ()
    
    init(viewModel: CurrencyPairsViewModel, selectedCreatePair: @autoclosure @escaping () -> ()) {
        self.viewModel = viewModel
        self.createPair = selectedCreatePair
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
    }
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: CurrencyPairsViewController.pairCellReuseIdentifier)
        
        let nib = UINib(nibName: String(describing: AddPairTableViewCell.self), bundle: nil)
        tableView.register(nib,
                           forCellReuseIdentifier: CurrencyPairsViewController.addPairCompactCellReuseIdentifier)
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
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
        var snapshot = NSDiffableDataSourceSnapshot<String, SectionItem>.init()
        snapshot.appendSections(["add pair"])
        snapshot.appendItems([.compactAddPair])
        snapshot.appendSections(["currency pairs"])
        snapshot.appendItems(pairs.map { SectionItem.pair($0) })
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }

}

extension CurrencyPairsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let sectionItem = dataSource.itemIdentifier(for: indexPath),
            sectionItem == .compactAddPair || sectionItem == .expandedAddPair else {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        createPair()
    }
    
}
