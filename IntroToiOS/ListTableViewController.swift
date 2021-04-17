//
//  ListTableViewController.swift
//  IntroToiOS
//
//  Created by Daisy Ramos on 4/16/21.
//

import UIKit

class ListTableViewController: UITableViewController {

    private lazy var tableViewDataSource = TableViewDiffableDataSource<TableViewSection, Data>(tableView: tableView, cellConfiguration: { [weak self] tableView, indexPath, model in
        guard let self = self else {
            return UITableViewCell()
        }
        return self.configureCell(tableView: tableView, indexPath: indexPath, model: model)
    })

    private var snapshot = NSDiffableDataSourceSnapshot<TableViewSection, Data>()

    private func configureCell(tableView: UITableView, indexPath: IndexPath, model: Data) -> UITableViewCell {
        switch model {
            case .main:
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "DemoTableViewCell")
                cell.accessoryType = .disclosureIndicator
                cell.detailTextLabel?.text = "Subtitle"
                cell.textLabel?.text = "Main Section"

                return cell
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        snapshot.appendSections([.main])
        snapshot.appendItems([.main], toSection: .main)
        tableViewDataSource.updateSnapshot(snapshot)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = self
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sections = snapshot.sectionIdentifiers[indexPath.section]

        switch sections {
        case .main:
            performSegue(withIdentifier: "showDetail", sender: nil)
        }
    }
}
