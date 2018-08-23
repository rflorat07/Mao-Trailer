//
//  AuthenticationService.swift
//  Mao Trailer
//
//  Created by Roger Florat on 08/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

class AuthenticationService: QueryService {
    
    static let instanceAuth = AuthenticationService()
    
    typealias QueryData = (Data?, Error?) -> Void
    typealias QueryToken = (Token?, SectionError?) -> Void
    typealias QueryAccountDetails = (AccountDetails?) -> Void
    typealias QuerySessionID = (NewSession?, SectionError?) -> Void
    
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: UserInfo.loggedInKey)
        }
        set {
            defaults.set(newValue, forKey: UserInfo.loggedInKey)
        }
    }
    
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
    
    // MARK: - Clear User Data.
    func clearUserData() {
        defaults.removeObject(forKey: UserInfo.tokenKey)
        defaults.removeObject(forKey: UserInfo.sessionID)
        defaults.removeObject(forKey: UserInfo.loggedInKey)
        defaults.removeObject(forKey: UserInfo.walkthrough)
    }
        
    // MARK: - Create a temporary request token
    func fetchTemporaryRequestToken(_ completion: @escaping  QueryToken) {
        
        let queryString = getUrlAuthentication(endPoint: "authentication/token/new")
        
        getDataFromUrl(queryString: queryString) { (data, error)  in
            if let data = data {
                self.decodeInformation(Token.self, from: data, with: queryString, completion: { (token: Token?) in
                    self.authToken = token!.request_token
                    completion(token, nil)
                })
            }  else {
                
                self.decodeError(data!, queryString, { (error) in
                   completion(nil, error)
                })
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
            
            self.postDataFromUrl(queryString: queryString, headers: headers, postData: postData) { (data, error) in
                if let data = data {
                    self.decodeInformation(Token.self, from: data, with: queryString, completion: { (token: Token?) in
                        completion(token, nil)
                        self.isLoggedIn = true
                    })
                }  else {
                    completion(nil, error)
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
            
            self.postDataFromUrl(queryString: queryString, headers: headers, postData: postData) { (data, error)  in
                if let data = data {
                    self.decodeInformation(NewSession.self, from: data, with: queryString, completion: { (session: NewSession?) in
                        self.sessionID = session!.session_id
                        completion(session, nil)
                    })
                }  else {
                    completion(nil, error)
                }
            }
            
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
    }
    
    
    // ==================== Helper =======================

    // MARK: - Url Session
    
    func getUrlSession(endPoint: String) -> String {
        
        var urlQuery = URLComponents(string: QueryString.baseUrl)!
        
        urlQuery.path = "/3/\(endPoint)"
        
        urlQuery.queryItems = [
            URLQueryItem(name: "api_key", value: QueryString.api_key),
            URLQueryItem(name: "session_id", value: sessionID)
        ]
        
        return urlQuery.string!
    }
    
    // MARK: - POST data from a URL
    func postDataFromUrl( queryString: String, headers: [String : String], postData: Data,_ completion : @escaping QuerySectionData) {
        
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
                completion(data, nil)
            } else {
                self.decodeError(data!, queryString, { (error) in
                    completion(nil, error)
                })
            }
        })
        
        dataTask.resume()
    }
    
    
    // MARK: - Get Url Authentication
    fileprivate func getUrlAuthentication(endPoint: String) -> String {
        
        var urlQuery = URLComponents(string: QueryString.baseUrl)!
        
        urlQuery.path = "/3/\(endPoint)"
        
        urlQuery.queryItems = [
            URLQueryItem(name: "api_key", value: QueryString.api_key)
        ]
        
        return urlQuery.string!
    }
    
}


