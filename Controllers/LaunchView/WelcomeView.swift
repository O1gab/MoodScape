//
//  WelcomeView.swift
//  MoodScape
//
//  Created by Olga Batiunia on 28.08.24.
//

import UIKit
import Gifu
import Firebase

class WelcomeView: StartBaseView {

    // MARK: - Properties
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let welcomeGradient: GIFImageView = {
        let gifBackground = GIFImageView()
        gifBackground.animate(withGIFNamed: "welcome_gradient")
        gifBackground.contentMode = .scaleAspectFill
        gifBackground.alpha = 0.5
        gifBackground.translatesAutoresizingMaskIntoConstraints = false
        return gifBackground
    }()
    
    private lazy var authView: AuthViewController = {
        let viewController = AuthViewController()
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }()

    private lazy var startSetup: StartSetupView = {
        let viewController = StartSetupView()
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }()

    private lazy var mainView: MainTabBarController = {
        let viewController = MainTabBarController()
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [weak self] in
            let phrase = "Let your emotions set the playlist."
            let words = phrase.split(separator: " ")
            var currentIndex = 0

            func showNextWord() {
                guard currentIndex < words.count else {
                    // Transition to the next view after the phrase is fully displayed
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                        self?.checkConnectivity()
                    }
                    return
                }

                let word = words[currentIndex]
                self?.messageLabel.text = String(word)
                
                currentIndex += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    showNextWord()
                }
            }
            
            showNextWord()
        }
    }
    
    private func checkConnectivity() {
        loadingIndicator.startAnimating()
        
        // Start monitoring first
        NetworkManager.shared.startMonitoring()
        
        // Give time for the monitor to initialize and check connection
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            if NetworkManager.shared.isConnected {
                NetworkManager.shared.stopMonitoring()
                self.checkAuth()
            } else {
                self.loadingIndicator.stopAnimating()
                self.showNoConnectionAlert()
            }
        }
    }
    
    // MARK: - SetupView
    private func setupView() {
        view.addSubview(welcomeGradient)
        view.addSubview(messageLabel)
        view.addSubview(loadingIndicator)
    }
    
    // MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            welcomeGradient.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            welcomeGradient.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            welcomeGradient.topAnchor.constraint(equalTo: view.topAnchor),
            welcomeGradient.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - TransitionToNextView
    private func transitionToNextView(nextViewController: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            nextViewController.modalPresentationStyle = .fullScreen
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = .fade
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            self?.view.window?.layer.add(transition, forKey: kCATransition)
            self?.present(nextViewController, animated: false)
        }
    }

    // MARK: - CheckAuth
    private func checkAuth() {
        if let userId = Auth.auth().currentUser?.uid {
            // User is authenticated, check firstUsage in Firestore
            let db = Firestore.firestore()
            db.collection("users").document(userId).getDocument { [weak self] (document, error) in
                if let document = document, document.exists {
                    let firstUsage = document.data()?["firstUsage"] as? Bool ?? true
                    
                    if firstUsage {
                        self?.transitionToNextView(nextViewController: self?.startSetup ?? StartSetupView())
                    } else {
                        self?.transitionToNextView(nextViewController: self?.mainView ?? MainTabBarController())
                    }
                } else {
                    self?.transitionToNextView(nextViewController: self?.authView ?? AuthViewController())
                }
            }
        } else {
            transitionToNextView(nextViewController: authView)
        }
    }
    
    // Add alert method
    private func showNoConnectionAlert() {
        let alert = UIAlertController(
            title: "No Internet Connection",
            message: "Please check your internet connection and try again.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.checkConnectivity()
        })
        
        present(alert, animated: true)
    }
}
