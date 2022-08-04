//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Fran Alarza on 28/7/22.
//

import UIKit

protocol HomeViewControllerProtocol: AnyObject {
    func updateViews()
}

/* ["Trending Movies", "Popular", "Trending Tv", "Upcoming Movies" ,"Top Rated"] */

enum Sections: Int {
    case TrendingMovies = 0
    case Popular = 1
    case TrendingTv = 2
    case UpcomingMovies = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    var viewModel: homeViewModelProtocol?
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configHomeFeedTable()
        headerConfiguration()
        configureNavBar()
        view.addSubview(homeFeedTable)
        view.backgroundColor = .systemBackground
        viewModel?.onViewsLoaded()
        ApiCaller.shared.getTrendingTv { dataTrendingTv, error in
            print(dataTrendingTv)
            print(error)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    func configHomeFeedTable() {
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
    }
    
    func headerConfiguration() {
        let headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
    }
    
    private func configureNavBar() {
        let containerView = UIControl(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        let imageSearch = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        imageSearch.image = UIImage(named: "netflix")
        containerView.addSubview(imageSearch)
        let searchBarButtonItem = UIBarButtonItem(customView: containerView)
        searchBarButtonItem.width = 20
        navigationItem.leftBarButtonItem = searchBarButtonItem
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"),
                            style: .done,
                            target: self,
                            action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"),
                            style: .done,
                            target: self,
                            action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
    
}


extension HomeViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.sectionsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.setTitles(for: section)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 10, y: header.bounds.origin.y, width: 100, height: header.bounds.width)
        header.textLabel?.textColor = .white
        header.textLabel?.text? = header.textLabel?.text?.lowercased().capitalized ?? ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            ApiCaller.shared.getTrendingMovies { dataTrendingMovies, _ in
                cell.configureMovies(with: dataTrendingMovies ?? [])
            }
            
        case Sections.Popular.rawValue:
            ApiCaller.shared.getPopularMovies { dataPopularMovies, _ in
                cell.configureMovies(with: dataPopularMovies ?? [])
            }
            
        case Sections.TrendingTv.rawValue:
            ApiCaller.shared.getTrendingTv { dataTrendingTv, _ in
                cell.configureMovies(with: dataTrendingTv ?? [])
            }
            
        case Sections.UpcomingMovies.rawValue:
            ApiCaller.shared.getUpcomingMovies { dataUpcomingMovies, _ in
                cell.configureMovies(with: dataUpcomingMovies ?? [])
            }
            
        case Sections.TopRated.rawValue:
            ApiCaller.shared.getTopRated { dataTopRated, _ in
                cell.configureMovies(with: dataTopRated ?? [])
            }
            
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
}

extension HomeViewController: HomeViewControllerProtocol {
    func updateViews() {
        DispatchQueue.main.async { [weak self] in
            self?.homeFeedTable.reloadData()
        }
    }
}
