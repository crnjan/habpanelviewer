//
//  SettingsPresenterImpl.swift
//  HABPanelViewer
//
//  Created by Boris Krivonog on 04/05/2020.
//  Copyright © 2020 Boris Krivonog. All rights reserved.
//

import Foundation

final class SettingsPresenterImpl: SettingsPresenter {
    @DI private var settingsService: SettingsService

    weak var userInterface: SettingsUserInterface?

    func initialize() {
        userInterface?.viewState.settings = settingsService.settings
    }
    
    func save(settings: Settings) {
        settingsService.set(settings: settings)
    }
}
