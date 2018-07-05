//
//  QueryServiceTVShow.swift
//  Mao Trailer
//
//  Created by Roger Florat on 05/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

// Runs query data task, and stores results in array
class QueryServiceTVShow {
    
    static let intance = QueryServiceTVShow()
    
    lazy var configuration = URLSessionConfiguration.default
    lazy var session = URLSession(configuration: configuration)
    
    var tvShowList: [TVShow] = []
    
    typealias QueryResultTVShow = ([TVShow]?)-> Void
    
    func getDiscoverTVShow(queryString: String, _ completion : @escaping QueryResultTVShow) {
        
        guard let url = URL(string: queryString) else  { return }
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("DataTask error: \(error.localizedDescription) \n")
                
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                
                self.updateTVShowList(data)
                
                DispatchQueue.main.async {
                    
                    self.tvShowList.append(TVShowMore)
                    
                    completion(self.tvShowList)
                }
            }
        }
        
        dataTask.resume()
    }
    
    
    // MARK: - Helper methods
    
    fileprivate func updateTVShowList(_ data: Data) {
        
        self.tvShowList.removeAll()
        
        do {
            let list = try JSONDecoder().decode(TVShowList.self, from: data)
            self.tvShowList = list.results
            
        } catch let decodeError as NSError {
            print("Decoder error: \(decodeError.localizedDescription) \n")
        }
    }
    
}
