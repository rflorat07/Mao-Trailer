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

    typealias QueryError          = (SectionError?)-> Void
    typealias QuerySectionResult  = (SectionData?) -> Void
    typealias QueryAccountStates  = (AccountStates?) -> Void
    typealias QueryAccountDetails = (AccountDetails?) -> Void
    typealias QuerySectionData    = (Data?, SectionError?) -> Void
    
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
        
        getDataFromUrl(queryString: queryString) { (data, error) in
            if let data = data {
                self.decodeInformation(AccountDetails.self, with: data, from: queryString, completion: { (details: AccountDetails?) in
                    completion(details)
                })
            }  else {
                completion(nil)
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

    // MARK: - Grab the following account states for a session: rating, watchlist, favourite
    func fetchAccountStates(id: Int, type: MediaType, endPoint: EndPointType, _ completion: @escaping QueryAccountStates) {
        
        let urlString = "\(type.rawValue)/\(id)/\(endPoint.rawValue)"
        let queryString = getUrlSession(endPoint: urlString)
        
        getDataFromUrl(queryString: queryString) { (data, error) in
            if let data = data {
                self.decodeInformation(AccountStates.self, with: data, from: queryString, completion: { (details: AccountStates?) in
                    completion(details)
                })
            }  else {
               completion(nil)
            }
        }
    }
    
   // MARK: - This method allows you to mark a movie or TV show as a favorite item.
    func markAsFavorite(id: Int, type: MediaType, endPoint: EndPointType, mark: Bool,_ completion: @escaping QueryError) {
        
        let urlString = "account/account_id/\(endPoint.rawValue)"
        let queryString = getUrlSession(endPoint: urlString)
        
        let headers = ["content-type": "application/json"]
        
        let parameters: [String : Any] = [
            "media_type": type.rawValue,
            "media_id": id,
            endPoint.rawValue: mark
        ]
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            
            self.postDataFromUrl(queryString: queryString, headers: headers, postData: postData) { (data, error) in
                if let data = data {
                    self.decodeInformation(SectionError.self, with: data, from: queryString, completion: { (response: SectionError?) in
                        completion(response)
                    })
                }  else {
                    completion(error)
                }
            }
            
        } catch let error as NSError {
            print("Failed to load: \(error) \n URL: \(queryString)")
        }
        
    }
    
    // ==================== Helper =======================
    
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
                completion(nil, error as? SectionError)
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
    
    // MARK: - POST data from a URL
    
    fileprivate func postDataFromUrl( queryString: String, headers: [String : String], postData: Data,_ completion : @escaping QuerySectionData) {
        
        var request = URLRequest(url: URL(string: queryString)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        request.httpMethod = "POST"
        request.httpBody = postData
        request.allHTTPHeaderFields = headers
        
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print("DataTask error: \(error) \n URL: \(queryString)")
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                (response.statusCode == 200 || response.statusCode == 201) {
                completion(data, nil)
            } else {
                self.decodeError(data!, queryString, { (error) in
                    completion(nil, error)
                })
            }
        })
        
        dataTask.resume()
    }
    
    
    // MARK: - Decode error
    
    fileprivate func decodeError(_ data: Data?, _ url: String, _ completion : @escaping QueryError) {
        DispatchQueue.main.async {
            do {
                let error = try JSONDecoder().decode(SectionError.self, from: data!)
                completion(error)
                print("DataTask error status code: \(error.status_code ?? 404)  \(error.status_message ?? "Requested could not be found") \n Url \(url)")
                
            } catch let decodeError as NSError {
                completion(nil)
                print("Decoder error: \(decodeError)\n")
            }
        }
    }
}


