//
//  VisitorViewController.swift
//  MoodScape
//
//  Created by Olga Batiunia on 26.12.24.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class VisitorViewController: ProfileBaseView {
    
    // MARK: - Properties
    private let userId: String
    
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
    
    private let gradientCircleView: GradientCircleView = {
        let view = GradientCircleView()
        view.alpha = 0
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
        imageView.layer.cornerRadius = 75
        let config = UIImage.SymbolConfiguration(pointSize: 150, weight: .regular)
        imageView.image = UIImage(systemName: "person.circle.fill", withConfiguration: config)
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1.0)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let inlineBarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.layer.cornerRadius = 15
        stackView.layer.masksToBounds = true
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let favouritesStackView = UIStackView()
        favouritesStackView.axis = .vertical
        favouritesStackView.distribution = .fill
        favouritesStackView.spacing = 4
        favouritesStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let favouritesCountLabel = UILabel()
        favouritesCountLabel.text = "0"
        favouritesCountLabel.textColor = .white
        favouritesCountLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        favouritesCountLabel.textAlignment = .center
        
        let favouritesButton = UIButton(type: .system)
        favouritesButton.setTitle("Favorites", for: .normal)
        favouritesButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        favouritesButton.tag = 0
        favouritesButton.setTitleColor(.white, for: .normal)
        favouritesButton.backgroundColor = .clear
        
        favouritesStackView.addArrangedSubview(favouritesCountLabel)
        favouritesStackView.addArrangedSubview(favouritesButton)
        
        let friendsStackView = UIStackView()
        friendsStackView.axis = .vertical
        friendsStackView.distribution = .fill
        friendsStackView.spacing = 4
        friendsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let friendsCountLabel = UILabel()
        friendsCountLabel.text = "-"
        friendsCountLabel.textColor = .white
        friendsCountLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        friendsCountLabel.textAlignment = .center
        
        let friendsButton = UIButton(type: .system)
        friendsButton.setTitle("Friends", for: .normal)
        friendsButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        friendsButton.tag = 1
        friendsButton.setTitleColor(.white, for: .normal)
        friendsButton.backgroundColor = .clear
        
        friendsStackView.addArrangedSubview(friendsCountLabel)
        friendsStackView.addArrangedSubview(friendsButton)
        
        favouritesStackView.spacing = 0
        friendsStackView.spacing = 0
        
        stackView.addArrangedSubview(favouritesStackView)
        stackView.addArrangedSubview(friendsStackView)
        
        stackView.alpha = 0
        return stackView
    }()
    
    private let addFriendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add to Friends", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.addShadow()
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gear", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), for: .normal)
        
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 25
        button.addShadow()
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let favArtistsLabel: UILabel = {
        let label = GradientLabel()
        label.text = "User's Favorite Artists"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.gradientColors = [UIColor(red: 0/255.0, green: 104/255.0, blue: 80/255.0, alpha: 1.0), UIColor.darkGray, UIColor.black]
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var fetchRetryCount = 0
    private let maxRetries = 3
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Init
    init(userId: String) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
        setupView()
        setupConstraints()
        setupLabels()
        fetchData()
        //fetchArtists()
        
        stopLoading()
    }
    
    // MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 2.0) {
            self.gradientCircleView.alpha = 1
            self.profileImage.alpha = 1
            self.nameLabel.alpha = 1
            self.usernameLabel.alpha = 1
            self.separatorLine.alpha = 1
            self.inlineBarStackView.alpha = 1
            self.addFriendButton.alpha = 1
            self.settingsButton.alpha = 1
            self.favArtistsLabel.alpha = 1
        }
    }
    
    // MARK: - SetupView
    private func setupView() {
        view.addSubview(scrollView)
        view.addSubview(loadingIndicator)
        view.addSubview(backButton)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(gradientCircleView)
        contentView.addSubview(profileImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(separatorLine)
        contentView.addSubview(inlineBarStackView)
        contentView.addSubview(addFriendButton)
        contentView.addSubview(settingsButton)
        contentView.addSubview(favArtistsLabel)
        
        settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        addFriendButton.addTarget(self, action: #selector(handleAddFriend), for: .touchUpInside)
    }
    
    // MARK: SetupConstraints
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
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            profileImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 40),
            profileImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 150),
            profileImage.heightAnchor.constraint(equalToConstant: 150),
            
            gradientCircleView.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor),
            gradientCircleView.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            gradientCircleView.widthAnchor.constraint(equalToConstant: 225),
            gradientCircleView.heightAnchor.constraint(equalTo: gradientCircleView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: profileImage.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            usernameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            
            separatorLine.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            separatorLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            separatorLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            inlineBarStackView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 7),
            inlineBarStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            inlineBarStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            inlineBarStackView.heightAnchor.constraint(equalToConstant: 70),
            
            addFriendButton.topAnchor.constraint(equalTo: inlineBarStackView.bottomAnchor, constant: 20),
            addFriendButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 70),
            addFriendButton.heightAnchor.constraint(equalToConstant: 50),
            addFriendButton.widthAnchor.constraint(equalToConstant: 180),
            
            settingsButton.centerYAnchor.constraint(equalTo: addFriendButton.centerYAnchor),
            settingsButton.leadingAnchor.constraint(equalTo: addFriendButton.trailingAnchor, constant: 20),
            
            // "User's Favorite Artists"
            favArtistsLabel.topAnchor.constraint(equalTo: addFriendButton.bottomAnchor, constant: 30),
            favArtistsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            favArtistsLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
            
        ])
    }
    
    private func setupLabels() {
        // TODO: Setup Favorites count
        if let friendsStackView = inlineBarStackView.arrangedSubviews[1] as? UIStackView,
           let friendsCountLabel = friendsStackView.arrangedSubviews.first as? UILabel {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            let receiverId = self.userId
            
            let db = Firestore.firestore()
            db.collection("users").document(userId).getDocument { [weak self] (document, error) in
                if let document = document, document.exists {
                    if let name = document.data()?["name"] as? [String] {
                        DispatchQueue.main.async {
                            self?.favArtistsLabel.text = "\(name)'s Favorite Artists"
                        }
                    }
                    if let friends = document.data()?["friends"] as? [String] {
                        DispatchQueue.main.async {
                            friendsCountLabel.text = "\(friends.count)"
                            if friends.contains(userId) {       // TODO: DEBUG IT
                                self?.addFriendButton.setTitle("Already Friends", for: .normal)
                                self?.addFriendButton.isUserInteractionEnabled = false
                                self?.addFriendButton.backgroundColor = .darkGray
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            friendsCountLabel.text = "0"
                        }
                    }
                    if let requests = document.data()?["sent_requests"] as? [String] {
                        if requests.contains(receiverId) {
                            DispatchQueue.main.async {
                                self?.addFriendButton.setTitle("Request Already Sent", for: .normal)  // TODO: DEBUG IT FOR THE TEXT SIZE
                                self?.addFriendButton.isUserInteractionEnabled = false
                                self?.addFriendButton.backgroundColor = .darkGray
                            }
                        }
                    }
                } else {
                    print("Error fetching friends: \(error?.localizedDescription ?? "Unknown error")")
                    DispatchQueue.main.async {
                        friendsCountLabel.text = "0"
                    }
                }
            }
        }
    }
    
    
    // MARK: - HandleAddFriend
    @objc private func handleAddFriend() {
        print("button tapped")
        guard let currentUserId = Auth.auth().currentUser?.uid else { 
            print("No current user found")
            return 
        }
        let receiverId = self.userId
        let db = Firestore.firestore()

        
        // First check if they're already friends or if request is pending
        db.collection("users").document(currentUserId).getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error checking friend status: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                let friends = data?["friends"] as? [String] ?? []
                let sentRequests = data?["sent_requests"] as? [String] ?? []
                
                print("Friends: \(friends)")
                if friends.contains(self.userId) {
                    DispatchQueue.main.async {
                        self.addFriendButton.setTitle("Already Friends", for: .normal)
                        self.addFriendButton.isEnabled = false
                        self.addFriendButton.backgroundColor = .darkGray
                    }
                    return
                }
                
                if sentRequests.contains(self.userId) {
                    DispatchQueue.main.async {
                        self.addFriendButton.setTitle("Request Sent", for: .normal)
                        self.addFriendButton.isEnabled = false
                        self.addFriendButton.backgroundColor = .darkGray
                    }
                    return
                }
                
                // If not friends and no pending request, send friend request
                db.collection("users").document(currentUserId).updateData([
                    "sent_requests": FieldValue.arrayUnion([self.userId])
                ]) { error in
                    if let error = error {
                        print("Error updating sent requests: \(error.localizedDescription)")
                        return
                    }
                    
                    // Update receiver's received_requests
                    db.collection("users").document(self.userId).updateData([
                        "received_requests": FieldValue.arrayUnion([currentUserId])
                    ]) { error in
                        if let error = error {
                            print("Error updating received requests: \(error.localizedDescription)")
                            return
                        }
                        
                        DispatchQueue.main.async {
                            self.addFriendButton.setTitle("Request Sent", for: .normal)
                            self.addFriendButton.isEnabled = false
                            self.addFriendButton.backgroundColor = .darkGray
                        }
                    }
                }
            } else {
                print("Error fetching user data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    // MARK: - HandleSettings
    @objc private func handleSettings() {
        // TODO: open a window with selection: add to friends, block user, info???
        
    }
    
    private func loadImage(userId: String) {
        let storageRef = Storage.storage().reference()
        let profileImageRef = storageRef.child("profile_images/\(userId)/profile.jpg")
        
        // Show loading state
        profileImage.image = UIImage(systemName: "person.crop.circle")
        
        profileImageRef.getData(maxSize: 5 * 1024 * 1024) { [weak self] data, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error downloading visitor profile image: \(error)")
                DispatchQueue.main.async {
                    self.profileImage.image = UIImage(systemName: "person.crop.circle")
                }
            }
            
            if let imageData = data, let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.profileImage.image = image
                }
            }
        }
    }
    
    // MARK: - FetchData
    // TODO: combine this func with setupLabels()
    private func fetchData() {
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] (document, error) in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                DispatchQueue.main.async {
                    
                    if let name = data?["name"] as? String {
                        self?.nameLabel.text = name
                    }
                    if let username = data?["username"] as? String {
                        self?.usernameLabel.text = "@" + username
                    }
                    
                    // Load profile image
                    self?.loadImage(userId: self?.userId ?? "")
                }
            }
        }
    }
}
