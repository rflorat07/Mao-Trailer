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
    
    typealias QueryResultMovieInfo = (MovieInfo?)-> Void
    typealias QueryResultMovieArray = ([Movie]?)-> Void
    typealias QueryResultMovieSection = ([SectionMovie]?)-> Void
    
    func fetchAllMoviesLists( _ completion : @escaping QueryResultMovieSection) {
        
        var movieArray: [SectionMovie] = [SectionMovie]()
        
        let group = DispatchGroup()
        
        // Upcoming Movies
        group.enter()
        
        fetchMovieList(queryString: EndPoint.UpcomingMovies) { (movies) in
            
            if let movies = movies {
                movieArray.append(SectionMovie(sectionName: "Upcoming", sectionArray: movies))
            }
            
            group.leave()
        }
        
        // Now Movies
        group.enter()
        
        fetchMovieList(queryString: EndPoint.NowMovies) { (movies) in
            
            if let movies = movies {
                movieArray.append(SectionMovie(sectionName: "Now", sectionArray: movies))
            }
            
            group.leave()
        }
        
        // Popular Movies
        group.enter()
        
        fetchMovieList(queryString: EndPoint.PopularMovies) { (movies) in
            
            if let movies = movies {
                movieArray.append(SectionMovie(sectionName: "Popular", sectionArray: movies))
            }
            
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            completion(movieArray)
        })
    }
    
    
    func fetchMovieList(queryString: String, _ completion : @escaping QueryResultMovieArray) {
        
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
    
    func fetchMovieInformation(movieID: Int, _ completion : @escaping QueryResultMovieInfo) {
        
        var urlInfo = URLComponents(string: QueryString.baseUrl)!
        
        urlInfo.path = "/3/movie/\(movieID)"
        urlInfo.queryItems = [
            URLQueryItem(name: "api_key", value: QueryString.api_key),
            URLQueryItem(name: "language", value: QueryString.language),
            URLQueryItem(name: "append_to_response", value: QueryString.append_to_response)
        ]
        urlInfo.percentEncodedQuery = urlInfo.percentEncodedQuery?.replacingOccurrences(of: ",", with: "%2C")
        
       guard let query = urlInfo.url else { return }
                
        let dataTask = session.dataTask(with: query) {
            (data, response, error) in
            
            if let error = error {
                print("DataTask error: \(error.localizedDescription) \n")
                
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                DispatchQueue.main.async {
                    self.getMovieInformation(data, { (movieInfo) in
                        completion(movieInfo)
                    })
                }
            }
        }
        
        dataTask.resume()
       
        
    }
    
    func searchMovieFromWord(searchText: String, _ completion : @escaping QueryResultMovieArray) {
        
        var urlInfo = URLComponents(string: QueryString.baseUrl)!
        
        urlInfo.path = "/3/search/movie"
        urlInfo.queryItems = [
            URLQueryItem(name: "api_key", value: QueryString.api_key),
            URLQueryItem(name: "language", value: QueryString.language),
            URLQueryItem(name: "query", value: searchText),
            URLQueryItem(name: "page", value: QueryString.page),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "region", value: QueryString.region)
        ]
        
        fetchMovieList(queryString: urlInfo.string!) { (movieList) in
            
            let itemlist = movieList?.filter{ $0.backdrop_path != nil && $0.poster_path != nil}
            
            completion(itemlist)
        }
    }
    
    // MARK: - Helper methods
    fileprivate func getMovieList(_ data: Data, _ completion : @escaping QueryResultMovieArray) {
        
        do {
            let list = try JSONDecoder().decode(MovieList.self, from: data)
            
            completion(list.results)
            
        } catch let decodeError as NSError {
            print("Decoder error: \(decodeError.localizedDescription) \n")
        }
    }
    
    fileprivate func getMovieInformation(_ data: Data, _ completion : @escaping QueryResultMovieInfo) {
        
        do {
            let movieInfo = try JSONDecoder().decode(MovieInfo.self, from: data)
            
            completion(movieInfo)
            
        } catch let decodeError as NSError {
            print("Decoder error: \(decodeError.localizedDescription) \n")
        }
    }
}
