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
    func setDataForDetail(for index: Int)
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
    
    func setDataForDetail(for index: Int) {
        let discover = discoverMovies[index]
        guard let discoverTitle = discoverMovies[index].title ?? discoverMovies[index].original_title else { return }
        
        ApiCaller.shared.searchTrailer(with: discoverTitle) { [weak self] result, _ in
            guard let result = result else {
                return
            }
            DispatchQueue.main.async {
                let vc = TitlePreviewViewController()
                vc.configure(with: TitlePreviewModel(title: discoverTitle, overview: discover.overview, youtubeView: result))
                self?.delegate?.navigateToNextScreen(with: vc)
            }
        }
    }
}
