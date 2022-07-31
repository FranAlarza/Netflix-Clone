//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Fran Alarza on 28/7/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configHomeFeedTable()
        headerConfiguration()
        view.addSubview(homeFeedTable)
        view.backgroundColor = .systemBackground
        
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
    
}

extension HomeViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath)
        
        cell.backgroundColor = .lightGray
        return cell
    }
    
}
