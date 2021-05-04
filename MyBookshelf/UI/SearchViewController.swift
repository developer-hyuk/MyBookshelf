//
//  SearchViewController.swift
//  MyBookshelf
//
//  Created by DH on 2021/05/02.
//

import UIKit

final class SearchViewController: UISearchController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

final class SearchContainerViewController: UITableViewController {
    var recentryQueries: [String] = [] {
        didSet { tableView.reloadData() }
    }
    
    var onSelectKeyword: ((String) -> Void)?
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentryQueries.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = recentryQueries[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let keyword = recentryQueries[safe: indexPath.row] else { return }
        onSelectKeyword?(keyword)
        dismiss(animated: true, completion: nil)
    }
}
