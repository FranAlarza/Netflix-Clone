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

enum Sections: Int {
    case TrendingMovies = 0
    case Popular = 1
    case TrendingTv = 2
    case UpcomingMovies = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    var viewModel: homeViewModelProtocol?
    private var heroTitle: Movie?
    private var heroHeader: HeroHeaderView?
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configHomeFeedTable()
        getHeroTitle()
        configureNavBar()
        view.addSubview(homeFeedTable)
        view.backgroundColor = .systemBackground
        viewModel?.onViewsLoaded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    func configHomeFeedTable() {
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        heroHeader = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = heroHeader
    }
    
    func getHeroTitle() {
        ApiCaller.shared.getTrendingMovies { movies, error in
            let selectedTitle = movies?.randomElement()
            self.heroTitle = movies?.randomElement()
            self.heroHeader?.configure(with: selectedTitle?.poster_path ?? "")
        }
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
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            viewModel?.getTrendigMovies(with: cell)
            
        case Sections.Popular.rawValue:
            viewModel?.getPopularMovies(with: cell)
            
        case Sections.TrendingTv.rawValue:
            viewModel?.getTrendingTvShows(with: cell)
            
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

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTap(with cell: CollectionViewTableViewCell, model: TitlePreviewModel) {
        DispatchQueue.main.async { [weak self] in
            let nextVC = TitlePreviewViewController()
            nextVC.configure(with: model)
            self?.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
}
