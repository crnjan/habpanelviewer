//
//  DI.swift
//  HABPanelViewer
//
//  Created by Boris Krivonog on 04/05/2020.
//  Copyright © 2020 Boris Krivonog. All rights reserved.
//

import Foundation

@propertyWrapper
struct DI<T> {
    var wrappedValue: T { ServiceLocator.current.resolve(T.self) }
}
