//
//  ProfileViewController.swift
//  MoodScape
//
//

import UIKit
import Gifu
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: ProfileBaseView {
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "defaultProfileImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 75
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name:"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Name:"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location:"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let musicPreferencesLabel: UILabel = {
        let label = UILabel()
        label.text = "Music Preferences:"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let registrationDate: UILabel = {
        let label = UILabel()
        label.text = "Registration Date:"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let settingsButton: UIButton = {
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
        setupView()
        setupConstraints()
        fetchUsername()
    }
    
    // - MARK: SetupView
    private func setupView() {
        view.addSubview(profileImage)
        view.addSubview(usernameLabel)
        view.addSubview(firstNameLabel)
        view.addSubview(lastNameLabel)
        view.addSubview(emailLabel)
        view.addSubview(locationLabel)
        view.addSubview(musicPreferencesLabel)
        view.addSubview(registrationDate)
        view.addSubview(editButton)
        view.addSubview(settingsButton)
        
        settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            profileImage.widthAnchor.constraint(equalToConstant: 150),
            profileImage.heightAnchor.constraint(equalToConstant: 150),
                    
            usernameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    
            firstNameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 15),
            firstNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                    
            lastNameLabel.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 15),
            lastNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                    
            emailLabel.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 15),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            locationLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 15),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                    
            musicPreferencesLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 15),
            musicPreferencesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            registrationDate.topAnchor.constraint(equalTo: musicPreferencesLabel.bottomAnchor, constant: 15),
            registrationDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
             
            editButton.topAnchor.constraint(equalTo: registrationDate.bottomAnchor, constant: 40),
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
        
        let ref = Database.database().reference().child("users").child(userId)
        ref.observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any] {
                DispatchQueue.main.async {
                    if let username = userData["username"] as? String {
                        self.usernameLabel.text = username
                    }
                    if let firstName = userData["first_name"] as? String {
                        self.firstNameLabel.text = "First Name: \(firstName)"
                    }
                    if let lastName = userData["last_name"] as? String {
                        self.lastNameLabel.text = "Last Name: \(lastName)"
                    }
                    if let location = userData["location"] as? String {
                        self.locationLabel.text = "Location: \(location)"
                    }
                    if let musicPreferences = userData["music_preferences"] as? String {
                        self.musicPreferencesLabel.text = "Music Preferences: \(musicPreferences)"
                    }
                    if let registrationDate = userData["registrationDate"] as? Date {
                        self.registrationDate.text = "Registration Date: \(registrationDate)"
                    }
                }
            } else {
                print("Failed to fetch user data")
            }
        }
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
        profileSetupView.modalPresentationStyle = .overCurrentContext
        profileSetupView.modalTransitionStyle = .crossDissolve
        self.present(profileSetupView, animated: true, completion: nil)
    }
}
