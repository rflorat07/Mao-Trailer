//
//  UserDefaultsExt.swift
//  Mao Trailer
//
//  Created by Roger Florat on 24/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//
//  SwifterSwift

import Foundation

extension UserDefaults {
    
    public func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }
    
    
    public func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
    
}
