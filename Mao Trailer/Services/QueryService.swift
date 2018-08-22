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
    case Account = "account"
    case Discover = "discover"
}

enum EndPointType: String {
    case Popular  = "popular"
    case Upcoming = "upcoming"
    
    case NowTV    = "airing_today"
    case NowMovie = "now_playing"
    
    case FavoriteTV = "account_id/favorite/tv"
    case FavoriteMovies = "account_id/favorite/movies"
    
    case WatchlistTV = "account_id/watchlist/tv"
    case WatchlistMovies = "account_id/watchlist/movies"
    
    case RatedTV = "account_id/rated/tv"
    case RatedMovies = "account_id/rated/movies"
}

class QueryService {
    
    static let instance = QueryService()
    
    let defaults = UserDefaults.standard
    
    typealias QueryError         = ()-> Void
    
    typealias QueryGenres        = (GenreArray?) -> Void
    typealias QueryDetails       = (Details?) -> Void
    typealias QueryDetailsImages = (ImageArray?) -> Void
    
    typealias QuerySectionTV     = (SectionTVArray?) -> Void
    typealias QuerySectionMovie  = (SectionMovieArray?) -> Void
    typealias QuerySectionPeople = (People?) -> Void
    
    typealias QuerySectionData   = (Data?) -> Void
    typealias QuerySectionResult = (SectionData?) -> Void
    typealias QuerySectionArray  = ([SectionData]?) -> Void
    
    typealias QueryPersonDetails  = (PersonDetails?) -> Void
    
    lazy var configuration = URLSessionConfiguration.default
    lazy var session = URLSession(configuration: configuration)
    
    
    var sessionID: String {
        get {
            return defaults.value(forKey: UserInfo.sessionID) as! String
        }
    }
    
    
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
                
                self.decodeData(sectionName: sectionName, type: type, data: data, urlQuery: queryString, { (sectionResult) in
                    completion(sectionResult)
                })
            } else {
                
                self.decodeError(data!, queryString, {
                    completion(nil)
                })
            }
        }
        
        dataTask.resume()
    }
    
    // MARK: - Fetch popular people
    func fetchPopularPeople(page: Int, _ completion : @escaping QuerySectionPeople) {
        
        let queryString = getUrlPopularPeople(page: page, type: .Person , endPoint: .Popular)
        
        getDataFromUrl(queryString: queryString) { (data) in
            
            if let data = data {
                
                self.decodeInformation(People.self, from: data, with: queryString, completion: { (popular: People?) in
                    completion(popular)
                })
                
            } else {
                self.decodeError(data!, queryString, {
                    completion(nil)
                })
            }
        }
        
    }
    
    // MARK: - Fetch primary information
    func fetchPrimaryInformation(id: Int,  type: MediaType, _ completion : @escaping QueryDetails) {
        
        let queryString = getUrlDetails(id: id, type: type)
        
        getDataFromUrl(queryString: queryString) { (data) in
            
            if let data = data {
                
                self.decodeInformation(Details.self, from: data, with: queryString, completion: { (details: Details?) in
                    
                    completion(details)
                })
            } else {
                self.decodeError(data!, queryString, {
                    completion(nil)
                })
            }
        }
    }
    
    
    // MARK: - Fetch images information
    func fetchImagesInformation(id: Int,  type: MediaType, _ completion : @escaping QueryDetailsImages) {
        
        let queryString = getUrlImages(id: id, type: type)
        
        getDataFromUrl(queryString: queryString) { (data) in
            
            if let data = data {
                
                self.decodeInformation(ImageArray.self, from: data, with: queryString, completion: { (details: ImageArray?) in
                    
                    completion(details)
                })
                
            } else {
                self.decodeError(data!, queryString, {
                    completion(nil)
                })
            }
        }
    }
    
    
    // MARK: - Search Movie and TV
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
                self.decodeData(sectionName: "Search", type: type, data: data, urlQuery: urlQuery.string!, { (sectiondata) in
                    completion(sectiondata)
                })
            }
        }
        
    }
    
    // MARK: - Search People
    func searchForPeople(searchText: String, page: Int? = 1,type: MediaType, _ completion : @escaping QuerySectionPeople) {
        
        let queryString = getURLSearch(searchText: searchText, page: page!, type: type)
        
        getDataFromUrl(queryString: queryString) { (data) in
            if let data = data {
                self.decodeInformation(People.self, from: data, with: queryString, completion: { (search: People?) in
                    
                    completion(search)
                })
            } else {
                self.decodeError(data!, queryString, {
                    completion(nil)
                })
            }
        }
    }
    
    // MARK: - Fetch Genres Information
    func fetchOfficialGenres(type: MediaType, _ completion : @escaping QueryGenres) {
        
        let queryString = getUrlGenres(type: type)
        
        getDataFromUrl(queryString: queryString) { (data) in
            
            if let data = data {
                
                self.decodeInformation(GenreArray.self, from: data, with: queryString, completion: { (details: GenreArray? ) in
                    
                    completion(details)
                })
                
            } else {
                self.decodeError(data!, queryString, {
                    completion(nil)
                })
            }
        }
    }
    
    // MARK: - Discover Movie or TV by Genres
    func fetchDiscoverSectioByGenres(type: MediaType, genre: Int, page: Int,  _ completion : @escaping QuerySectionResult) {
        
        let queryString = getUrlDiscover(type: type, genre: genre, page: page)
        
        getDataFromUrl(queryString: queryString) { (data) in
            if let data = data {
                self.decodeData(sectionName: "Discover", type: type, data: data, urlQuery: queryString, { (sectionData) in
                    completion(sectionData)
                })
            } else {
                self.decodeError(data!, queryString, {
                    completion(nil)
                })
            }
        }
    }
    
    // MARK: - Fetch person Information
    func fetchPersonInformation(personId: Int, _ completion : @escaping QueryPersonDetails) {
        
        let queryString = getUrlPersonInformation(personId: personId, type: .Person)
        
        getDataFromUrl(queryString: queryString) { (data) in
            
            if let data = data {
                
                self.decodeInformation(PersonDetails.self, from: data, with: queryString, completion: { (details: PersonDetails? ) in
                    
                    completion(details)
                })
                
            } else {
                self.decodeError(data!, queryString, {
                    completion(nil)
                })
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
                completion(data)
            } else {
                self.decodeError(data!, queryString, {
                    completion(nil)
                })
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
        
        if type.rawValue == "account" {
        
            urlQuery.queryItems?.append(URLQueryItem(name: "session_id", value: sessionID))
        }
        
        return urlQuery.string!
    }
    
    // MARK: - URL Popular People
    fileprivate func getUrlPopularPeople(page: Int, type: MediaType, endPoint: EndPointType) -> String {
        
        var urlQuery = URLComponents(string: QueryString.baseUrl)!
        
        urlQuery.path = "/3/\(type.rawValue)/\(endPoint.rawValue)"
        
        urlQuery.queryItems = [
            URLQueryItem(name: "api_key", value: QueryString.api_key),
            URLQueryItem(name: "language", value: QueryString.language),
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
            // URLQueryItem(name: "language", value: QueryString.language),
            URLQueryItem(name: "append_to_response", value: QueryString.informationDetails)
        ]
        urlQuery.percentEncodedQuery = urlQuery.percentEncodedQuery?.replacingOccurrences(of: ",", with: "%2C")
        
        return urlQuery.string!
        
    }
    
    // MARK: - URL Person Information
    func getUrlPersonInformation(personId: Int,  type: MediaType) -> String {
        
        var urlQuery = URLComponents(string: QueryString.baseUrl)!
        
        urlQuery.path = "/3/\(type.rawValue)/\(personId)"
        
        urlQuery.queryItems = [
            URLQueryItem(name: "api_key", value: QueryString.api_key),
            URLQueryItem(name: "language", value: QueryString.language),
            URLQueryItem(name: "append_to_response", value: QueryString.personDetails)
        ]
        
        return urlQuery.string!
    }
    
    // MARK: - URL search
    func getURLSearch(searchText: String, page: Int, type: MediaType) -> String {
        
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
    
    fileprivate func decodeData(sectionName: String, type: MediaType ,data: Data, urlQuery: String, _ completion : @escaping  QuerySectionResult) {
        
        switch type {
        case .Movie:
            
            decodeInformation(SectionMovieArray.self, from: data, with: urlQuery) { (dataResult: SectionMovieArray?) in
                
                let sectionResult: SectionData = SectionData(page: dataResult!.page, total_pages: dataResult!.total_pages, sectionName: sectionName, sectionArray: dataResult!.results)
                
                completion(sectionResult)
            }
            
        case .TV:
            
            decodeInformation(SectionTVArray.self, from: data, with: urlQuery) { (dataResult: SectionTVArray?) in
                
                let sectionResult: SectionData = SectionData(page: dataResult!.page, total_pages: dataResult!.total_pages, sectionName: sectionName, sectionArray: dataResult!.results)
                
                completion(sectionResult)
            }
        
        case .Account:
            
            decodeInformation(SectionMovieArray.self, from: data, with: urlQuery) { (dataResult: SectionMovieArray?) in
                
                let sectionResult: SectionData = SectionData(page: dataResult!.page, total_pages: dataResult!.total_pages, sectionName: sectionName, sectionArray: dataResult!.results)
                
                completion(sectionResult)
            }
            
        default:
            print("Decode Data query type : \(type.rawValue) \n")
        }
    }
    
    
    // MARK: - Get Information
    
    fileprivate func decodeInformation<T>(_ type: T.Type, from data: Data, with url: String, completion : @escaping (T?) -> Void) where T : Decodable {
        
        DispatchQueue.main.async {
            
            do {
                let list = try JSONDecoder().decode(type, from: data)
                
                completion(list)
                
            } catch let decodeError as NSError {
                
                completion(nil)
                
                print("Decoder error: \(decodeError.localizedDescription) \n \n \(decodeError) \n \n Url: \(url)")
            }
        }
    }
    
    // MARK: - Decode error
    
    fileprivate func decodeError(_ data: Data, _ url: String, _ completion : @escaping QueryError) {
        DispatchQueue.main.async {
            do {
                let error = try JSONDecoder().decode(SectionError.self, from: data)
                completion()
                print("DataTask error status code: \(error.status_code ?? 404)  \(error.status_message ?? "Requested could not be found") \n Url \(url)")
                
            } catch let decodeError as NSError {
                completion()
                print("Decoder error: \(decodeError.localizedDescription)\n")
            }
        }
    }
}
