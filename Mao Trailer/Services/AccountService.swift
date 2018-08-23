//
//  AccountService.swift
//  Mao Trailer
//
//  Created by Roger Florat on 20/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

class AccountService: AuthenticationService {
    
    static let instanceAccount = AccountService()
    
    typealias QueryAccountStates  = (AccountStates?) -> Void
    typealias QueryAccountDetails = (AccountDetails?) -> Void
   
    
    // MARK: - Get account details.
    func fetchAccountDetails(_ completion : @escaping QueryAccountDetails) {
        let urlString = "account"
        let queryString = getUrlSession(endPoint: urlString)
        
        getDataFromUrl(queryString: queryString) { (data, error) in
            if let data = data {
                self.decodeInformation(AccountDetails.self, from: data, with: queryString, completion: { (details: AccountDetails?) in
                    completion(details)
                })
            }  else {
                completion(nil)
            }
        }
    }
    
    // MARK: - Get the list of your favorite movies.
    func fetchFavoriteMoviesOrTVShows(sectionName: String = "Favorite", type: APIRequest, endPoint: EndpointRequest, page: Int, _ completion : @escaping QuerySectionResult) {
        
        fetchSection(sectionName: sectionName, type: type, endPoint: endPoint, page: page) { (sectionResult) in
            
            if let sectionResult = sectionResult {
                completion(sectionResult)
            } else {
                completion(nil)
            }
        }
    }

    // MARK: - Grab the following account states for a session: rating, watchlist, favourite
    func fetchAccountStates(id: Int, type: APIRequest, endPoint: EndpointRequest, _ completion: @escaping QueryAccountStates) {
        
        let urlString = "\(type.rawValue)/\(id)/\(endPoint.rawValue)"
        let queryString = getUrlSession(endPoint: urlString)
        
        getDataFromUrl(queryString: queryString) { (data, error) in
            if let data = data {
                self.decodeInformation(AccountStates.self, from: data , with: queryString, completion: { (details: AccountStates?) in
                    completion(details)
                })
            }  else {
               completion(nil)
            }
        }
    }
    
   // MARK: - This method allows you to mark a movie or TV show as a favorite item.
    func markAsFavorite(id: Int, type: APIRequest, endPoint: EndpointRequest, mark: Bool,_ completion: @escaping QueryError) {
        
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
                    self.decodeInformation(SectionError.self, from: data, with: queryString, completion: { (response: SectionError?) in
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
}


