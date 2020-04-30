//
//  SettingsService.swift
//  HABPanelViewer
//
//  Created by Boris Krivonog on 03/05/2020.
//  Copyright © 2020 Boris Krivonog. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static let settingsServiceSettingsChanged = Self.init("settingsService.settingsChanged")
}

struct Settings: Equatable {
    var openhabUrlString: String?
    var defaultDashboard: String?
    var username: String?
    var password: String?
}


protocol SettingsService {
    var settings: Settings { get }
    
    func set(settings: Settings)
}
