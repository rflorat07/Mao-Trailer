//
//  Constants.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

typealias CompletionHandler = (_ Success: Bool) -> ()

struct Constants {
    static let cornerRadius : CGFloat = 6.0
    static let numberOfItems: Int = 10
    static let placeholderImage = UIImage(named: "placeholder")
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
    
    static let walkthroughViewCell = "WalkthroughViewCell"
    
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
    
    static let headerPersonDetailsViewCell  = "HeaderPersonDetailsViewCell"
    
    static let tvShowsTableViewCell = "TVShowsTableViewCell"
    static let filmographyTableViewCell = "FilmographyTableViewCell"
    static let filmographyCollectionViewCell = "FilmographyCollectionViewCell"
    
    static let detailInfoTableViewCell = "DetailInfoTableViewCell"
    static let detailCastTableViewCell = "DetailCastTableViewCell"
    static let detailImagesTableViewCell = "DetailImagesTableViewCell"
    
    static let detailCastCollectionViewCell = "DetailCastCollectionViewCell"
    static let detailImagesCollectionViewCell = "DetailImagesCollectionViewCell"
    
    static let peopleCollectionViewCell = "PeopleCollectionViewCell"
    
    static let searchListViewCell = "SearchListViewCell"
    static let searchGenreViewCell = "SearchGenreViewCell"
    static let searchOptionViewCell = "SearchOptionViewCell"
        
}

struct Segue {
    
    static let fromWalkthroughToTab = "segueWalkthroughToTab"
    
    static let fromMovieToList = "segueMovieToList"
    
    static let fromMovieToSearchList = "segueMovieToSearchList"
    
    static let fromTVToList = "segueTVToList"
    
    static let fromTVToSearchList = "segueTVToSearchList"
    
    static let fromPersonDetailsToDetails = "seguePersonDetailsToDetails"
    
    static let fromDetailsToPersonDetails = "segueDetailsToPersonDetails"
    
    static let fromDetailsToImagePreview = "segueDetailsToImagePreview"
    
    static let fromListToDetail = "segueListToDetail"
    
    static let fromMovieToDetail = "segueMovieToDetail"
    
    static let fromTVToDetail = "segueTVToDetail"
    
    static let fromProfileToDetail = "segueProfileToDetail"
    
    static let fromProfileLoginToProfile = "segueProfileLoginToProfile"
    
    static let fromSearchListToDetail = "segueSearchListToDetail"
    
    static let fromSearchOptionToDetail = "segueSearchOptionToDetail"
    
    static let fromProfileToProfileSetting = "segueProfileToProfileSetting"
    
    static let fromSearchListToSearchOption = "segueSearchListToSearchOption"
    
    static let fromPeopleToPersonDetails = "seguePeopleToPersonDetails"
}

struct StructType {
    static let Movie = "Movie"
    static let TVShow = "TVShow"
}

struct QueryString {
    static let page = "1"
    static let region = "IT"
    static let language = "en-US"
    static let sort_by = "popularity.desc"
    static let api_key = "3b122cc1b16808da5a679c3c1c11cd07"
    static let baseUrl = "https://api.themoviedb.org"
    static let informationDetails = "images,videos,credits"
    static let personDetails = "images,movie_credits,tv_credits"
}

struct ImageSize {
    static let large = "/w500"
    static let medium = "/w400"
    static let thumbnails = "/w200"
    static let original = "original"
    static let placeholderImage = "placeholder"
    static let baseUrl = "https://image.tmdb.org/t/p"
}

struct Gravatar {
    static let thumbnails = ".jpg?s=300"
    static let baseUrl = "https://secure.gravatar.com/avatar/"
}

struct UserInfo {
    static let userEmail = "userEmail"
    static let loggedInKey = "loggedIn"
    static let sessionID = "session_id"
    static let tokenKey = "request_token"
    static let tokenExpiresKey = "expires_at"
    static let walkthrough = "walkthrough"
}


extension Notification.Name {
    static let didUserChangedStatus = Notification.Name("didUserChangedStatus")
}

