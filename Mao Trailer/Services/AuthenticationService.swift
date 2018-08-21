//
//  AuthenticationService.swift
//  Mao Trailer
//
//  Created by Roger Florat on 08/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

class AuthenticationService {
    
    static let instance = AuthenticationService()
    
    let defaults = UserDefaults.standard
    
    typealias QueryError       = ()-> Void
    typealias QueryToken       = (Token?) -> Void
    typealias QuerySectionData = (Data?) -> Void
    typealias QuerySessionID   = (NewSession?) -> Void
    typealias QueryAccountDetails = (AccountDetails?) -> Void
    
    lazy var configuration = URLSessionConfiguration.default
    lazy var session = URLSession(configuration: configuration)
    
    var authToken: String {
        get {
            return defaults.value(forKey: UserInfo.tokenKey) as! String
        }
        set {
            defaults.set(newValue, forKey: UserInfo.tokenKey)
        }
    }
    
    var sessionID: String {
        get {
            return defaults.value(forKey: UserInfo.sessionID) as! String
        }
        set {
            defaults.set(newValue, forKey: UserInfo.sessionID)
        }
    }
    
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: UserInfo.loggedInKey)
        }
        set {
            defaults.set(newValue, forKey: UserInfo.loggedInKey)
        }
    }
    
    // MARK: - Clear User Data.
    func clearUserData() {
        defaults.removeObject(forKey: UserInfo.tokenKey)
        defaults.removeObject(forKey: UserInfo.sessionID)
        defaults.removeObject(forKey: UserInfo.loggedInKey)
        defaults.removeObject(forKey: UserInfo.walkthrough)
    }
        
    // MARK: - Create a temporary request token
    func  fetchTemporaryRequestToken(_ completion: @escaping  QueryToken) {
        
        let queryString = getUrlAuthentication(endPoint: "authentication/token/new")
        
        getDataFromUrl(queryString: queryString) { (data) in
            if let data = data {
                self.decodeInformation(Token.self, with: data, from: queryString, completion: { (token: Token?) in
                    self.authToken = token!.request_token
                    completion(token)
                })
            }  else {
                completion(nil)
                self.decodeError(data!, queryString, {})
            }
        }
    }
    
    // MARK: - Validate a request token by entering a username and password.
    func validateRequestToken(username: String, password: String, _ completion: @escaping  QueryToken) {
        
        let queryString = getUrlAuthentication(endPoint: "authentication/token/validate_with_login")
        
        let headers = ["content-type": "application/json"]
        
        let parameters = [
            "username": "\(username)",
            "password": "\(password)",
            "request_token": "\(self.authToken)"
        ]
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            
            self.postDataFromUrl(queryString: queryString, headers: headers, postData: postData) { (data) in
                if let data = data {
                    self.decodeInformation(Token.self, with: data, from: queryString, completion: { (token: Token?) in
                        completion(token)
                        self.isLoggedIn = true
                    })
                }  else {
                    completion(nil)
                    self.isLoggedIn = false
                }
            }
            
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Create a fully valid session ID
    func fetchValidSessionID( _ completion: @escaping  QuerySessionID) {
        
        let queryString = getUrlAuthentication(endPoint: "authentication/session/new")
        
        let headers = ["content-type": "application/json"]
        let parameters = ["request_token": "\(self.authToken)"]
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            
            self.postDataFromUrl(queryString: queryString, headers: headers, postData: postData) { (data) in
                if let data = data {
                    self.decodeInformation(NewSession.self, with: data, from: queryString, completion: { (session: NewSession?) in
                        self.sessionID = session!.session_id
                        completion(session)
                    })
                }  else {
                    completion(nil)
                    self.decodeError(data!, queryString, {})
                }
            }
            
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
    }
    
    
    // ==================== Helper =======================
    
    // MARK: - Url Temporary Request Token
    
    fileprivate func getUrlAuthentication(endPoint: String) -> String {
        
        var urlQuery = URLComponents(string: QueryString.baseUrl)!
        
        urlQuery.path = "/3/\(endPoint)"
        
        urlQuery.queryItems = [
            URLQueryItem(name: "api_key", value: QueryString.api_key)
        ]
        
        return urlQuery.string!
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
                response.statusCode == 200 {
                completion(data)
            } else {
                self.decodeError(data!, queryString, {
                    completion(nil)
                })
            }
        })
        
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


