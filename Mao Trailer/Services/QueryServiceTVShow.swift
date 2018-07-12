//
//  QueryServiceTVShow.swift
//  Mao Trailer
//
//  Created by Roger Florat on 05/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

// Runs query data task, and stores results in array
 /* class QueryServiceTVShow {
    
    static let intance = QueryServiceTVShow()
    
    lazy var configuration = URLSessionConfiguration.default
    lazy var session = URLSession(configuration: configuration)
    
    
    typealias QueryResultTVShow = (TVShowList?)-> Void
    typealias QueryResultList  = ([SectionTVShow]?)-> Void
    
    func fetchAllTVShowsLists( _ completion : @escaping QueryResultList) {
        
        var tvShowArray: [SectionTVShow] = [SectionTVShow]()
        
        let group = DispatchGroup()
        
        // Now TVShow
        group.enter()
        
        fetchTVShowsList(queryString: EndPoint.NowTVShows) { (tvShows) in
            
            if let tvShows = tvShows {
                tvShowArray.append(SectionTVShow(page: tvShows.page, total_results: tvShows.total_results, total_pages: tvShows.total_pages, sectionName: "Now", sectionArray: tvShows.getTVShowList()))
            }
            
            group.leave()
        }
        
        // Popular TVShow
        group.enter()
        
        fetchTVShowsList(queryString: EndPoint.PopularTVShows) { (tvShows) in
            
            if let tvShows = tvShows {
                tvShowArray.append(SectionTVShow(page: tvShows.page, total_results: tvShows.total_results, total_pages: tvShows.total_pages, sectionName: "Popular", sectionArray: tvShows.getTVShowList()))
            }
            
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            completion(tvShowArray)
        })
    }
    
    
    func fetchTVShowsList(queryString: String, _ completion : @escaping QueryResultTVShow) {
        
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
                    self.getTVShowList(data, { (movieList) in
                        completion(movieList)
                    })
                }
            }
        }
        
        dataTask.resume()
    }
    
    // MARK: - Helper methods
    fileprivate func getTVShowList(_ data: Data, _ completion : @escaping QueryResultTVShow) {
        
        do {
            let list = try JSONDecoder().decode(TVShowList.self, from: data)
            completion(list)
            
        } catch let decodeError as NSError {
            print("Decoder error: \(decodeError.localizedDescription) \n")
        }
    }
} */
