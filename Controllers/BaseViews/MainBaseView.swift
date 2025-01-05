//
//  MainBaseView.swift
//  MoodScape
//
//

import UIKit
import Gifu
import FirebaseAuth
import FirebaseStorage

class MainBaseView: UIViewController {
    
    // MARK: - Properties
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
        let profileButton = UIButton(type: .system)
        profileButton.layer.cornerRadius = 25
        profileButton.clipsToBounds = true
        profileButton.imageView?.contentMode = .scaleAspectFill
        return profileButton
    }()
    
    private lazy var profileView: ProfileViewController = {
        let viewController = ProfileViewController()
        viewController.loadViewIfNeeded()
        return viewController
    }()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupProfileButton()
        setupConstraints()
    }
    
    // MARK: - SetupView
    private func setupView() {
        view.addSubview(gifBackground)
        view.sendSubviewToBack(gifBackground)
        view.addSubview(gifGradient)
        
        profileButton.frame = CGRect(x: view.frame.width - 60, y: 50, width: 50, height: 50)
        profileButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        view.addSubview(profileButton)
    }
    
    // MARK: SetupConstraints
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
            profileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        ])
    }
    
    // MARK: - SetupProfileButton
    private func setupProfileButton() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        // Check cache first
        if let cachedImage = ImageCache.shared.getImage(forKey: userId) {
            profileButton.setImage(cachedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            return
        }
        
        // If not in cache, load from Firebase Storage
        let storageRef = Storage.storage().reference()
        let profileImageRef = storageRef.child("profile_images/\(userId)/profile.jpg")
        
        // Set default image while loading
        profileButton.setImage(UIImage(systemName: "person.circle.fill"), for: .normal)
        profileButton.tintColor = .white
        
        profileImageRef.getData(maxSize: 5 * 1024 * 1024) { [weak self] data, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error downloading profile image: \(error)")
                return
            }
            
            if let imageData = data, let image = UIImage(data: imageData) {
                // Cache the image
                ImageCache.shared.setImage(image, forKey: userId)
                
                DispatchQueue.main.async {
                    self.profileButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
                }
            }
        }
    }
    
    // MARK: ProfileTapped
    @objc private func profileTapped() {
        profileView.modalTransitionStyle = .flipHorizontal
        profileView.modalPresentationStyle = .fullScreen
        self.present(profileView, animated: true, completion: nil)
    }
}
