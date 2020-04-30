//
//  ServiceLocator.swift
//  HABPanelViewer
//
//  Created by Boris Krivonog on 04/05/2020.
//  Copyright © 2020 Boris Krivonog. All rights reserved.
//

import Foundation

final class ServiceLocator {
    static private(set) var current: ServiceResolver = { SingeltonServiceContainer() }()

    static func set(container: ServiceContainer) {
        current = container
    }
    
    private init() {
    }
}
