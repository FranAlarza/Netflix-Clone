//
//  TrendingModel.swift
//  Netflix Clone
//
//  Created by Fran Alarza on 1/8/22.
//

import Foundation

struct Results: Decodable {
    var results: [Movie]
}

struct Movie: Decodable {
    var id: Int
    var name: String?
    var title: String?
    var original_title: String?
    var overview: String
    var poster_path: String?
    var vote_average: Float
}

