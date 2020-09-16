//
//  HTTPMovieClient.swift
//  MoviesToCheckApp
//
//  Created by Luana Chen Chih Jun on 16/09/20.
//  Copyright © 2020 Chen. All rights reserved.
//

import Foundation

class HTTPMovieClient: ObservableObject {
    
    @Published var movies: [Movie] = [Movie]()
    @Published var reviews: [Review]? = [Review]()
    
    let baseURL = "https://movielisttocheck.herokuapp.com/"
    
    func getReviewsByMovie(movie: Movie, completion: @escaping (Bool) -> Void) {
        
        guard let uuid = movie.id,
            let url = URL(string: baseURL + "movies/\(uuid.uuidString)/reviews") else {
                fatalError("URL is not defined!")
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else {
                return completion(false)
            }
            
            let decodedReviews = try? JSONDecoder().decode([Review].self, from: data)
            
            if let decodedReviews = decodedReviews {
                DispatchQueue.main.async {
                    self.reviews = decodedReviews
                    completion(true)
                }
            }
            
            
        }.resume()
        
    }
    
    func deleteMovie(movie: Movie, completion: @escaping (Bool) -> Void) {
        
        guard let uuid = movie.id,
            let url = URL(string: baseURL + "movies/\(uuid.uuidString)") else {
                fatalError("URL is not defined!")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            guard let _ = data, error == nil else {
                return completion(false)
            }
            
            completion(true)
            
        }.resume()
        
    }
    
    func getAllMovies(completion: @escaping (Bool) -> Void) {
        
        guard let url = URL(string: baseURL + "movies") else {
            fatalError("URL is not defined!")
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(false)
            }
            
            let movies = try? JSONDecoder().decode([Movie].self, from: data)
            if let movies = movies {
                DispatchQueue.main.async {
                    self.movies = movies
                    completion(true)
                }
            }
        }.resume()
        
    }
    
    func saveMovie(name: String, completion: @escaping (Bool) -> Void) {
        
        guard let url = URL(string: baseURL + "movies") else {
            fatalError("URL is not defined!")
        }
        
        let movie = Movie(title: name)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(movie)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let _ = data, error == nil else {
                return completion(false)
            }
            
            completion(true)
            
        }.resume()
        
    }
    
    func saveReview(review: Review, completion: @escaping (Bool) -> Void) {
        
        guard let url = URL(string: baseURL + "reviews") else {
            fatalError("URL is not defined!")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(review)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let _ = data, error == nil else {
                return completion(false)
            }
            
            completion(true)
            
        }.resume()
        
    }
    
}
