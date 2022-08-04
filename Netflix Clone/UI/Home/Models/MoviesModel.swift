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

/*
 {
 "adult":false,
 "backdrop_path":"/56v2KjBlU4XaOv9rVYEQypROD7P.jpg",
 "id":66732,
 "name":"Stranger Things",
 "original_language":"en",
 "original_name":"Stranger Things",
 "overview":"When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces, and one strange little girl.",
 "poster_path":"/49WJfeN0moxb9IPfGn8AIqMGskD.jpg",
 "media_type":"tv",
 "genre_ids":[
 18,
 10765,
 9648,
 ],
 "popularity":1944.749,
 "first_air_date":"2016-07-15",
 "vote_average":8.641,
 "vote_count":12657,
 "origin_country":[
 "US",
 ]
 }
 */
