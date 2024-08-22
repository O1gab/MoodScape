//
//  ProfileViewController.swift
//  MoodScape
//
//

import UIKit
import Gifu
import Firebase
import FirebaseAuth
import FirebaseFirestore

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
        label.font = UIFont.systemFont(ofSize: 18)
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
        fetchData()
        fetchExtraData()
    }
    
    // - MARK: SetupView
    private func setupView() {
        view.addSubview(profileImage)
        view.addSubview(usernameLabel)
        view.addSubview(firstNameLabel)
        view.addSubview(lastNameLabel)
        view.addSubview(emailLabel)
        view.addSubview(locationLabel)
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
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            registrationDate.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 15),
            registrationDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
             
            editButton.topAnchor.constraint(equalTo: registrationDate.bottomAnchor, constant: 40),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 160),
            editButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // - MARK: FetchData
    private func fetchData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)

        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            if let document = document, document.exists {
                let data = document.data()
                DispatchQueue.main.async {
                    if let username = data?["username"] as? String {
                        self.usernameLabel.text = username
                    }
                    if let email = data?["email"] as? String {
                        self.emailLabel.text = "Email: \(email)"
                    }
                    if let registrationDate = data?["registrationDate"] as? Timestamp {
                        let date = registrationDate.dateValue()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .medium
                        self.registrationDate.text = "Registration Date: \(dateFormatter.string(from: date))"
                    } else {
                        print("Registration date not available")
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }

    // - MARK: FetchExtraData
    private func fetchExtraData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)

        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            if let document = document, document.exists {
                let data = document.data()
                DispatchQueue.main.async {
                    if let firstName = data?["first_name"] as? String {
                        self.firstNameLabel.text = "First Name: \(firstName)"
                    }
                    if let lastName = data?["last_name"] as? String {
                        self.lastNameLabel.text = "Last Name: \(lastName)"
                    }
                    if let location = data?["location"] as? String {
                        self.locationLabel.text = "Location: \(location)"
                    }
                }
            } else {
                print("Document does not exist")
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
        self.present(profileSetupView, animated: true, completion: nil)
    }
}
