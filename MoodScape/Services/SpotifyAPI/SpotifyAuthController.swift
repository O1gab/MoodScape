//
//  SpotifyAuthController.swift
//  MoodScape
//
//  Created by Olga Batiunia on 11.09.24.
//

import UIKit
import WebKit

class SpotifyAuthController: UIViewController, WKNavigationDelegate {
    
    // MARK: - Properties
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    public var completionHandler: ((Bool) -> Void)?
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
        guard let url = SpotifyAuth.shared.signInURL else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }

        if url.absoluteString.starts(with: "moodscape://spotify-login") {
            guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value else {
                decisionHandler(.cancel)
                return
            }
            webView.isHidden = true
            SpotifyAuth.shared.exchangeCodeForToken(code: code) { [weak self] success in
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: {
                        self?.completionHandler?(success)
                    })
                }
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
