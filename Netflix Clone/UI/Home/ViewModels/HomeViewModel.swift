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
    func getTrendigMovies(with cell: CollectionViewTableViewCell)
    func getPopularMovies(with cell: CollectionViewTableViewCell)
    func getTrendingTvShows(with cell: CollectionViewTableViewCell)
}

final class homeViewModel {
    private weak var viewDelegate: HomeViewControllerProtocol?
    var titleSections = ["Trending Movies", "Popular", "Trending Tv", "Upcoming Movies" ,"Top Rated"]
    var trendingMovies: [Movie] = []
    var popularMovies: [Movie] = []
    
    init(viewDelegate: HomeViewControllerProtocol) {
        self.viewDelegate = viewDelegate
    }
    
}

extension homeViewModel: homeViewModelProtocol {
    
    func setTitles(for index: Int) -> String {
        return titleSections[index]
    }
    
    var sectionsCount: Int {
        titleSections.count
    }
    
    func onViewsLoaded() {
    }
    
    func getTrendigMovies(with cell: CollectionViewTableViewCell) {
        ApiCaller.shared.getTrendingMovies { dataTrendingMovies, _ in
            cell.configureMovies(with: dataTrendingMovies ?? [])
        }
    }
    
    func getPopularMovies(with cell: CollectionViewTableViewCell) {
        ApiCaller.shared.getPopularMovies { popularMoviesData, _ in
            cell.configureMovies(with: popularMoviesData ?? [])
        }
    }
    
    func getTrendingTvShows(with cell: CollectionViewTableViewCell) {
        ApiCaller.shared.getTrendingTv { dataTrendingTv, _ in
            cell.configureMovies(with: dataTrendingTv ?? [])
        }
    }
    
}
