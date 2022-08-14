//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Fran Alarza on 28/7/22.
//

import UIKit

protocol SearchViewProtocol {
    func reloadData()
}

class SearchViewController: UIViewController {
    
    var viewModel: SearchViewModelProtocol?
    
    private let discoverTable: UITableView = {
        let discoverTable = UITableView(frame: .zero, style: .grouped)
        discoverTable.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        return discoverTable
    }()
    
    private var searchResults: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search Tv Shows or Movies"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        configureDiscoverTable()
        navigationItem.searchController = searchResults
        view.addSubview(discoverTable)
        view.backgroundColor = .systemBackground
        configureNavigationController()
        viewModel?.onViewsLoaded()
        searchResults.searchResultsUpdater = self
    }
    
    func configureDiscoverTable() {
        discoverTable.delegate = self
        discoverTable.dataSource = self
    }
    
    func configureNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
}

extension SearchViewController: SearchViewProtocol {
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.discoverTable.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.discoverMoviesCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as? UpcomingTableViewCell else {
            return UITableViewCell()
        }
        
        guard let discoverMovie = viewModel?.getDiscoverMovies(for: indexPath.row) else { return UITableViewCell() }
        cell.setData(for: discoverMovie)
        return cell
    }
    
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultViewController else { return }
        
        ApiCaller.shared.searchMovies(with: query) { results, _ in
            resultController.resultsMovies = results ?? []
            DispatchQueue.main.async {
                resultController.collectionResults.reloadData()
            }
        }
                
                
    }
}


