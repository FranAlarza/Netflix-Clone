//
//  UpcomingViewModel.swift
//  Netflix Clone
//
//  Created by Fran Alarza on 5/8/22.
//

import Foundation

protocol UpcomingViewModelProtocol {
    func onViewsLoaded()
    var upcomingMoviesCount: Int { get }
    func setModel(for index: Int) -> Movie
}


class UpcomingViewModel {
    weak var delegate: UpcomingViewProtocol?
    private var upcomingMovies: [Movie] = []
    
    init(delegate: UpcomingViewProtocol) {
        self.delegate = delegate
    }
    
    func fetchUpcomingData() {
        ApiCaller.shared.getUpcomingMovies { [weak self] upcomingMoviesData, _ in
            self?.upcomingMovies = upcomingMoviesData ?? []
            self?.delegate?.updateViews()
        }
    }
}

extension UpcomingViewModel: UpcomingViewModelProtocol {
    
    func onViewsLoaded() {
        fetchUpcomingData()
    }
    
    var upcomingMoviesCount: Int {
        upcomingMovies.count
    }
    
    func setModel(for index: Int) -> Movie {
        return upcomingMovies[index]
    }

}
