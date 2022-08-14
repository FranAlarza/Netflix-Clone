//
//  SearcViewModel.swift
//  Netflix Clone
//
//  Created by Fran Alarza on 11/8/22.
//

import Foundation

protocol SearchViewModelProtocol{
    func onViewsLoaded()
    func getDiscoverMovies(for index: Int) -> Movie
    var discoverMoviesCount: Int { get }
}

class SearchViewModel {
    private var delegate: SearchViewProtocol?
    var discoverMovies: [Movie] = []
    
    init(delegate: SearchViewProtocol) {
        self.delegate = delegate
    }
    
    func fetchDiscoverMovies() {
        ApiCaller.shared.getDiscoverMovies { [weak self] movies, error in
            self?.discoverMovies = movies ?? []
            self?.delegate?.reloadData()
        }
    }
}

extension SearchViewModel: SearchViewModelProtocol {
    var discoverMoviesCount: Int {
        discoverMovies.count
    }
    
    func onViewsLoaded() {
        fetchDiscoverMovies()
    }
    
    func getDiscoverMovies(for index: Int) -> Movie {
        return discoverMovies[index]
    }
}
