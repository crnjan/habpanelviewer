//
//  UserDefault.swift
//  HABPanelViewer
//
//  Created by Boris Krivonog on 04/05/2020.
//  Copyright © 2020 Boris Krivonog. All rights reserved.
//

import Foundation

protocol UserDefaultType {
}

@propertyWrapper
struct UserDefault<T: UserDefaultType> {
    let key: String
    let userDefaults: UserDefaults = .standard
    
    var wrappedValue: T? {
        get { userDefaults.object(forKey: key) as? T }
        set { userDefaults.set(newValue, forKey: key) }
    }
}

extension String: UserDefaultType {
}

