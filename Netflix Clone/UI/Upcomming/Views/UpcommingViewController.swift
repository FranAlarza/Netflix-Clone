//
//  UpcommingViewController.swift
//  Netflix Clone
//
//  Created by Fran Alarza on 28/7/22.
//

import UIKit

protocol UpcomingViewProtocol: AnyObject {
    func updateViews()
    func navigateToNextView(to controller: TitlePreviewViewController)
}

class UpcommingViewController: UIViewController {
    
    var viewModel: UpcomingViewModelProtocol?
    
    private let upcomingTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .systemBackground
        table.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        configureupcomingTable()
        view.addSubview(upcomingTable)
        viewModel?.onViewsLoaded()
    }
    
    func configureupcomingTable() {
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }


}

extension UpcommingViewController: UpcomingViewProtocol {
    func navigateToNextView(to controller: TitlePreviewViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.upcomingTable.reloadData()
        }
    }
    
    
}

extension UpcommingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension UpcommingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.upcomingMoviesCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as? UpcomingTableViewCell else {
            return UITableViewCell()
        }
    
        guard let upcomingData = viewModel?.setModel(for: indexPath.row) else {
            return UITableViewCell()
        }
        cell.setData(for: upcomingData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.setUpcomingData(for: indexPath.row)
    }
    
    
}
