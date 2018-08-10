//
//  Authentication.swift
//  Mao Trailer
//
//  Created by Roger Florat on 08/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

struct Token: Decodable {
    let success: Bool
    let expires_at: String
    let request_token: String
}

struct NewSession: Decodable {
    let success: Bool
    let session_id: String
}

struct AccountDetails: Decodable {
    let id : Int
    let name: String
    let username: String
    let avatar: Avatar
    
    func getImageAvatar() -> String {
        return avatar.gravatar.hash
    }
}

struct Avatar: Decodable {
    let gravatar: Hash
}

struct Hash: Decodable {
    let hash: String
}
