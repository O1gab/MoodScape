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
    
    private let backgroundContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let starsBackground: GIFImageView = {
        let gifBackground = GIFImageView()
        gifBackground.animate(withGIFNamed: "blinking_stars")
        gifBackground.contentMode = .scaleAspectFill
        gifBackground.translatesAutoresizingMaskIntoConstraints = false
        return gifBackground
    }()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 75
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let spotifyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "spotify.logo"), for: .normal)
        button.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name:"
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Name:"
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location:"
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let registrationDate: UILabel = {
        let label = UILabel()
        label.text = "Registration Date:"
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
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
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
        setupView()
        setupConstraints()
        loadProfileImage()
        stopLoading()
    }
    
    // - MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        fetchExtraData()
    }
    
    // - MARK: SetupView
    private func setupView() {
        view.addSubview(settingsButton)
        view.addSubview(backButton)
        view.addSubview(backgroundContainer)
        backgroundContainer.addSubview(starsBackground)
        starsBackground.addSubview(profileImage)
        
        view.addSubview(usernameLabel)
        view.addSubview(cardView)
        view.addSubview(editButton)
        cardView.addSubview(firstNameLabel)
        cardView.addSubview(lastNameLabel)
        cardView.addSubview(emailLabel)
        cardView.addSubview(locationLabel)
        cardView.addSubview(registrationDate)
        
        settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            backgroundContainer.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundContainer.heightAnchor.constraint(equalToConstant: 250),
            
            starsBackground.leadingAnchor.constraint(equalTo: backgroundContainer.leadingAnchor),
            starsBackground.trailingAnchor.constraint(equalTo: backgroundContainer.trailingAnchor),
            starsBackground.topAnchor.constraint(equalTo: backgroundContainer.topAnchor),
            starsBackground.bottomAnchor.constraint(equalTo: backgroundContainer.bottomAnchor),
            
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            profileImage.widthAnchor.constraint(equalToConstant: 150),
            profileImage.heightAnchor.constraint(equalToConstant: 150),
            
            usernameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            cardView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            firstNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            firstNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            firstNameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            
            lastNameLabel.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 10),
            lastNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            lastNameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            
            emailLabel.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 10),
            emailLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            
            locationLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            locationLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            
            registrationDate.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            registrationDate.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            registrationDate.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            registrationDate.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            
            editButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 40),
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
                        self.emailLabel.attributedText = self.attributedText(
                            staticText: "Email: ",
                            dynamicText: email,
                            staticColor: UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0),
                            dynamicColor: UIColor.white
                        )
                    }
                    
                    if let registrationDate = data?["registrationDate"] as? Timestamp {
                        let date = registrationDate.dateValue()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .medium
                        self.registrationDate.attributedText = self.attributedText(
                            staticText: "Registration Date: ",
                            dynamicText: dateFormatter.string(from: date),
                            staticColor: UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0),
                            dynamicColor: UIColor.white
                        )
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
                        self.firstNameLabel.attributedText = self.attributedText(
                            staticText: "First Name: ",
                            dynamicText: firstName,
                            staticColor: UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0),
                            dynamicColor: UIColor.white
                        )
                    }
                    
                    if let lastName = data?["last_name"] as? String {
                        self.lastNameLabel.attributedText = self.attributedText(
                            staticText: "Last Name: ",
                            dynamicText: lastName,
                            staticColor: UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0),
                            dynamicColor: UIColor.white
                        )
                    }
                    
                    if let location = data?["location"] as? String {
                        self.locationLabel.attributedText = self.attributedText(
                            staticText: "Location: ",
                            dynamicText: location,
                            staticColor: UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0),
                            dynamicColor: UIColor.white
                        )
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // - MARK: AttributedText
    private func attributedText(staticText: String, dynamicText: String, staticColor: UIColor, dynamicColor: UIColor) -> NSAttributedString {
        let staticFont = UIFont.systemFont(ofSize: 18, weight: .bold)
        let dynamicFont = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        let attributedString = NSMutableAttributedString(string: staticText, attributes: [
            .foregroundColor: staticColor,
            .font: staticFont
        ])
        let dynamicAttributedString = NSAttributedString(string: dynamicText, attributes: [
            .foregroundColor: dynamicColor,
            .font: dynamicFont
        ])
            
        attributedString.append(dynamicAttributedString)
        return attributedString
    }
    
    // - MARK: LoadProfileImage
    private func loadProfileImage() {
        if let imageData = UserDefaults.standard.data(forKey: "profileImage") {
            profileImage.image = UIImage(data: imageData)
        } else {
            profileImage.image = UIImage(systemName: "person.crop.circle")
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
