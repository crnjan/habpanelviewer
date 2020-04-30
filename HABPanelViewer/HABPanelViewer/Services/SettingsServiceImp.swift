//
//  SettingsServiceImp.swift
//  HABPanelViewer
//
//  Created by Boris Krivonog on 04/05/2020.
//  Copyright © 2020 Boris Krivonog. All rights reserved.
//

import Foundation

final class SettingsServiceImp: SettingsService {
    private (set) var settings = Persistence.settings() {
        didSet { Persistence.persist(settings) }
    }
    
    func set(settings: Settings) {
        guard self.settings != settings else {
            return
        }
        
        self.settings = settings
        NotificationCenter.default.post(name: .settingsServiceSettingsChanged, object: self, userInfo: nil)
    }
}

private struct Persistence {
    @UserDefault(key: "app.settings.openhabUrl")
    static var openhabUrlString: String?
    
    @UserDefault(key: "app.settings.homeDashboard")
    static var defaultDashboard: String?
    
    @UserDefault(key: "app.settings.username")
    static var username: String?
    
    @UserDefault(key: "app.settings.password")
    static var password: String?
}

private extension Persistence {
    static func settings() -> Settings {
        return Settings(
            openhabUrlString: openhabUrlString,
            defaultDashboard: defaultDashboard,
            username: username,
            password: password
        )
    }

    static func persist(_ settings: Settings) {
        openhabUrlString = settings.openhabUrlString
        defaultDashboard = settings.defaultDashboard
        username = settings.username
        password = settings.password
    }
}
