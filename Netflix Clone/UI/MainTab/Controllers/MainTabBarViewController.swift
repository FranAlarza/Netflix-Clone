//
//  ViewController.swift
//  Netflix Clone
//
//  Created by Fran Alarza on 28/7/22.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    
    func configureTabBar() {
        let homeVC = HomeViewController()
        homeVC.viewModel = homeViewModel(viewDelegate: homeVC)
        let navControllerHome = UINavigationController(rootViewController: homeVC)
        
        let upcomingVC = UpcommingViewController()
        upcomingVC.viewModel = UpcomingViewModel(delegate: upcomingVC)
        let navControllerUpcoming = UINavigationController(rootViewController: upcomingVC)
        
        let searchVC = SearchViewController()
        searchVC.viewModel = SearchViewModel(delegate: searchVC)
        let navControllerSearch = UINavigationController(rootViewController: searchVC)
        
        let downloadVC = DownloadViewController()
        downloadVC.viewModel = DownloadsViewModel(delegate: downloadVC)
        let navControlerDownload = UINavigationController(rootViewController: downloadVC)
        
        setViewControllers([navControllerHome, navControllerUpcoming, navControllerSearch, navControlerDownload], animated: true)
        
        navControllerHome.tabBarItem.image = UIImage(systemName: "house")
        navControllerHome.tabBarItem.title = "Home"
        
        navControllerUpcoming.tabBarItem.image = UIImage(systemName: "play.circle")
        navControllerUpcoming.tabBarItem.title = "Coming Soon"
        
        navControllerSearch.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        navControllerSearch.tabBarItem.title = "Top Searches"
        
        navControlerDownload.tabBarItem.image = UIImage(systemName: "arrow.down")
        navControlerDownload.tabBarItem.title = "Downloads"
        
        tabBar.tintColor = .label
        
    }

}

