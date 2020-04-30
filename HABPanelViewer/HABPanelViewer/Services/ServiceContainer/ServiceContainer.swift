//
//  ServiceContainer.swift
//  HABPanelViewer
//
//  Created by Boris Krivonog on 03/05/2020.
//  Copyright © 2020 Boris Krivonog. All rights reserved.
//

import Foundation

protocol ServiceContainer: ServiceResolver {
    func register<T>(_ type: T.Type, factory: @escaping () -> T)
}

