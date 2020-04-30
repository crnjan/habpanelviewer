//
//  SettingsPresenter.swift
//  HABPanelViewer
//
//  Created by Boris Krivonog on 04/05/2020.
//  Copyright © 2020 Boris Krivonog. All rights reserved.
//

import Foundation

struct SettingsViewState {
    var settings: Settings?
}

protocol SettingsUserInterface: class {
    var viewState: SettingsViewState { get set }
}

protocol SettingsPresenter {
    var userInterface: SettingsUserInterface? { get set }
    
    func initialize()
    func save(settings: Settings)
}
