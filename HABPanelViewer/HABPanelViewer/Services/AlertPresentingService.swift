//
//  AlertPresentingService.swift
//  HABPanelViewer
//
//  Created by Boris Krivonog on 05/05/2020.
//  Copyright © 2020 Boris Krivonog. All rights reserved.
//

import Foundation

protocol AlertPresentingService {
    func present(in host: PresentingHost, with message: String, completionHandler: @escaping (Bool) -> Void)
}
