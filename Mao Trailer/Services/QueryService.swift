//
//  QueryService.swift
//  Mao Trailer
//
//  Created by Roger Florat on 12/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

enum MediaType: String {
    case TV = "tv"
    case Movie = "movie"
    case Person = "person"
    case Discover = "discover"
}

enum EndPointType: String {
    case Popular  = "popular"
    case Upcoming = "upcoming"
    case NowTV    = "on_the_air"
    case NowMovie = "now_playing"
}

class QueryService {
    
    static let instance = QueryService()
    
    typealias QueryError         = ()-> Void
    
    typealias QueryGenres        = (GenreArray?)-> Void
    typealias QueryDetails       = (Details?)-> Void
    typealias QueryDetailsImages = (Images?)-> Void
    
    typealias QuerySectionTV     = (SectionTVArray?)-> Void
    typealias QuerySectionMovie  = (SectionMovieArray?)-> Void
    
    typealias QuerySectionData   = (Data?)-> Void
    typealias QuerySectionResult = (SectionData?)-> Void
    typealias QuerySectionArray  = ([SectionData]?)-> Void
    
    lazy var configuration = URLSessionConfiguration.default
    lazy var session = URLSession(configuration: configuration)
    
    
    // MARK: - Fetch All Session
    
    func fetchAllSection( sectionArray: [SectionInfo] ,_ completion : @escaping QuerySectionArray) {
        
        let group = DispatchGroup()
        var sectionDataArray = Array(repeating: SectionData(), count: sectionArray.count)
        
        sectionArray.enumerated().forEach { (index, element) in
            
            group.enter()
            
            fetchSection(sectionName: element.sectionName, type: element.type, endPoint: element.endPoint, page: element.page) { (sectionData) in
                
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
    
    func fetchSection( sectionName: String, type: MediaType, endPoint: EndPointType, page: Int, _ completion : @escaping QuerySectionResult) {
        
        let queryString = getUrlSection(page: page, type: type, endPoint: endPoint)
        
        guard let query = URL(string: queryString) else { return }
        
        let dataTask = session.dataTask(with: query) { (data, response, error) in
            
            if let error = error {
                print("DataTask error: \(error.localizedDescription) \n")
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                DispatchQueue.main.async {
                    self.decodeData(sectionName: sectionName, type: type, data: data, { (sectionResult) in
                        completion(sectionResult)
                    })
                }
            } else {
                DispatchQueue.main.async {
                    self.decodeError(data!, url: queryString, {
                        completion(nil)
                    })
                }
            }
        }
        
        dataTask.resume()
    }
    
    // MARK: - Fetch primary information
    func fetchPrimaryInformation(id: Int,  type: MediaType, _ completion : @escaping QueryDetails) {
        
        let queryString = getUrlDetails(id: id, type: type)
        
        getDataFromUrl(queryString: queryString) { (data) in
            
            if let data = data {
                
                self.decodeInformation(Details.self, from: data, completion: { (details: Details?) in
                    
                    completion(details)
                })
            } else {
                DispatchQueue.main.async {
                    self.decodeError(data!, url: queryString, {
                        completion(nil)
                    })
                }
            }
        }
    }
    
    
    // MARK: - Fetch images information
    func fetchImagesInformation(id: Int,  type: MediaType, _ completion : @escaping QueryDetailsImages) {
        
        let queryString = getUrlImages(id: id, type: type)
        
        getDataFromUrl(queryString: queryString) { (data) in
            
            if let data = data {
                
                self.decodeInformation(Images.self, from: data, completion: { (details: Images?) in
                    
                    completion(details)
                })
                
            } else {
                DispatchQueue.main.async {
                    self.decodeError(data!, url: queryString, {
                        completion(nil)
                    })
                }
            }
        }
    }
    
    
    // MARK: - Search
    func search(searchText: String, page: Int, type: MediaType, _ completion : @escaping QuerySectionResult) {
        
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
    
    // MARK: - Fetch Genres Information
    func fetchOfficialGenres(type: MediaType, _ completion : @escaping QueryGenres) {
        
        let queryString = getUrlGenres(type: type)
        
        getDataFromUrl(queryString: queryString) { (data) in
            
            if let data = data {
                
                self.decodeInformation(GenreArray.self, from: data, completion: { (details: GenreArray? ) in
                    
                    completion(details)
                })
                
            } else {
                DispatchQueue.main.async {
                    self.decodeError(data!, url: queryString, {
                        completion(nil)
                    })
                }
            }
        }
    }
    
    // MARK: - Discover Movie or TV by Genres
    func fetchDiscoverSectioByGenres(type: MediaType, genre: Int, page: Int,  _ completion : @escaping QuerySectionResult) {
        
        let queryString = getUrlDiscover(type: type, genre: genre, page: page)
        
        getDataFromUrl(queryString: queryString) { (data) in
            if let data = data {
                self.decodeData(sectionName: "Discover", type: type, data: data, { (sectionData) in
                    completion(sectionData)
                })
            } else {
                DispatchQueue.main.async {
                    self.decodeError(data!, url: queryString, {
                        completion(nil)
                    })
                }
            }
        }
    }
    
    // ==================== Helper =======================
    
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
                    self.decodeError(data!, url: queryString, {
                        completion(nil)
                    })
                }
            }
        }
        
        dataTask.resume()
    }
    
    // MARK: - URL Section
    
    fileprivate func getUrlSection(page: Int, type: MediaType, endPoint: EndPointType) -> String {
        
        var urlQuery = URLComponents(string: QueryString.baseUrl)!
        
        urlQuery.path = "/3/\(type.rawValue)/\(endPoint.rawValue)"
        
        urlQuery.queryItems = [
            URLQueryItem(name: "api_key", value: QueryString.api_key),
            URLQueryItem(name: "language", value: QueryString.language),
            URLQueryItem(name: "region", value: QueryString.region),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        return urlQuery.string!
    }
    
    // MARK: - URL Details
    
    fileprivate func getUrlDetails(id: Int,  type: MediaType) -> String {
        
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
    
    // MARK: - URL Genres
    
    fileprivate func getUrlGenres(type: MediaType) -> String {
        
        var urlQuery = URLComponents(string: QueryString.baseUrl)!
        
        urlQuery.path = "/3/genre/\(type.rawValue)/list"
        
        urlQuery.queryItems = [
            URLQueryItem(name: "api_key", value: QueryString.api_key),
            URLQueryItem(name: "language", value: QueryString.language)
        ]
        
        return urlQuery.string!
        
    }
    
    // MARK: - URL Discover
    fileprivate func getUrlDiscover(type: MediaType, genre: Int, page: Int) -> String {
        
        var urlQuery = URLComponents(string: QueryString.baseUrl)!
        
        urlQuery.path = "/3/discover/\(type.rawValue)"
        
        urlQuery.queryItems = [
            URLQueryItem(name: "api_key", value: QueryString.api_key),
            URLQueryItem(name: "language", value: QueryString.language),
            URLQueryItem(name: "sort_by", value: QueryString.sort_by),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "include_video", value: "false"),
            URLQueryItem(name: "region", value: QueryString.region),
            URLQueryItem(name: "with_genres", value: String(genre)),
            URLQueryItem(name: "page", value: String(page))
            
        ]
        
        return urlQuery.string!
    }
    
    
    // MARK: - URL Images
    fileprivate func getUrlImages(id: Int,  type: MediaType) -> String {
        
        var urlQuery = URLComponents(string: QueryString.baseUrl)!
        
        urlQuery.path = "/3/\(type.rawValue)/\(id)/images"
        
        urlQuery.queryItems = [
            URLQueryItem(name: "api_key", value: QueryString.api_key)
        ]
        
        return urlQuery.string!
    }
    
    // MARK: - Decode Data
    
    fileprivate func decodeData(sectionName: String, type: MediaType ,data: Data, _ completion : @escaping  QuerySectionResult) {
        
        switch type {
        case .Movie:
            
            decodeInformation(SectionMovieArray.self, from: data) { (dataResult: SectionMovieArray?) in
                
                let sectionResult: SectionData = SectionData(page: dataResult!.page, total_pages: dataResult!.total_pages, sectionName: sectionName, sectionArray: dataResult!.results)
                
                completion(sectionResult)
            }
            
        case .TV:
            
            decodeInformation(SectionTVArray.self, from: data) { (dataResult: SectionTVArray?) in
                
                let sectionResult: SectionData = SectionData(page: dataResult!.page, total_pages: dataResult!.total_pages, sectionName: sectionName, sectionArray: dataResult!.results)
                
                completion(sectionResult)
            }
            
        default:
            print("Query Session : \(sectionName) \n")
        }
    }
    
    
    // MARK: - Get Information
    
    fileprivate func decodeInformation<T>(_ type: T.Type,from data: Data, completion : @escaping (T?) -> Void) where T : Decodable {
        
        do {
            let list = try JSONDecoder().decode(type, from: data)
            
            completion(list)
            
        } catch let decodeError as NSError {
            
            print("Decoder error: \(decodeError.localizedDescription) \n")
        }
    }
    
    // MARK: - Decode error
    
    fileprivate func decodeError(_ data: Data, url: String, _ completion : @escaping QueryError) {
        
        do {
            let error = try JSONDecoder().decode(SectionError.self, from: data)
            completion()
            print("DataTask error status code: \(error.status_code ?? 404)  \(error.status_message ?? "Requested could not be found") \n Url \(url)")
            
        } catch let decodeError as NSError {
            completion()
            print("Decoder error: \(decodeError.localizedDescription) \n")
        }
        
    }
}
