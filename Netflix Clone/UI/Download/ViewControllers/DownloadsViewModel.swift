//
//  DownloadsViewModel.swift
//  Netflix Clone
//
//  Created by Fran Alarza on 27/8/22.
//

import Foundation

protocol DownloadsViewModelProtocol {
    func onViewsLoaded()
    var moviesItemsCount: Int { get }
    func setModel(for index: Int) -> TitleItem
    func fetchLocalStorageForDownload()
    func deleteItem(at indexpath: IndexPath)
    func setDataForDetail(for index: Int)
}


class DownloadsViewModel {
    
    weak var delegate: DownloadViewControllerProtocol?
    
    init(delegate: DownloadViewControllerProtocol) {
        self.delegate = delegate
    }
    
    private var movies: [TitleItem] = []
}

extension DownloadsViewModel: DownloadsViewModelProtocol {

    func onViewsLoaded() {
        //fetchUpcomingData()
    }
    
    var moviesItemsCount: Int {
        movies.count
    }
    
    func setModel(for index: Int) -> TitleItem {
        return movies[index]
    }
    
    func fetchLocalStorageForDownload() {
        DataPersistenceManager.shared.fetchingTitlesFromDatabase { [weak self] result, _ in
            guard let result = result else {
                return
            }
            self?.movies = result
            self?.delegate?.updateViews()
            
        }
    }
    
    func deleteItem(at indexpath: IndexPath) {
        DataPersistenceManager.shared.deleteTitleWith(model: movies[indexpath.row]) {[weak self] _, error in
            print("Deleted form Database")
            print(error?.localizedDescription ?? "")
            self?.movies.remove(at: indexpath.row)
        }
    }
    
    func setDataForDetail(for index: Int) {
        let discover = movies[index]
        guard let discoverTitle = movies[index].title ?? movies[index].original_title else { return }
        
        ApiCaller.shared.searchTrailer(with: discoverTitle) { [weak self] result, _ in
            guard let result = result else {
                return
            }
            DispatchQueue.main.async {
                let vc = TitlePreviewViewController()
                vc.configure(with: TitlePreviewModel(title: discoverTitle, overview: discover.overview ?? "", youtubeView: result))
                self?.delegate?.navigateToNextScreen(with: vc)
            }
        }
    }
}




