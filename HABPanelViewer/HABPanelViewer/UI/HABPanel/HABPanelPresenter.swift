//
//  HABPanelPresenter.swift
//  HABPanelViewer
//
//  Created by Boris Krivonog on 03/05/2020.
//  Copyright © 2020 Boris Krivonog. All rights reserved.
//

import Foundation

struct HABPanelViewState {
    enum Status {
        case loading
        case loaded
        case error(String)
    }
    
    var status: Status = .loading
    var progress: Float = 0
}

protocol HABPanelPresenter: class {
    var userInterface: HABPanelUserInterface? { get set }

    func load()
    
    func set(progress: Float)
    
    func alert(in host: PresentingHost, with message: String, completionHandler: @escaping (Bool) -> Void)
    
    func didReceive(challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    func didStartProvisionalNavigation()
    func didFinish()
    func didFailProvisionalNavigation(with error: Error)
}

protocol HABPanelUserInterface: class {
    var viewState: HABPanelViewState { get set }
    
    func load(url: URL)
}
