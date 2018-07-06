//
//  QueryServiceMovie.swift
//  Mao Trailer
//
//  Created by Roger Florat on 03/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

// Runs query data task, and stores results in array
class QueryServiceMovie {
    
    static let intance = QueryServiceMovie()
    
    lazy var configuration = URLSessionConfiguration.default
    lazy var session = URLSession(configuration: configuration)
    
    typealias QueryResultMovie  = ([Movie]?)-> Void
    typealias QueryResultList  = ([SectionMovie]?)-> Void
    
    func fetchAllMoviesLists( _ completion : @escaping QueryResultList) {
        
        var movieArray: [SectionMovie] = [SectionMovie]()
        
        let group = DispatchGroup()
        
        // Upcoming Movies
        group.enter()
        
        fetchMovieList(queryString: EndPoint.UpcomingMovies) { (movies) in
            
            if let movies = movies {
                movieArray.append(SectionMovie(sectionName: "Upcoming", movieArray: movies))
            }
            
            group.leave()
        }
        
        // Now Movies
        group.enter()
        
        fetchMovieList(queryString: EndPoint.NowMovies) { (movies) in
            
            if let movies = movies {
                movieArray.append(SectionMovie(sectionName: "Now", movieArray: movies))
            }
            
            group.leave()
        }
        
        // Popular Movies
        group.enter()
        
        fetchMovieList(queryString: EndPoint.PopularMovies) { (movies) in
            
            if let movies = movies {
                movieArray.append(SectionMovie(sectionName: "Popular", movieArray: movies))
            }
            
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            completion(movieArray)
        })
    }
    
    
    func fetchMovieList(queryString: String, _ completion : @escaping QueryResultMovie) {
        
        guard let query = URL(string: queryString) else { return }
        
        let dataTask = session.dataTask(with: query) {
            (data, response, error) in
            
            if let error = error {
                print("DataTask error: \(error.localizedDescription) \n")
                
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                DispatchQueue.main.async {
                    self.getMovieList(data, { (movieList) in
                        completion(movieList)
                    })
                }
            }
        }
        
        dataTask.resume()
    }
    
    // MARK: - Helper methods
    fileprivate func getMovieList(_ data: Data, _ completion : @escaping QueryResultMovie) {
        
        do {
            let list = try JSONDecoder().decode(MovieList.self, from: data)
            completion(list.results)
            
        } catch let decodeError as NSError {
            print("Decoder error: \(decodeError.localizedDescription) \n")
        }
    }
}
