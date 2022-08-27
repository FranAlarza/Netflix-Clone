//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Fran Alarza on 1/8/22.
//

import Foundation

struct Constants {
    static let API_KEY = "100c5ac8b69942aa2b4db4ac08283f68"
    static let baseURL = "https://api.themoviedb.org/"
    static let youtubeAPI_KEY = "AIzaSyCYyqsIH-QIHssASOwIWhKZk8B1F_YOFts"
    static let youtubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APICallerErrors: Error {
    case malformedURL
    case decodingError
}

class ApiCaller {
    static let shared = ApiCaller()
    
    func getTrendingMovies(completion: @escaping ([Movie]?, APICallerErrors?) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)3/trending/movie/day?api_key=\(Constants.API_KEY)") else {
            completion([], .malformedURL)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion([], .decodingError)
                return
            }
            
            let trendingMovies = try? JSONDecoder().decode(Results.self, from: data)
            completion(trendingMovies?.results, nil)
            
        }
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping ([Movie]?, APICallerErrors?) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {
            completion([], .malformedURL)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion([], .decodingError)
                return
            }
            
            let popularMovies = try? JSONDecoder().decode(Results.self, from: data)
            completion(popularMovies?.results, nil)
        }
        task.resume()
    }
    
    func getTrendingTv(completion: @escaping ([Movie]?, APICallerErrors?) -> Void) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/trending/tv/day?api_key=100c5ac8b69942aa2b4db4ac08283f68") else {
            completion([], .malformedURL)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion([], .decodingError)
                return
            }
            let trendingTv = try? JSONDecoder().decode(Results.self, from: data)
            completion(trendingTv?.results, nil)
        }
        
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping ([Movie]?, APICallerErrors?) -> Void)  {
        guard let url = URL(string: "\(Constants.baseURL)3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {
            completion([], .malformedURL)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion([], .decodingError)
                return
            }
            
            let upcomingMovies = try? JSONDecoder().decode(Results.self, from: data)
            completion(upcomingMovies?.results, nil)
        }
        
        task.resume()
    }
    
    func getTopRated(completion: @escaping ([Movie]?, APICallerErrors?) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {
            completion([], .malformedURL)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion([], .decodingError)
                return
            }
            let topRated = try? JSONDecoder().decode(Results.self, from: data)
            completion(topRated?.results, nil)
        }
        task.resume()
    }
    
    func getDiscoverMovies(completion: @escaping ([Movie]?, APICallerErrors?) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data , error == nil else {
                completion([], .malformedURL)
                return
            }
            
            let discoverMovies = try? JSONDecoder().decode(Results.self, from: data)
            completion(discoverMovies?.results, nil)
        }
        task.resume()
    }
    
    func searchMovies(with query: String, completion: @escaping ([Movie]?, APICallerErrors?) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseURL)3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {
            completion([], .malformedURL)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion([], .decodingError)
                return
            }
            
            let results = try? JSONDecoder().decode(Results.self, from: data)
            completion(results?.results, nil)
        }
        
        task.resume()
        
    }
    
    func searchTrailer(with query: String, completion: @escaping (TrailerResponseId?, APICallerErrors?) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.youtubeBaseURL)q=\(query)&key=\(Constants.youtubeAPI_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, .decodingError)
                return
            }

            let trailerResponse = try? JSONDecoder().decode(YoutubeSearchResults.self, from: data)
            completion(trailerResponse?.items[0], nil)
        }
        
        task.resume()
    }
    
    
    
}
