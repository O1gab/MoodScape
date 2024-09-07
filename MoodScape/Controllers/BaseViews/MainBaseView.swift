//
//  MainBaseView.swift
//  MoodScape
//
//

import UIKit
import Gifu
import FirebaseAuth

class MainBaseView: UIViewController {
    
    private let gifBackground: GIFImageView = {
        let gifBackground = GIFImageView()
        gifBackground.animate(withGIFNamed: "gradient_skyline_blinking_stars")
        gifBackground.contentMode = .scaleAspectFill
        gifBackground.translatesAutoresizingMaskIntoConstraints = false
        return gifBackground
    }()
    
    private let gifGradient: GIFImageView = {
        let gifBackground = GIFImageView()
        gifBackground.animate(withGIFNamed: "green_gradient")
        gifBackground.contentMode = .scaleAspectFill
        gifBackground.alpha = 0.5
        gifBackground.translatesAutoresizingMaskIntoConstraints = false
        return gifBackground
    }()

    let profileButton: UIButton = {
        let profileButton = UIButton(type: .custom)
        profileButton.layer.cornerRadius = 25
        profileButton.clipsToBounds = true
        profileButton.imageView?.contentMode = .scaleAspectFill
        return profileButton
    }()
    
    private let exitButton: UIButton = {
        let exitButton = UIButton(type: .system)
        exitButton.setImage(UIImage(systemName: "arrowshape.left.fill"), for: .normal)
        exitButton.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        return exitButton
    }()
    
    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupProfileButton()
        setupConstraints()
    }
    
    // - MARK: SetupView
    private func setupView() {
        view.addSubview(gifBackground)
        view.sendSubviewToBack(gifBackground)
        view.addSubview(gifGradient)
        
        profileButton.frame = CGRect(x: view.frame.width - 60, y: 50, width: 50, height: 50)
        profileButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        view.addSubview(profileButton)
        
        exitButton.addTarget(self, action: #selector(exitTapped), for: .touchUpInside)
        view.addSubview(exitButton)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gifBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifBackground.topAnchor.constraint(equalTo: view.topAnchor),
            gifBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            gifGradient.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifGradient.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifGradient.topAnchor.constraint(equalTo: view.topAnchor),
            gifGradient.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            profileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 210),
            profileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
        ])
    }
    
    // - MARK: SetupProfileButton
    private func setupProfileButton() {
        if let imageData = UserDefaults.standard.data(forKey: "profileImage"),
           let image = UIImage(data: imageData) {
            profileButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            profileButton.setImage(UIImage(systemName: "person.circle.fill"), for: .normal)
            profileButton.tintColor = .white
        }
    }
    
    // - MARK: ExitTapped
    @objc private func exitTapped() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    // - MARK: ProfileTapped
    @objc private func profileTapped() {
        let profileView = ProfileViewController()
        profileView.modalTransitionStyle = .flipHorizontal
        profileView.modalPresentationStyle = .fullScreen
        self.present(profileView, animated: true, completion: nil)
    }
}
