import UIKit

/// An object that conforms to `UITableViewDataSource` that wraps `TableViewDiffableDataSource`.
final class TableViewDiffableDataSource<Section: Hashable, Item: Hashable>: NSObject, UITableViewDataSource {

    /// A closure for creating and configuring an item cell with a model.
    /// - Parameters:
    ///   - tableView: The collection view the cell will be configured for.
    ///   - indexPath: The index path of the cell.
    ///   - item: The items to display in the your videos collection.
    typealias CellConfiguration = (_ tableView: UITableView, _ indexPath: IndexPath, _ item: Item) -> UITableViewCell

    private lazy var dataSource: UITableViewDiffableDataSource<Section, Item>? = {
        guard let tableView = tableView else {
            return nil
        }

        let dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView) { [weak self] tableView, indexPath, item in
            guard let self = self else {
                return UITableViewCell()
            }

            return self.cellConfiguration(tableView, indexPath, item)
        }

        return dataSource
    }()

    private let cellConfiguration: CellConfiguration
    private weak var tableView: UITableView?

    /// Creates a `TableViewDiffableDataSource`.
    /// - Parameter tableView: The `UITableView` that this data source is providing data for.
    /// - Parameter cellConfiguration: A closure for creating and configuring a cell with a model.
    init(tableView: UITableView, cellConfiguration: @escaping CellConfiguration) {
        self.tableView = tableView
        self.cellConfiguration = cellConfiguration
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        dataSource?.numberOfSections(in: tableView) ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource?.tableView(tableView, numberOfRowsInSection: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        dataSource?.tableView(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let section = self.section(for: section) as? TableViewSection {
            return section.headerTitle
        }

        return nil
    }

    // MARK: - TableViewDiffableDataSource

    /// Updates the data source with the provided snapshot.
    /// - Parameter snapshot: A `NSDiffableDataSourceSnapshot<Section, Item>` to apply to the data source.
    func updateSnapshot(_ snapshot: NSDiffableDataSourceSnapshot<Section, Item>) {
        dataSource?.apply(snapshot)
    }

    /// Provides a `Section` for the given section index.
    /// - Parameter index: The index of the section.
    func section(for index: Int) -> Section? {
        guard let currentSnapshot = dataSource?.snapshot(), index < currentSnapshot.sectionIdentifiers.count, index >= 0 else {
            return nil
        }

        return currentSnapshot.sectionIdentifiers[index]
    }
}

