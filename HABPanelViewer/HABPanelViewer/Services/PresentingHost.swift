//
//  PresentingHost.swift
//  HABPanelViewer
//
//  Created by Boris Krivonog on 05/05/2020.
//  Copyright © 2020 Boris Krivonog. All rights reserved.
//

import UIKit

protocol PresentingHost {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

extension UIViewController: PresentingHost {
}
