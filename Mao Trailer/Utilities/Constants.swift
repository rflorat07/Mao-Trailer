//
//  Constants.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

struct Constants {
    static let cornerRadius : CGFloat = 6
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
        
}

struct Segue {
    static let toMovieList = "segueToMovieList"
    static let toMovieDetail = "segueToMovieDetail"
}
