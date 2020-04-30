//
//  HABPanelViewController.swift
//  HABPanelViewer
//
//  Created by Boris Krivonog on 03/05/2020.
//  Copyright © 2020 Boris Krivonog. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class HABPanelViewController: UIViewController, HABPanelUserInterface, WKUIDelegate, WKNavigationDelegate {
    
    private var observers: [NSKeyValueObservation] = []
    
    private lazy var presenter: HABPanelPresenter = {
        let presenter = HABPanelPresenterImpl()
        presenter.userInterface = self
        return presenter
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        observers = [
            webView.observe(\.estimatedProgress, options: [.new]) { [presenter] webView, _ in
                presenter.set(progress: Float(webView.estimatedProgress))
            }
        ]

        return webView
    }()
    
    private let progressView = UIProgressView(progressViewStyle: .default)
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private lazy var loadingContainerView: UIView = {
        let imageView = UIImageView(image: UIImage(named: "oh_logo"))
        imageView.contentMode = .scaleAspectFit
        
        let centerView = UIView()
        centerView.addSubview(imageView)
        centerView.addSubview(progressView)
        centerView.addSubview(infoLabel)

        let containerView = UIView()
        containerView.backgroundColor = .black
        containerView.addSubview(centerView)

        progressView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.topAnchor.constraint(equalTo: centerView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerView.centerXAnchor),
            
            progressView.widthAnchor.constraint(equalToConstant: 250),
            progressView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: centerView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: centerView.trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: centerView.bottomAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -64),
            infoLabel.leadingAnchor.constraint(equalTo: centerView.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: centerView.trailingAnchor)
        ])
        
        centerView.centerUsingAutoLayout()
        
        return containerView
    }()

    var viewState: HABPanelViewState = HABPanelViewState() {
        didSet {
            updateView()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        webView.fillUsingAutoLayout()
        
        view.addSubview(loadingContainerView)
        loadingContainerView.fillUsingAutoLayout()

        presenter.load()
    }
        
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let settingsViewController = SettingsViewController()
            present(settingsViewController, animated: true)
        }
    }
    
    private func updateView() {
        switch viewState.status {
        case .loading:
            infoLabel.isHidden = true
            progressView.isHidden = false
            loadingContainerView.alpha = 1
            progressView.progress = viewState.progress
        case .loaded:
            UIView.animate(withDuration: 1.2) {
                self.loadingContainerView.alpha = 0
            }
        case .error(let reason):
            loadingContainerView.alpha = 1
            progressView.isHidden = true
            infoLabel.isHidden = false
            infoLabel.text = reason
        }
    }
    
    func load(url: URL) {
        webView.load(URLRequest(url: url))
    }
    
    // MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        presenter.didStartProvisionalNavigation()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        presenter.didFinish()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        presenter.didFailProvisionalNavigation(with: error)
    }
    
    func webView(
        _ webView: WKWebView,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        presenter.didReceive(challenge: challenge, completionHandler: completionHandler)
    }
    
    // MARK: WKUIDelegate
    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if let url = navigationAction.request.url {
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
        
        return nil
    }
    
    func webView(
        _ webView: WKWebView,
        runJavaScriptConfirmPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (Bool) -> Void) {

        presenter.alert(in: self, with: message, completionHandler: completionHandler)
    }
    
}
