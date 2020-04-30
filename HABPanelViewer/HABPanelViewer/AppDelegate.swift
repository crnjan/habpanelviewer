//
//  AppDelegate.swift
//  HABPanelViewer
//
//  Created by Boris Krivonog on 02/05/2020.
//  Copyright © 2020 Boris Krivonog. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let container = SingeltonServiceContainer()
        container.register(SettingsService.self) { SettingsServiceImp() }
        container.register(AlertPresentingService.self) { AlertPresentingServiceImpl() }
        ServiceLocator.set(container: container)
        
        let window = UIWindow()
        window.rootViewController = HABPanelViewController()
        self.window = window
        window.makeKeyAndVisible()
        
        return true
    }

}

