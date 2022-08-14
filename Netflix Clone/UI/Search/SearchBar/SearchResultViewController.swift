//
//  SearchResultViewController.swift
//  Netflix Clone
//
//  Created by Fran Alarza on 13/8/22.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    var resultsMovies: [Movie] = []
    
    let collectionResults: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 10, height: 250)
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureColectionResults()
        view.addSubview(collectionResults)
    }
    
    func configureColectionResults() {
        collectionResults.dataSource = self
        collectionResults.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        collectionResults.frame = view.bounds
    }

}

extension SearchResultViewController: UICollectionViewDelegate {
    
}

extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        resultsMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        let posterPath = resultsMovies[indexPath.row]
        
        cell.configure(with: posterPath.poster_path ?? "")
        return cell
    }
    
    
}
