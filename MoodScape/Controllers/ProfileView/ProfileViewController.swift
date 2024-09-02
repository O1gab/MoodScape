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
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 50
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
    
    private let inlineBarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.layer.cornerRadius = 15
        stackView.layer.masksToBounds = true
        stackView.backgroundColor = UIColor.clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let favouritesStackView = UIStackView()
        favouritesStackView.axis = .vertical
        favouritesStackView.distribution = .fill
        favouritesStackView.spacing = 4
        favouritesStackView.translatesAutoresizingMaskIntoConstraints = false

        let favouritesCountLabel = UILabel()
        favouritesCountLabel.text = "0" // Placeholder for actual number
        favouritesCountLabel.textColor = .white
        favouritesCountLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        favouritesCountLabel.textAlignment = .center
        
        let favouritesButton = UIButton(type: .system)
        favouritesButton.setTitle("Favourites", for: .normal)
        favouritesButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        favouritesButton.tag = 0
        favouritesButton.setTitleColor(.white, for: .normal)
        favouritesButton.backgroundColor = .clear
        
        favouritesStackView.addArrangedSubview(favouritesCountLabel)
        favouritesStackView.addArrangedSubview(favouritesButton)
        
        let searchesStackView = UIStackView()
        searchesStackView.axis = .vertical
        searchesStackView.distribution = .fill
        searchesStackView.spacing = 4
        searchesStackView.translatesAutoresizingMaskIntoConstraints = false

        let searchesCountLabel = UILabel()
        searchesCountLabel.text = "0" // Placeholder for actual number
        searchesCountLabel.textColor = .white
        searchesCountLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        searchesCountLabel.textAlignment = .center
        
        let searchesButton = UIButton(type: .system)
        searchesButton.setTitle("Searches", for: .normal)
        searchesButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        searchesButton.tag = 1
        searchesButton.setTitleColor(.white, for: .normal)
        searchesButton.backgroundColor = .clear
        
        searchesStackView.addArrangedSubview(searchesCountLabel)
        searchesStackView.addArrangedSubview(searchesButton)
        
        let friendsStackView = UIStackView()
        friendsStackView.axis = .vertical
        friendsStackView.distribution = .fill
        friendsStackView.spacing = 4
        friendsStackView.translatesAutoresizingMaskIntoConstraints = false

        let friendsCountLabel = UILabel()
        friendsCountLabel.text = "0" // Placeholder for actual number
        friendsCountLabel.textColor = .white
        friendsCountLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        friendsCountLabel.textAlignment = .center
        
        let friendsButton = UIButton(type: .system)
        friendsButton.setTitle("Friends", for: .normal)
        friendsButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        friendsButton.tag = 2
        friendsButton.setTitleColor(.white, for: .normal)
        friendsButton.backgroundColor = .clear
        
        friendsStackView.addArrangedSubview(friendsCountLabel)
        friendsStackView.addArrangedSubview(friendsButton)
        
        favouritesStackView.spacing = 0
        searchesStackView.spacing = 0
        friendsStackView.spacing = 0
        
        stackView.addArrangedSubview(favouritesStackView)
        stackView.addArrangedSubview(searchesStackView)
        stackView.addArrangedSubview(friendsStackView)
        
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name:"
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
    
    private let preferencesLabel: UILabel = {
        let label = UILabel()
        label.text = "Your music preferences"
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Share your profile", for: .normal)
        button.backgroundColor  = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 0.75).cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "gear", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.addSubview(settingsButton)
        scrollView.addSubview(backButton)
        scrollView.addSubview(profileImage)
        scrollView.addSubview(usernameLabel)
        scrollView.addSubview(inlineBarStackView)
        scrollView.addSubview(preferencesLabel)
        scrollView.addSubview(shareButton)
        scrollView.addSubview(editButton)
        
        settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        
        // Add target actions for inline bar buttons
        for view in inlineBarStackView.arrangedSubviews {
            if let button = view as? UIButton {
                button.addTarget(self, action: #selector(handleInlineBarButtonTap(_:)), for: .touchUpInside)
            }
        }
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 100),
            profileImage.heightAnchor.constraint(equalToConstant: 100),
            
            usernameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            inlineBarStackView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 15),
            inlineBarStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            inlineBarStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            inlineBarStackView.heightAnchor.constraint(equalToConstant: 70),
            
            preferencesLabel.topAnchor.constraint(equalTo: inlineBarStackView.bottomAnchor, constant: 30),
            preferencesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            editButton.topAnchor.constraint(equalTo: preferencesLabel.bottomAnchor, constant: 40),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 250),
            editButton.heightAnchor.constraint(equalToConstant: 50),
            
            shareButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: 250),
            shareButton.heightAnchor.constraint(equalToConstant: 50)
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
                    if let firstName = data?["name"] as? String {
                        self.nameLabel.attributedText = self.attributedText(
                            staticText: "Name: ",
                            dynamicText: firstName,
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
    
    @objc private func handleInlineBarButtonTap(_ sender: UIButton) {
        let viewController: UIViewController
        
        switch sender.tag {
        case 0:
            viewController = MainTabBarController() // FAVOURITES
        case 1:
            viewController = MainTabBarController() // SEARCHES
        case 2:
            viewController = MainTabBarController() // FRIENDS
        default:
            return
        }
        
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
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
