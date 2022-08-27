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
    func fetchUpcomingData()
    func setUpcomingData(for index: Int)
}


class UpcomingViewModel {
    
    weak var delegate: UpcomingViewProtocol?
    
    init(delegate: UpcomingViewProtocol) {
        self.delegate = delegate
    }
    
    private var upcomingMovies: [Movie] = []
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
    
    func fetchUpcomingData() {
        ApiCaller.shared.getUpcomingMovies { [weak self] upcomingMoviesData, _ in
            self?.upcomingMovies = upcomingMoviesData ?? []
            self?.delegate?.updateViews()
        }
    }
    
    func setUpcomingData(for index: Int) {
        let titles = upcomingMovies[index]
        
        guard let titleName = titles.title ?? titles.original_title else { return }
        
        ApiCaller.shared.searchTrailer(with: titleName) { trailerData, _ in
            guard let trailerData = trailerData else {
                return
            }
            DispatchQueue.main.async {
                let vc = TitlePreviewViewController()
                let model = TitlePreviewModel(title: titleName, overview: titles.overview, youtubeView: trailerData)
                vc.configure(with: model)
                self.delegate?.navigateToNextView(to: vc)
            }
        }
    }

}
