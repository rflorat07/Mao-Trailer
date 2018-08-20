//
//  AccountService.swift
//  Mao Trailer
//
//  Created by Roger Florat on 20/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

class AccountService {
    
    static let instance = AccountService()
    
    let defaults = UserDefaults.standard
    let queryService = QueryService.instance

    typealias QueryError          = ()-> Void
    typealias QuerySectionData    = (Data?) -> Void
    typealias QuerySectionResult  = (SectionData?) -> Void
    typealias QueryAccountDetails = (AccountDetails?) -> Void
    
    lazy var configuration = URLSessionConfiguration.default
    lazy var session = URLSession(configuration: configuration)
    
    
    var authToken: String {
        get {
            return defaults.value(forKey: UserInfo.tokenKey) as! String
        }
    }
    
    var sessionID: String {
        get {
            return defaults.value(forKey: UserInfo.sessionID) as! String
        }
    }
    
    
    // MARK: - Get account details.
    func fetchAccountDetails(_ completion : @escaping QueryAccountDetails) {
        let urlString = "account"
        let queryString = getUrlSession(endPoint: urlString)
        
        getDataFromUrl(queryString: queryString) { (data) in
            if let data = data {
                self.decodeInformation(AccountDetails.self, with: data, from: queryString, completion: { (details: AccountDetails?) in
                    completion(details)
                })
            }  else {
                // self.decodeError(data!, queryString, {})
            }
        }
    }
    
    // MARK: - Get the list of your favorite movies.
    func fetchFavoriteMoviesOrTVShows(sectionName: String = "Favorite", type: MediaType, endPoint: EndPointType, page: Int, _ completion : @escaping QuerySectionResult) {
        
        queryService.fetchSection(sectionName: sectionName, type: type, endPoint: endPoint, page: page) { (sectionResult) in
            
            if let sectionResult = sectionResult {
                completion(sectionResult)
            } else {
                completion(nil)
            }
        }
    }
    
    // MARK: - Url Session
    
    fileprivate func getUrlSession(endPoint: String) -> String {
        
        var urlQuery = URLComponents(string: QueryString.baseUrl)!
        
        urlQuery.path = "/3/\(endPoint)"
        
        urlQuery.queryItems = [
            URLQueryItem(name: "api_key", value: QueryString.api_key),
            URLQueryItem(name: "session_id", value: sessionID)
        ]
        
        return urlQuery.string!
    }
    
    // MARK: - GET data from a URL
    
    fileprivate func getDataFromUrl(queryString: String, _ completion : @escaping QuerySectionData) {
        
        guard let query = URL(string: queryString) else { return }
        
        let dataTask = session.dataTask(with: query) { (data, response, error) in
            
            if let error = error {
                print("DataTask error: \(error.localizedDescription) \n")
                completion(nil)
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                completion(data)
            } else {
                self.decodeError(data!, queryString, {
                    completion(nil)
                })
            }
        }
        
        dataTask.resume()
    }
    
    // MARK: - Decode Information
    
    fileprivate func decodeInformation<T>(_ type: T.Type, with data: Data, from url: String, completion : @escaping (T?) -> Void) where T : Decodable {
        
        DispatchQueue.main.async {
            
            do {
                let list = try JSONDecoder().decode(type, from: data)
                
                completion(list)
                
            } catch let decodeError as NSError {
                
                completion(nil)
                
                print("Decoder error: \(decodeError) \n \n \(decodeError) \n \n Url: \(url)")
            }
        }
    }
    
    
    // MARK: - Decode error
    
    fileprivate func decodeError(_ data: Data?, _ url: String, _ completion : @escaping QueryError) {
        DispatchQueue.main.async {
            do {
                let error = try JSONDecoder().decode(SectionError.self, from: data!)
                completion()
                print("DataTask error status code: \(error.status_code ?? 404)  \(error.status_message ?? "Requested could not be found") \n Url \(url)")
                
            } catch let decodeError as NSError {
                completion()
                print("Decoder error: \(decodeError)\n")
            }
        }
    }
}


