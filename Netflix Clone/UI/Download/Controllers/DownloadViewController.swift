//
//  DownloadViewController.swift
//  Netflix Clone
//
//  Created by Fran Alarza on 28/7/22.
//

import UIKit

protocol DownloadViewControllerProtocol: AnyObject {
    func updateViews()
    func navigateToNextView(to controller: TitlePreviewViewController)
    func navigateToNextScreen(with nextScreen: TitlePreviewViewController)
}

class DownloadViewController: UIViewController {
    
    var viewModel: DownloadsViewModelProtocol?
    
    private let downloadsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .systemBackground
        table.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        view.addSubview(downloadsTable)
        configureupcomingTable()
        viewModel?.fetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.viewModel?.fetchLocalStorageForDownload()
        }
    }
    
    func configureupcomingTable() {
        downloadsTable.delegate = self
        downloadsTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadsTable.frame = view.bounds
    }
    
}

extension DownloadViewController: DownloadViewControllerProtocol {
    func navigateToNextView(to controller: TitlePreviewViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.downloadsTable.reloadData()
        }
    }
    
    func navigateToNextScreen(with nextScreen: TitlePreviewViewController) {
        navigationController?.pushViewController(nextScreen, animated: true)
    }
}

extension DownloadViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            viewModel?.deleteItem(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            break
        }
    }
}

extension DownloadViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.moviesItemsCount ?? 0
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
        viewModel?.setDataForDetail(for: indexPath.row)
    }
    
}
