//
//  TitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by Fran Alarza on 18/8/22.
//

import UIKit
import WebKit

protocol TitlePreviewViewControllerProtocol: AnyObject {
    func configure(with model: TitlePreviewModel)
}

class TitlePreviewViewController: UIViewController {
    
    var viewModel: TitlePreviewViewModelProtocol?
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 20, weight: .semibold)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Movie Title"
        return title
    }()
    
    private let overviewLabel: UILabel = {
        let overview = UILabel()
        overview.font = .systemFont(ofSize: 16, weight: .regular)
        overview.numberOfLines = 0
        overview.translatesAutoresizingMaskIntoConstraints = false
        overview.text = "This is a the best overview ever seen"
        return overview
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.clipsToBounds = true
        webView.contentMode = .scaleAspectFit
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        setConstraints()
        viewModel?.onViewsLoaded()
    }
    
    func setConstraints() {
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 12)
        ]
        
        let overviewLabelContraints = [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 12)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelContraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    
}

extension TitlePreviewViewController: TitlePreviewViewControllerProtocol {
    
    func configure(with model: TitlePreviewModel) {
        titleLabel.text = model.title
        overviewLabel.text = model.overview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId ?? "")") else { return }
        webView.load(URLRequest(url: url))
    }
}
