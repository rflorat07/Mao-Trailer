//
//  NetworkProcessor.swift
//  Mao Trailer
//
//  Created by Roger Florat on 03/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

class QueryService {
    
    static let intance = QueryService()
    
    lazy var configuration = URLSessionConfiguration.default
    lazy var session = URLSession(configuration: configuration)
    
    var movieList: [Movie] = []
    var errorMessage: String = ""
    
    typealias JSONDownloader = (([Movie]?)-> Void)
    typealias IMAGEDATADownloader = ((Data?, HTTPURLResponse?, Error?)-> Void)
    
    //Download Movie list data
    func getDiscoverMovie(queryString: String, withStructType : String, _ completion : @escaping JSONDownloader) {
        
        let url = URL(string: queryString)!
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                
                print("DataTask error: \(error.localizedDescription) \n")
                
            } else if let dataResponse = response as? HTTPURLResponse {
                
                switch dataResponse.statusCode {
                case 200:
                    
                    guard let downloadData = data else { return }
                    
                    do {
                        let moviesJSON = try JSONDecoder().decode(MovieList.self, from: downloadData)
                        completion(moviesJSON.results)
                        
                    } catch let decodingError as NSError {
                        print("Decoder error: \(decodingError.localizedDescription)\n")
                    }
                    
                default:
                    print("Response error status code : \(dataResponse.statusCode)")
                }
            }
        }
        
        dataTask.resume()
    }
    
    //Download Image Data
    func downloadImage(withPath imageUrl: URL, _ completion: @escaping IMAGEDATADownloader) {
        
        let imageRequest = URLRequest(url: imageUrl)
        
        let imageDataTask = session.dataTask(with: imageRequest) { (imageData, imageResponse, imageError) in
            
            if imageError == nil {
                
                guard let response = imageResponse as? HTTPURLResponse else { return }
                
                switch response.statusCode {
                case 200:
                    guard let data = imageData else { return }
                    completion(data, nil, nil)
                default:
                    return
                }
                
            } else {
                
                print("Error downloading Image:  \(imageError.debugDescription)")
                completion(nil, nil, imageError!)
            }
        }
        
        imageDataTask.resume()
    }
    
}
