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

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            let phrase = "Let your emotions define the playlist."
            let words = phrase.split(separator: " ")
            var currentIndex = 0

            func showNextWord() {
                guard currentIndex < words.count else {
                    // Transition to the next view after the phrase is fully displayed
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self?.checkAuth()
                    }
                    return
                }

                let word = words[currentIndex]
                self?.messageLabel.text = String(word)
                
                currentIndex += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    showNextWord()
                }
            }
            
            showNextWord()
        }
    }
    
    // MARK: - SetupView
    private func setupView() {
        view.addSubview(welcomeGradient)
        view.addSubview(messageLabel)
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
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
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
            let db = Firestore.firestore()
            db.collection("users").document(userId).getDocument { [weak self] (document, error) in
                if let document = document, document.exists {
                    let firstUsage = document.data()?["firstUsage"] as? Bool ?? true
                    
                    if firstUsage {
                        // First time user, show auth flow
                        self?.transitionToNextView(nextViewController: self!.startSetup)
                        // Returning user, show main app
                        self?.transitionToNextView(nextViewController: self!.mainView)
                    }
                } else {
                    // Error or document doesn't exist, show auth flow
                    self?.transitionToNextView(nextViewController: self!.authView)
                }
            }
        } else {
            // No authenticated user, show auth flow
            self.transitionToNextView(nextViewController: authView)
        }
    }
}
