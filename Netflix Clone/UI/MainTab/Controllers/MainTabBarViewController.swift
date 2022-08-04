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
        let upcomingVC = UINavigationController(rootViewController: UpcommingViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let downloadVC = UINavigationController(rootViewController: DownloadViewController())
        
        setViewControllers([navControllerHome, upcomingVC, searchVC, downloadVC], animated: true)
        
        navControllerHome.tabBarItem.image = UIImage(systemName: "house")
        navControllerHome.tabBarItem.title = "Home"
        
        upcomingVC.tabBarItem.image = UIImage(systemName: "play.circle")
        upcomingVC.tabBarItem.title = "Coming Soon"
        
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        searchVC.tabBarItem.title = "Top Searches"
        
        downloadVC.tabBarItem.image = UIImage(systemName: "arrow.down")
        downloadVC.tabBarItem.title = "Downloads"
        
        tabBar.tintColor = .label
        
    }

}

