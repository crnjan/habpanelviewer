//
//  AlertPresentingServiceImpl.swift
//  HABPanelViewer
//
//  Created by Boris Krivonog on 05/05/2020.
//  Copyright © 2020 Boris Krivonog. All rights reserved.
//

import UIKit

final class AlertPresentingServiceImpl: AlertPresentingService {
    func present(in host: PresentingHost, with message: String, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler(true)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in
            completionHandler(false)
        })

        host.present(alertController, animated: true, completion: nil)
    }
}
