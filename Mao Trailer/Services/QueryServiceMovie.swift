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
    
    var movieList: [Movie] = []
   
    typealias QueryResultMovie  = ([Movie]?)-> Void

    func getDiscoverMovie(queryString: String, _ completion : @escaping QueryResultMovie) {
        
        guard let url = URL(string: queryString) else  { return }
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("DataTask error: \(error.localizedDescription) \n")
                
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                
                self.updateMovieList(data)
                
                DispatchQueue.main.async {
                    
                    self.movieList.append(MoreMovie)
                    
                    completion(self.movieList)
                }
            }
        }
        
        dataTask.resume()
    }
    
    // MARK: - Helper methods
    fileprivate func updateMovieList(_ data: Data) {
        
        self.movieList.removeAll()
        
        do {
            let list = try JSONDecoder().decode(MovieList.self, from: data)
            self.movieList = list.results
            
        } catch let decodeError as NSError {
            print("Decoder error: \(decodeError.localizedDescription) \n")
        }
    }
        
}
