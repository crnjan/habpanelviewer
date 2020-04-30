//
//  SingeltonServiceContainer.swift
//  HABPanelViewer
//
//  Created by Boris Krivonog on 04/05/2020.
//  Copyright © 2020 Boris Krivonog. All rights reserved.
//

import Foundation

final class SingeltonServiceContainer: ServiceContainer {
    private var container: [ObjectIdentifier : ValueContainer] = [:]
    
    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        container[ObjectIdentifier(type)] = ValueContainer(factory)
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        return container[ObjectIdentifier(type)]!.value(type)
    }
}

private final class ValueContainer {
    private var container: () -> Any = {}
    
    func value<T>(_ type: T.Type) -> T {
        return container() as! T
    }
    
    init(_ factory: @escaping () -> Any) {
        container = { [unowned self] in
            let value = factory()
            self.container = { value }
            return value
        }
    }
}
