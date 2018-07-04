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
}


struct Storyboard {
    static let hotViewCell = "HotViewCell"
    static let sectionViewCell = "SectionViewCell"
    static let fullCastCollectionViewCell = "FullCastCollectionViewCell"

    static let movieListViewCell = "MovieListViewCell"
    static let movieListReusableView = "MovieListReusableView"
    static let movieListCollectionView = "MovieListCollectionView"
    
    static let tvNowViewCell = "TVNowViewCell"
    static let tvPopularViewCell = "TVPopularViewCell"
    static let tvSectionLabelViewCell = "TVSectionLabelViewCell"
    
    static let profileListViewCell = "ProfileListViewCell"
    static let profileHeaderReusableView = "ProfileHeaderReusableView"
    
    static let movieDetailViewController = "MovieDetailViewController"
    
    static let walkthroughViewCell = "WalkthroughViewCell"
        
}

struct Segue {
    static let ToMovieTab = "segueToMovieTab"
    static let toMovieList = "segueToMovieList"
    static let toMovieDetail = "segueToMovieDetail"
    static let toProfileSetting = "segueToProfileSetting"
}

struct StructType {
    static let Movie = "Movie"
    static let TVShow = "TVShow"
}

struct EndPoint {
    static let Movie = "https://api.themoviedb.org/3/discover/movie?api_key=3b122cc1b16808da5a679c3c1c11cd07&language=it-IT&sort_by=popularity.desc&include_adult=false&include_video=false&page=1"
    
    static let TVShow = "https://api.themoviedb.org/3/discover/tv?api_key=3b122cc1b16808da5a679c3c1c11cd07&language=it-IT&sort_by=popularity.desc&page=1&include_null_first_air_dates=false"
}
