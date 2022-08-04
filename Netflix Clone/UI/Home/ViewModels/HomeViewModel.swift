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
    
}
