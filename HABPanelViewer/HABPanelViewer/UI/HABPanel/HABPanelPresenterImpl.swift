//
//  HABPanelPresenterImpl.swift
//  HABPanelViewer
//
//  Created by Boris Krivonog on 03/05/2020.
//  Copyright © 2020 Boris Krivonog. All rights reserved.
//

import Foundation

final class HABPanelPresenterImpl: HABPanelPresenter {
    @DI private var settingsService: SettingsService
    @DI private var alertPresentingService: AlertPresentingService
    
    weak var userInterface: HABPanelUserInterface?
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onSettingsServiceSettingsChanged),
            name: .settingsServiceSettingsChanged,
            object: nil
        )
    }
    
    func load() {
        if let url = buildUrl() {
            userInterface?.load(url: url)
        } else {
            userInterface?.viewState.status = .error("Invalid OPENHAB url, please make sure your settings are set up correctly.")
        }
    }
    
    func set(progress: Float) {
        userInterface?.viewState.progress = progress
    }
        
    func didStartProvisionalNavigation() {
        userInterface?.viewState.status = .loading
    }
    
    func didFinish() {
        userInterface?.viewState.status = .loaded
    }
    
    func didFailProvisionalNavigation(with error: Error) {
        userInterface?.viewState.status = .error(error.localizedDescription)
    }
    
    func didReceive(challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let url = buildUrl(),
            challenge.protectionSpace.host == url.host,
            let user = settingsService.settings.username,
            let password = settingsService.settings.password {
            
            guard challenge.previousFailureCount == 0 else {
                completionHandler(.cancelAuthenticationChallenge, nil);
                return
            }

            let credential = URLCredential(
                user: user,
                password: password,
                persistence: .forSession
            )
            completionHandler(.useCredential, credential)
        
        } else {
            completionHandler(.performDefaultHandling, nil);
        }
    }
    
    func alert(in host: PresentingHost, with message: String, completionHandler: @escaping (Bool) -> Void) {
        alertPresentingService.present(in: host, with: message, completionHandler: completionHandler)
    }
    
    @objc private func onSettingsServiceSettingsChanged() {
        load()
    }
    
    private func buildUrl() -> URL? {
        guard var urlComponents = settingsService.settings.openhabUrlString.flatMap(URLComponents.init),
            urlComponents.scheme != nil,
            urlComponents.host != nil else {
            
            userInterface?.viewState.status = .error("Please make sure your settings are set up correctly.")
            return nil
        }
        
        urlComponents.path = "/habpanel/index.html"
        
        if let defaultDashboard = settingsService.settings.defaultDashboard, !defaultDashboard.isEmpty {
            urlComponents.fragment = "view/\(defaultDashboard)"
        }

        return urlComponents.url
    }
}
