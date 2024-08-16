//
//  ProfileViewController.swift
//  MoodScape
//
//

import UIKit
import Gifu
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    let gifBackground: GIFImageView = {
        let gifImageView = GIFImageView()
        gifImageView.animate(withGIFNamed: "gradient_skyline_blinking_stars")
        gifImageView.contentMode = .scaleAspectFill
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        return gifImageView
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "defaultProfileImage") // Placeholder image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 75
        imageView.backgroundColor = .black
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
        setupConstraints()
        fetchUsername()
    }
    
    // - MARK: SetupForm
    private func setupForm() {
        view.addSubview(gifBackground)
        view.sendSubviewToBack(gifBackground)
        view.addSubview(profileImage)
        view.addSubview(usernameLabel)
        view.addSubview(editButton)
        view.addSubview(backButton)
        view.addSubview(settingsButton)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            gifBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifBackground.topAnchor.constraint(equalTo: view.topAnchor),
            gifBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            settingsButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            profileImage.widthAnchor.constraint(equalToConstant: 150),
            profileImage.heightAnchor.constraint(equalToConstant: 150),
            
            usernameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                        
            editButton.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 160),
            editButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // - MARK: FetchUsername
    private func fetchUsername() {
        guard let userId = Auth.auth().currentUser?.uid else {
                print("User not logged in")
                return
            }
        
        // FIX THE ERROR HERE !!!
        
        let ref = Database.database().reference().child("users").child(userId)
        ref.observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any],
            let username = userData["username"] as? String {
                DispatchQueue.main.async {
                self.usernameLabel.text = username
                }
            } else {
                print("Failed to fetch user data")
            }
        }
    }
    
    // - MARK: HandleBack
    @objc private func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    // - MARK: HandleSettings
    @objc private func handleSettings() {
        let settingsView = SettingsViewController()
        settingsView.modalTransitionStyle = .crossDissolve
        settingsView.modalPresentationStyle = .fullScreen
        self.present(settingsView, animated: true, completion: nil)
    }
    
    // - MARK: HandleEdit
    @objc private func handleEdit() {
        let profileSetupView = ProfileSetupViewController()
        profileSetupView.modalTransitionStyle = .crossDissolve
        profileSetupView.modalPresentationStyle = .fullScreen
        self.present(profileSetupView, animated: true, completion: nil)
    }
    
}
