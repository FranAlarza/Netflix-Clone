//
//  YoutubeModel.swift
//  Netflix Clone
//
//  Created by Fran Alarza on 18/8/22.
//

import Foundation

struct YoutubeSearchResults: Decodable {
    let items: [TrailerResponseId]
}

struct TrailerResponseId: Decodable {
    let id: Id
}

struct Id: Decodable {
    let kind: String
    let videoId: String?
}


