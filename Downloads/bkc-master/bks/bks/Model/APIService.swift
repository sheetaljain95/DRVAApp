//
//  APIService.swift
//  bks
//
//  Created by Sheetal on 18/12/19.
//  Copyright © 2019 Sheetal Jain. All rights reserved.
//

import Foundation
import UIKit

struct Result: Decodable {
    var results: [Movie]?
}

struct SimilarMovies {
    var title: String?
    var poster_path: String?
}

struct CreditStruct {
    var name: String?
    var department: String?
    var profile_path: String?
}

struct Reviews  {
    var id: Int?
    var total_results: Int?
    var results : [results]?
}

struct results {
    var author: String?
    var content: String?
}

public struct Movie: Decodable, Encodable {
    var original_title: String?
    var overview: String?
    var release_date: String?
    var poster_path: String?
    var id: Int?
}

struct MovieTableStruct {
    var movieImage : UIImage?
    var movieTitle = String()
    var releaseDate  = String()
    var movieOverview = String()
    var movieId = Int()
}

struct MoviesService {
    
    mutating func getMovies(withPageNo pg: Int, andCallback callback: @escaping ([MovieTableStruct]) -> Void) {
        var movie = [Movie]()
        var page = pg
        page = page + 1
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=e19ab30f944ccaf8c0af21ed2726cc8b&page=\(page)")!
        let session = URLSession.shared
        let imagePrefix = "https://image.tmdb.org/t/p/w500/"
        var moviearray = [MovieTableStruct]()
        let task = session.dataTask(with: url) {
            data, response, error in
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("response.statusCode")
                print("Server error!")
                return
            }
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            do {
                if let responseData = data {
                    let resultRes = try JSONDecoder().decode(Result.self, from: responseData)
                    movie = resultRes.results!
                    for instance in movie {
                        var movieStruct = MovieTableStruct()
                        let image_url = imagePrefix + (instance.poster_path ?? "")
                        let urlImg = URL(string:image_url)
               //         print(urlImg)
                        if let dataImg = try? Data(contentsOf: urlImg!) {
                            movieStruct.movieImage = UIImage(data: dataImg)!
                        }
                        movieStruct.movieTitle = instance.original_title ?? ""
                        movieStruct.movieOverview = instance.overview ?? ""
                        movieStruct.releaseDate = instance.release_date ?? ""
                        movieStruct.movieId = instance.id ?? 0
                        moviearray.append(movieStruct)
                    }
                    callback(moviearray)
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func callCredits(withMovieID movieid: Int, andCallback callback: @escaping ([CreditStruct]) -> Void) {
        let imagePrefix: String = "https://image.tmdb.org/t/p/w500/"
        let session = URLSession.shared
        var credit = [CreditStruct]()
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieid )/credits?api_key=e19ab30f944ccaf8c0af21ed2726cc8b")!

    let task = session.dataTask(with: url) { data, response, error in
        if error != nil || data == nil {
            print("Client error!")
            return
        }
        
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            print("Server error!")
            return
        }
        
        guard let mime = response.mimeType, mime == "application/json" else {
            print("Wrong MIME type!")
            return
        }
        
        
        do {
            let json = try JSONSerialization.jsonObject (with: data!, options: []) as? [String : Any]
            //print(json)
            let Credits = json?["crew"] as? [[String:Any]]
            for instance in Credits! {
                let name = instance["name"] as! String
                let department = instance["department"] as! String
                let profile_path = instance["profile_path"] as? String

                let image_url = imagePrefix  + (profile_path ?? "")
                credit.append(CreditStruct(name: name, department: department, profile_path: image_url))
            }
            callback(credit)
        }
            
        catch {
            print("JSON error: \(error.localizedDescription)")
        }
        
    }
    
    task.resume()
    
    }
    
    func callsimilarMovies(withMovieID movieid: Int, andCallback callback: @escaping ([SimilarMovies]) -> Void) {
        let imagePrefix: String = "https://image.tmdb.org/t/p/w500/"
        var similarmovies = [SimilarMovies]()
        let session = URLSession.shared
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieid )/similar?api_key=e19ab30f944ccaf8c0af21ed2726cc8b")!
        print(url)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject (with: data!, options: []) as! [String:Any]
                //  print(json)
            //    let total_results = json["total_results"] as? Int
            //    let total_pages = json["total_pages"] as? Int
                let results = json["results"] as? [[String:Any]]
                // print(results?[0])
                for instance in results! {
                    let title = instance["title"] as! String
                    let poster_path = instance["poster_path"] as? String
                    let image_url = imagePrefix  + (poster_path ?? "")
                    similarmovies.append(SimilarMovies(title: title, poster_path: image_url))
                   // print(self.similarmovies)
                }
                callback(similarmovies)
            }
            catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
        }
        task.resume()
    }
    
    func callReview(withMovieID movieid: Int, andCallback callback: @escaping (Reviews) -> Void) {
        var reviews = Reviews()
        let session = URLSession.shared
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieid )/reviews?api_key=e19ab30f944ccaf8c0af21ed2726cc8b")!
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            
            
            do {
                let json = try JSONSerialization.jsonObject (with: data!, options: []) as? [String: Any]
                reviews.id = json?["id"] as? Int
                reviews.total_results = json?["total_results"] as? Int
                let reviewResults = json?["results"] as? [[String:Any]]
                reviews.results = [results]()
                for instance in reviewResults! {
                    let author = instance["author"] as! String
                    let content = instance["content"] as! String
                    let resultStruct = results(author: author, content: content)
                    reviews.results?.append(resultStruct)
                }
                callback(reviews)
            }
            catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
        }
        task.resume()
    }
}
