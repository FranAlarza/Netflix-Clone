//
//  TrendingTv.swift
//  Netflix Clone
//
//  Created by Fran Alarza on 2/8/22.
//

import Foundation

struct ResultsTv: Decodable {
    var results: [TvShow]
}

struct TvShow: Decodable {
    var id: Int
    var name: String
    var original_language: String
    var original_name: String
    var overview: String
    var poster_path: String
    var vote_average: Float
}


/*
 {
 "backdrop_path":"/56v2KjBlU4XaOv9rVYEQypROD7P.jpg",
 "first_air_date":"2016-07-15",
 "genre_ids":[
 18,
 10765,
 9648,
 ],
 "id":66732,
 "name":"Stranger Things",
 "origin_country":[
 "US",
 ],
 "original_language":"en",
 "original_name":"Stranger Things",
 "overview":"When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces, and one strange little girl.",
 "popularity":2053.951,
 "poster_path":"/49WJfeN0moxb9IPfGn8AIqMGskD.jpg",
 "vote_average":8.6,
 "vote_count":12605,
 }
 */
