//
//  QueryService.swift
//  TodayExtension
//
//  Created by Roger Florat on 03/09/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

class QueryService {
   
    static let instance = QueryService()
    
    typealias QueryError          = (SectionError?)-> Void
    typealias QuerySectionData    = (Data?, SectionError?) -> Void
    typealias QuerySectionResult  = (SectionData?) -> Void

    lazy var configuration = URLSessionConfiguration.default
    lazy var session = URLSession(configuration: configuration)
    
    // MARK: - Fetch Discover Movie
    
    func fetchDiscoverMovies(type: APIRequest, page: Int, _ completion : @escaping QuerySectionResult) {
        
        let queryString = getUrlDiscover(type: type, page: page)
        
        getDataFromUrl(queryString: queryString) { (data, error) in
            if let data = data {
                
                self.decodeInformation(SectionData.self, from: data, with: queryString) { (dataResult: SectionData?) in
                    
                    if let dataResult = dataResult {
                        completion(dataResult)
                    } else {
                        completion(nil)
                    }
                }
                
            } else {
                self.decodeError(data!, queryString, { (error) in
                    completion(nil)
                })
            }
        }
        
    }
    
    // ==================== Helper =======================
    
    // MARK: - URL Discover
    fileprivate func getUrlDiscover(type: APIRequest, page: Int) -> String {
        
        var urlQuery = URLComponents(string: QueryString.baseUrl)!
        
        urlQuery.path = "/3/discover/\(type.rawValue)"
        
        urlQuery.queryItems = [
            URLQueryItem(name: "api_key", value: QueryString.api_key),
            URLQueryItem(name: "language", value: QueryString.language),
            URLQueryItem(name: "sort_by", value: QueryString.sort_by),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "include_video", value: "false"),
            URLQueryItem(name: "region", value: QueryString.region),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "release_date.gte", value: Date.currentDateAsString())
        ]
        
        return urlQuery.string!
    }
    
    // MARK: - Get the data from a URL
    
    fileprivate func getDataFromUrl(queryString: String, _ completion : @escaping QuerySectionData) {
        
        guard let query = URL(string: queryString) else { return }
        
        let dataTask = session.dataTask(with: query) { (data, response, error) in
            
            if let error = error {
                print("DataTask error: \(error.localizedDescription) \n")
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                completion(data, nil)
            } else {
                self.decodeError(data!, queryString, { (error) in
                    completion(nil, error)
                })
            }
        }
        
        dataTask.resume()
    }
    
    
    // MARK: - Get Information
    
    fileprivate func decodeInformation<T>(_ type: T.Type, from data: Data, with url: String, completion : @escaping (T?) -> Void) where T : Decodable {
        
        DispatchQueue.main.async {
            
            do {
                let list = try JSONDecoder().decode(type, from: data)
                
                completion(list)
                
            } catch let decodeError as NSError {
                
                completion(nil)
                
                print("Decoder error: \(decodeError) \n Url: \(url)")
            }
        }
    }
    
    // MARK: - Decode error
    
    fileprivate func decodeError(_ data: Data, _ url:   String, _ completion : @escaping QueryError) {
        DispatchQueue.main.async {
            do {
                let error = try JSONDecoder().decode(SectionError.self, from: data)
                completion(error)
                print("DataTask error status code: \(error.status_code ?? 404)  \(error.status_message ?? "Requested could not be found") \n Url: \(url)")
                
            } catch let decodeError as NSError {
                completion(nil)
                print("Decoder error: \(decodeError) \n Url: \(url)")
            }
        }
    }
}
