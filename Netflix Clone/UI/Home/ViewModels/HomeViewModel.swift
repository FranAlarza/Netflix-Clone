//
//  HomeViewModel.swift
//  Netflix Clone
//
//  Created by Fran Alarza on 1/8/22.
//

import Foundation

protocol homeViewModelProtocol {
    func onViewsLoaded()
    var sectionsCount: Int { get }
    func setTitles(for index: Int) -> String
    func setMoviePoster(for index: Int) -> String
}

final class homeViewModel {
    private weak var viewDelegate: HomeViewControllerProtocol?
    var titleSections = ["Trending Movies", "Popular", "Trending Tv", "Upcoming Movies" ,"Top Rated"]
    private var trendingMovies: [Movie] = []
    
    init(viewDelegate: HomeViewControllerProtocol) {
        self.viewDelegate = viewDelegate
    }
    
    func loadTrendingMovies() {
        ApiCaller.shared.getTrendingMovies { [weak self] dataTrendingMovies, _ in
            self?.trendingMovies = dataTrendingMovies ?? []
            self?.viewDelegate?.updateViews()
        }
    }
    
}

extension homeViewModel: homeViewModelProtocol {
    func setMoviePoster(for index: Int) -> String {
        return trendingMovies[index].poster_path
    }
    
    func setTitles(for index: Int) -> String {
        return titleSections[index]
    }
    
    var sectionsCount: Int {
        titleSections.count
    }
    
    func onViewsLoaded() {
        loadTrendingMovies()
    }
    
    
}
