//
//  Constants.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

struct Constants {
    static let cornerRadius : CGFloat = 6.0
    static let numberOfItems: Int = 10
    static let placeholderImage = "placeholder"
}

struct Colors {
    static let rateColor = UIColor(netHex: 0xD6182A)
    static let titleColor = UIColor(netHex: 0x222222)
    static let headerColor = UIColor(netHex: 0x212121)
    static let subtitleColor = UIColor(netHex: 0x666666)
    static let navigationColor = UIColor(netHex: 0xFFFFFF)
    static let backgroundColor = UIColor(netHex: 0xF8F8F8)
}

struct Storyboard {
    static let hotViewCell = "HotViewCell"
    static let sectionViewCell = "SectionViewCell"
    static let imagesCollectionViewCell = "ImagesCollectionViewCell"
    static let fullCastCollectionViewCell = "FullCastCollectionViewCell"
    static let imagePreviewCollectionViewCell =  "ImagePreviewCollectionViewCell"

    static let movieListViewCell = "MovieListViewCell"
    static let movieListReusableView = "MovieListReusableView"
    static let movieListCollectionView = "MovieListCollectionView"
    
    static let tvNowViewCell = "TVNowViewCell"
    static let tvPopularViewCell = "TVPopularViewCell"
    static let tvSectionLabelViewCell = "TVSectionLabelViewCell"
    
    static let profileListViewCell = "ProfileListViewCell"
    static let profileHeaderReusableView = "ProfileHeaderReusableView"
    
    static let movieDetailsViewController = "MovieDetailsViewController"
    
    static let walkthroughViewCell = "WalkthroughViewCell"
    
    static let searchListViewCell = "SearchListViewCell"
        
}

struct Segue {
    static let toMovieTab = "segueToMovieTab"
    static let toMovieList = "segueToMovieList"
    static let toMovieDetail = "segueMovieToMovieDetail"
    
    static let toTVList = "segueTVToTVList"
    static let toTVDetail = "segueTVToTVDetail"
    
    static let toListDetail = "segueListToListDetail"

    static let toSearchList = "segueToSearchList"
    static let toSearchDetail = "segueSearchToSearchDetail"
    
    static let toProfileSetting = "segueToProfileSetting"
    
    static let toImagePreview = "segueToImagePreview"
}

struct StructType {
    static let Movie = "Movie"
    static let TVShow = "TVShow"
}

struct QueryString {
    static let page = "1"
    static let region = "IT"
    static let language = "it-IT"
    static let api_key = "3b122cc1b16808da5a679c3c1c11cd07"
    static let baseUrl = "https://api.themoviedb.org"
    static let append_to_response = "videos,credits"
}

struct EndPoint {
    
    // The Movie Database API - https://developers.themoviedb.org/3/movies/get-movie-details
    
    static let  MovieDetails = "https://api.themoviedb.org/3/movie/351286?api_key=3b122cc1b16808da5a679c3c1c11cd07&language=it-IT&append_to_response=videos%2Ccredits"
    
    static let NowMovies = "https://api.themoviedb.org/3/movie/now_playing?api_key=3b122cc1b16808da5a679c3c1c11cd07&language=it-IT&region=IT&page=1"
    
    static let PopularMovies = "https://api.themoviedb.org/3/movie/popular?api_key=3b122cc1b16808da5a679c3c1c11cd07&language=it-IT&region=IT&page=1"
    
    static let UpcomingMovies = "https://api.themoviedb.org/3/movie/upcoming?api_key=3b122cc1b16808da5a679c3c1c11cd07&language=it-IT&region=IT&page=1"
    
    static let SearchMovie = "https://api.themoviedb.org/3/search/movie?api_key=3b122cc1b16808da5a679c3c1c11cd07&language=it-IT&query=mario&include_adult=false&region=IT&page=1"

    // The TV Database API - https://developers.themoviedb.org/3/tv/get-tv-details
    
    static let TVShowDetails = "https://api.themoviedb.org/3/tv/1418?api_key=3b122cc1b16808da5a679c3c1c11cd07&language=it-IT&append_to_response=videos%2Ccredits"
    
    static let NowTVShows = "https://api.themoviedb.org/3/tv/on_the_air?api_key=3b122cc1b16808da5a679c3c1c11cd07&language=it-IT&page=1"
    
    static let PopularTVShows = "https://api.themoviedb.org/3/tv/popular?api_key=3b122cc1b16808da5a679c3c1c11cd07&language=it-IT&page=1"
    
    static let AiringTodayTVShows = "https://api.themoviedb.org/3/tv/airing_today?api_key=3b122cc1b16808da5a679c3c1c11cd07&language=it-IT&page=1"
    
    static let SearchTVShows = "https://api.themoviedb.org/3/search/tv?api_key=3b122cc1b16808da5a679c3c1c11cd07&language=it-IT&query=Mario&page=1"
    
    // The Genre Database API - https://developers.themoviedb.org/3/genres/get-movie-list
    
    static let GenreMovieList = "https://api.themoviedb.org/3/genre/movie/list?api_key=3b122cc1b16808da5a679c3c1c11cd07&language=it-IT"
    
    static let GenreTvList = "https://api.themoviedb.org/3/genre/tv/list?api_key=3b122cc1b16808da5a679c3c1c11cd07&language=it-IT"
    

    // movie_id = 351286
    static let CastAndCrewMovie = "https://api.themoviedb.org/3/movie/351286/credits?api_key=3b122cc1b16808da5a679c3c1c11cd07"
    
    // tv_id = 1418
    static let CastAndCrew = "https://api.themoviedb.org/3/tv/1418/credits?api_key=3b122cc1b16808da5a679c3c1c11cd07&language=it-IT"
}

struct ImageURL  {
    static let baseUrl = "https://image.tmdb.org/t/p"
    static let fileSize = "/w500"
    static let filePath = "\(baseUrl)\(fileSize)"
}
