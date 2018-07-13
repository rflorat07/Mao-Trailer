//
//  QueryService.swift
//  Mao Trailer
//
//  Created by Roger Florat on 12/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

enum QueryType: String {
    case TV = "tv"
    case Movie = "movie"
    case Person = "person"
}

enum EndPointType: String {
    case Popular  = "popular"
    case Upcoming = "upcoming"
    case NowTV    = "on_the_air"
    case NowMovie = "now_playing"
}

class QueryService {
    
    static let intance = QueryService()
    
    lazy var configuration = URLSessionConfiguration.default
    lazy var session = URLSession(configuration: configuration)
    
    typealias QueryError         = ()-> Void
    typealias QueryDetails       = (Details?)-> Void
    typealias QuerySectionTV     = (SectionTVArray?)-> Void
    typealias QuerySectionMovie  = (SectionMovieArray?)-> Void
    
    typealias QuerySectionData   = (Data?)-> Void
    typealias QuerySectionResult = (SectionData?)-> Void
    typealias QuerySectionArray  = ([SectionData]?)-> Void
    
    
    // MARK: - Fetch All Session
    
    func fetchAllSection( sectionArray: [SectionInfo] ,_ completion : @escaping QuerySectionArray) {
        
        let group = DispatchGroup()
        var sectionDataArray = Array(repeating: SectionData(), count: sectionArray.count)
        
        sectionArray.enumerated().forEach { (index, element) in
            
            group.enter()
            
            fetchSection(_sectionName: element.sectionName, _type: element.type, _endPoint: element.endPoint, _page: element.page) { (sectionData) in
                
                if let sectionData = sectionData {
                    
                    sectionDataArray[index] = sectionData
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            completion(sectionDataArray)
        })
        
    }
    
    // MARK: - Fetch Section
    
    func fetchSection( _sectionName: String, _type: QueryType, _endPoint: EndPointType, _page: Int, _ completion : @escaping QuerySectionResult) {
        
        let queryString = getUrlSection(page: _page, type: _type, endPoint: _endPoint)
        
        guard let query = URL(string: queryString) else { return }
        
        let dataTask = session.dataTask(with: query) { (data, response, error) in
            
            if let error = error {
                print("DataTask error: \(error.localizedDescription) \n")
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                DispatchQueue.main.async {
                    self.decodeData(sectionName: _sectionName, type: _type, data: data, { (sectionResult) in
                        
                        completion(sectionResult)
                    })
                }
            } else {
                DispatchQueue.main.async {
                    self.decodeError(data!, {
                        completion(nil)
                    })
                }
            }
        }
        
        dataTask.resume()
    }
    
    // MARK: - Fetch primary information
    func fetchPrimaryInformation(id: Int,  type: QueryType, _ completion : @escaping QueryDetails) {
        
        let queryString = getUrlDetails(id: id, type: type)
        
        getDataFromUrl(queryString: queryString) { (data) in
            
            if let data = data {
                self.decodePrimaryInformation(data, { (details) in
                    completion(details)
                })
            } else {
                DispatchQueue.main.async {
                    self.decodeError(data!, {
                        completion(nil)
                    })
                }
            }
        }
    }
    
    // MARK: - Search
    func search(searchText: String, page: Int, type: QueryType, _ completion : @escaping QuerySectionResult) {
     
        var urlQuery = URLComponents(string: QueryString.baseUrl)!
        
        urlQuery.path = "/3/search/\(type.rawValue)"
        urlQuery.queryItems = [
            URLQueryItem(name: "api_key", value: QueryString.api_key),
            URLQueryItem(name: "language", value: QueryString.language),
            URLQueryItem(name: "query", value: searchText),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "region", value: QueryString.region),
            URLQueryItem(name: "page", value: String(page))
        ]
        
        getDataFromUrl(queryString: urlQuery.string!) { (data) in
            if let data = data {
                DispatchQueue.main.async {
                    self.decodeData(sectionName: "Search", type: type, data: data, { (sectiondata) in
                        completion(sectiondata)
                    })
                }
            }
        }
        
    }
    
    // ===========================================
    
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
                DispatchQueue.main.async {
                    completion(data)
                }
            } else {
                DispatchQueue.main.async {
                    self.decodeError(data!, {
                        completion(nil)
                    })
                }
            }
        }
        
        dataTask.resume()
    }
    
    // MARK: - URL section
    
    fileprivate func getUrlSection(page: Int, type: QueryType, endPoint: EndPointType) -> String {
        
        var urlQuery = URLComponents(string: QueryString.baseUrl)!
        
        urlQuery.path = "/3/\(type.rawValue)/\(endPoint.rawValue)"
        
        urlQuery.queryItems = [
            URLQueryItem(name: "api_key", value: QueryString.api_key),
            URLQueryItem(name: "language", value: QueryString.language),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        return urlQuery.string!
    }
    
    // MARK: - URL details
    
    fileprivate func getUrlDetails(id: Int,  type: QueryType) -> String {
        
        var urlQuery = URLComponents(string: QueryString.baseUrl)!
        
        urlQuery.path = "/3/\(type.rawValue)/\(id)"
        urlQuery.queryItems = [
            URLQueryItem(name: "api_key", value: QueryString.api_key),
            URLQueryItem(name: "language", value: QueryString.language),
            URLQueryItem(name: "append_to_response", value: QueryString.append_to_response)
        ]
        urlQuery.percentEncodedQuery = urlQuery.percentEncodedQuery?.replacingOccurrences(of: ",", with: "%2C")
        
        return urlQuery.string!
        
    }
    
    // MARK: - Decode Data
    
    fileprivate func decodeData(sectionName: String, type: QueryType ,data: Data, _ completion : @escaping  QuerySectionResult) {
        
        switch type {
        case .Movie:
            
            decodeMovieList(data) { ( dataResult) in
                
                let sectionResult: SectionData = SectionData(page: dataResult!.page, total_pages: dataResult!.total_pages, sectionName: sectionName, sectionArray: dataResult!.results)
                
                completion(sectionResult)
            }
            
        case .TV:
            
            decodeTVList(data) { ( dataResult) in
                
                let sessionResult: SectionData = SectionData(page: dataResult!.page, total_pages: dataResult!.total_pages, sectionName: sectionName, sectionArray: dataResult!.results)
                
                completion(sessionResult)
            }
            
        default:
            print("Query Session : \(sectionName) \n")
        }
        
    }
    
    // MARK: - Decode Movie List
    
    fileprivate func decodeMovieList(_ data: Data, _ completion : @escaping QuerySectionMovie) {
        
        do {
            let list = try JSONDecoder().decode(SectionMovieArray.self, from: data)
            
            completion(list)
            
        } catch let decodeError as NSError {
            
            print("Decoder error: \(decodeError.localizedDescription) \n")
        }
    }
    
    // MARK: - Decode TV List
    
    fileprivate func decodeTVList(_ data: Data, _ completion : @escaping QuerySectionTV) {
        
        do {
            let list = try JSONDecoder().decode(SectionTVArray.self, from: data)
            
            completion(list)
            
        } catch let decodeError as NSError {
            print("Decoder error: \(decodeError.localizedDescription) \n")
        }
    }
    
    // MARK: - Decode primary information
    
    fileprivate func decodePrimaryInformation(_ data: Data, _ completion : @escaping QueryDetails) {
        
        do {
            let list = try JSONDecoder().decode(Details.self, from: data)
            
            completion(list)
            
        } catch let decodeError as NSError {
            print("Decoder error: \(decodeError.localizedDescription) \n")
        }
    }
    
    // MARK: - Decode error
    
    fileprivate func decodeError(_ data: Data, _ completion : @escaping QueryError) {
        
        do {
            let error = try JSONDecoder().decode(SectionError.self, from: data)
            completion()
            print("DataTask error status code: \(error.status_code ?? 404)  \(error.status_message ?? "Requested could not be found")")
            
        } catch let decodeError as NSError {
            completion()
            print("Decoder error: \(decodeError.localizedDescription) \n")
        }
        
    }
}
