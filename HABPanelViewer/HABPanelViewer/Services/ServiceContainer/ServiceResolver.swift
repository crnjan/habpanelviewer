//
//  ServiceResolver.swift
//  HABPanelViewer
//
//  Created by Boris Krivonog on 04/05/2020.
//  Copyright © 2020 Boris Krivonog. All rights reserved.
//

import Foundation

protocol ServiceResolver {
    func resolve<T>(_ type: T.Type) -> T
}
