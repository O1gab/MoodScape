//
//  SpotifySetupViewController.swift
//  MoodScape
//
//  Created by Olga Batiunia on 23.08.24.
//

import UIKit
import Gifu
import SafariServices
import WebKit
import FirebaseAuth
import FirebaseFirestore

class SpotifySetupView: SetupBaseView, SFSafariViewControllerDelegate {
    
    /*
     TODO: A USER CANNOT SKIP THIS SETTING
     */
    // MARK: - Properties
    private let gifGradient: GIFImageView = {
        let gifBackground = GIFImageView()
        gifBackground.animate(withGIFNamed: "green_gradient")
        gifBackground.contentMode = .scaleAspectFill
        gifBackground.alpha = 0.5
        gifBackground.translatesAutoresizingMaskIntoConstraints = false
        return gifBackground
    }()
    
    private let fieldLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let spotifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Connect to Spotify", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 30
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(UIColor(red: 181/255, green: 23/255, blue: 23/255, alpha: 1.0), for: .normal)
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var webView: WKWebView!
    
    public var userId: String = ""
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.startTypingAnimation(label: self?.fieldLabel ?? UILabel(), text: "Please, connect your account to Spotify", typingSpeed: 0.04) {
                self?.revealButton(button: self?.spotifyButton ?? UIButton())
                self?.revealButton(button: self?.skipButton ?? UIButton())
            }
        }
    }
    
    // MARK: - SetupView
    private func setupView() {
        view.addSubview(gifGradient)
        view.addSubview(fieldLabel)
        view.addSubview(spotifyButton)
        view.addSubview(skipButton)
        
        spotifyButton.addTarget(self, action: #selector(connectSpotify), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gifGradient.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifGradient.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifGradient.topAnchor.constraint(equalTo: view.topAnchor),
            gifGradient.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            fieldLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 270),
            fieldLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fieldLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            fieldLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            spotifyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 350),
            spotifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spotifyButton.widthAnchor.constraint(equalToConstant: 210),
            spotifyButton.heightAnchor.constraint(equalToConstant: 60),
            
            skipButton.topAnchor.constraint(equalTo: spotifyButton.bottomAnchor, constant: 20),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipButton.widthAnchor.constraint(equalToConstant: 120),
            skipButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
 
    // MARK: - ConnectSpotify
    @objc private func connectSpotify() {
        print("Connect to Spotify button tapped.")
        let authView = SpotifyAuthController()
        
        authView.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        authView.modalPresentationStyle = .fullScreen
        present(authView, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        // TODO: Log user in
        guard success else {
            showError("Something went wrong when signing in")
            return
        }
        // Debug
        SpotifyAuth.shared.fetchCurrentUserProfile { result in
            switch result {
            case .success(let userProfile):
                print("User ID: \(userProfile.id)")
                self.userId = userProfile.id
                self.saveUserId()
            case .failure(let error):
                self.showError("Failed to fetch userID!")
            }
        }
        self.navigateToNextView(viewController: MusicSetupView())
    }
    
    // - MARK: SaveUserId
    private func saveUserId() {
        // Save Spotify ID to UserDefaults TODO: MAYBE DELETE
        UserDefaults.standard.setValue(userId, forKey: "spotify_id")
        
        // Ensure the user is authenticated and get the Firebase UID
        guard let firebaseUID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated with Firebase.")
            return
        }
        
        // Save Spotify ID to Firebase under the Firebase UID
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(firebaseUID)
        
        userRef.setData(["spotify_id": userId], merge: true) { error in
            if let error = error {
                print("Error saving Spotify ID to Firebase: \(error.localizedDescription)")
            } else {
                print("Spotify ID successfully saved to Firebase.")
            }
        }
    }

    // - MARK: ShowError
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - HandleSkip
    @objc private func handleSkip() {
        navigateToNextView(viewController: MusicSetupView())
    }
}
