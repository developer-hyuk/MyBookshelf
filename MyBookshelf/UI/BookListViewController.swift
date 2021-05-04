//
//  ListViewController.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/02.
//

import UIKit

extension BookListViewController {
    private static let fakeCount = 1
}

final class BookListViewController: UIViewController {
    
    private lazy var searchContainerViewController: SearchContainerViewController = {
        let container = SearchContainerViewController()
        container.onSelectKeyword = { [weak self] keyword in
            guard let self = self else { return }
            
            self.bookListLoader.search(with: keyword)
            
            self.searchViewController.searchBar.text = keyword
            self.searchViewController.searchBar.resignFirstResponder()
            self.searchViewController.searchBar.showsCancelButton = false
        }
        return container
    }()
    
    private lazy var searchViewController = SearchViewController(searchResultsController: searchContainerViewController)
    
    private lazy var tableView = UITableView()
    private lazy var bookListLoader = BookListLoader()
    private lazy var isSearchFirstOpen = false
    
    private var books: [Book] {
        return bookListLoader.books
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchController()
        setupSearchButton()
        setupHandler()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.layoutIfNeeded()
        
        if !isSearchFirstOpen {
            isSearchFirstOpen = true
            showSearchViewController()
        }
    }
}

private extension BookListViewController {
    
    func setupSearchController() {
        searchViewController.searchResultsUpdater = self
        searchViewController.searchBar.delegate = self
        searchViewController.delegate = self
        
        searchViewController.dimsBackgroundDuringPresentation = false
        searchViewController.hidesNavigationBarDuringPresentation = false
        searchViewController.searchBar.searchBarStyle = .minimal
        searchViewController.searchBar.showsCancelButton = false
        definesPresentationContext = true
    }
    
    func setupSearchButton() {
        navigationItem.titleView = searchViewController.searchBar
        navigationItem.rightBarButtonItem = nil
    }
    
    func setupTableView() {
        tableView.register(cell: BookListCell.self)
        tableView.register(cell: EmptyListCell.self)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func showSearchViewController() {
        searchViewController.searchBar.becomeFirstResponder()
    }
    
    func setupHandler() {
        bookListLoader.onChangeStatus = { [weak self] status in
            guard let self = self else { return }
            
            switch status {
            case .initialization, .dataChanged:
                let separatorStyle: UITableViewCell.SeparatorStyle = self.books.isEmpty ? .none : .singleLine
                self.tableView.separatorStyle = separatorStyle
                self.tableView.reloadData()
            case .fail(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
}

// MARK: - Search Delegate
extension BookListViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchKeyword = searchBar.text,
              !searchKeyword.isEmpty else { return }
        
        bookListLoader.search(with: searchKeyword)
        searchViewController.dismiss(animated: true, completion: nil)
        searchViewController.searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchViewController.searchBar.showsCancelButton = false
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        searchContainerViewController.recentryQueries = RecentSearchQuery.shared.recentQueries
        searchViewController.searchBar.showsCancelButton = true
    }
}

// MARK: - TableView DataSource
extension BookListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.isEmpty ? Self.fakeCount : books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if books.isEmpty {
            return tableView.dequeueReusableCell(type: EmptyListCell.self, indexPath: indexPath)
        } else {
            let row = indexPath.row
            let cell = tableView.dequeueReusableCell(type: BookListCell.self, indexPath: indexPath)
            cell.set(data: books[row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if books.isEmpty {
            return EmptyListCell.cellHeight
        } else {
            return BookListCell.cellHeight
        }
    }
}

// MARK: - TableView Delegate
extension BookListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        guard let book = books[safe: indexPath.row] else { return }
        
        let viewController = BookDetailViewController(book: book)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let lastCell = tableView.visibleCells.last,
              let lastIndex = tableView.indexPath(for: lastCell)?.row else { return }
        
        bookListLoader.searchNextIfNeeded(lastIndex: lastIndex)
    }
}
