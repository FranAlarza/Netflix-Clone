//
//  TiylePreviewViewModel.swift
//  Netflix Clone
//
//  Created by Fran Alarza on 26/8/22.
//

import Foundation

protocol TitlePreviewViewModelProtocol {
    func onViewsLoaded()
}

class TitlePreviewViewModel {
    weak var delegate: TitlePreviewViewControllerProtocol?
    var model: TitlePreviewModel?
    
    init(delegate: TitlePreviewViewControllerProtocol, model: TitlePreviewModel) {
        self.delegate = delegate
        self.model = model
    }
    
}

extension TitlePreviewViewModel: TitlePreviewViewModelProtocol {
    func onViewsLoaded() {
        guard let model = model else { return }
        delegate?.configure(with: model)
    }
}
