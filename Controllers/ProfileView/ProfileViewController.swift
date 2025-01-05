//
//  ProfileViewController.swift
//  MoodScape
//
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfileViewController: ProfileBaseView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var selectedArtists: [Artist] = []
    private var collectionView: UICollectionView!
    
    private var preferences: [Artist] = []
    
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
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1.0)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
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
        favouritesButton.setTitle("Favorites", for: .normal)
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
        searchesCountLabel.text = "0"
        searchesCountLabel.textColor = .white
        searchesCountLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        searchesCountLabel.textAlignment = .center
        
        let searchesButton = UIButton(type: .system)
        searchesButton.setTitle("Moods", for: .normal)
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
        friendsCountLabel.text = "-"
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
    
    private let bioTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font =  UIFont.systemFont(ofSize: 18, weight: .medium)
        textView.textColor = .white
        textView.isEditable = false
        textView.backgroundColor = UIColor(white: 1, alpha: 0.05)
        textView.layer.cornerRadius = 12
        textView.layer.masksToBounds = true
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        textView.textAlignment = .left
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.isScrollEnabled = true
        return textView
    }()
    
    private let registrationDate: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let preferencesLabel: UILabel = {
        let label = GradientLabel()
        label.text = "Your Music Preferences"
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.gradientColors = [UIColor(red: 0/255.0, green: 104/255.0, blue: 80/255.0, alpha: 1.0), UIColor.darkGray, UIColor.black]
        return label
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Share Your Profile", for: .normal)
        button.backgroundColor  = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.addShadow()
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
    
    private lazy var mainView: MainViewController = {
        let viewController = MainViewController()
        viewController.loadViewIfNeeded()
        return viewController
    }()
    
    private let favoritesManager = FavoritesManager()
    
    private lazy var moodJournal: MoodJournalViewController = {
        let viewController = MoodJournalViewController()
        viewController.loadViewIfNeeded()
        return viewController
    }()
    
    private lazy var favoritesView: FavoritesViewController = {
        let viewController = FavoritesViewController()
        viewController.loadViewIfNeeded()
        return viewController
    }()
    
    private lazy var settingsView: SettingsViewController = {
        let viewController = SettingsViewController()
        viewController.loadViewIfNeeded()
        return viewController
    }()
    
    private lazy var profileSetupView: ProfileSetupViewController = {
        let viewController = ProfileSetupViewController()
        viewController.loadViewIfNeeded()
        return viewController
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
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
        setupView()
        setupConstraints()
        setupLabels()
        loadProfileImage()
        fetchData()
        fetchArtists()
        
        stopLoading()
    }
    
    // MARK: - SetupView
    private func setupView() {
        view.addSubview(scrollView)
        view.addSubview(loadingIndicator)
        view.addSubview(settingsButton)
        view.addSubview(backButton)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(gradientCircleView)
        contentView.addSubview(profileImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(separatorLine)
        contentView.addSubview(inlineBarStackView)
        contentView.addSubview(bioTextView)
        contentView.addSubview(preferencesLabel)
        contentView.addSubview(registrationDate)
        contentView.addSubview(shareButton)
        contentView.addSubview(editButton)
        
        settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        if let favouritesStackView = inlineBarStackView.arrangedSubviews.first as? UIStackView,
           let favouritesButton = favouritesStackView.arrangedSubviews.last as? UIButton {
            favouritesButton.addTarget(self, action: #selector(openFavoritesView), for: .touchUpInside)
        }
        
        if let searchesStackView = inlineBarStackView.arrangedSubviews[1] as? UIStackView,
            let moodButton = searchesStackView.arrangedSubviews.last as? UIButton {
            moodButton.addTarget(self, action: #selector(openMoodJournal), for: .touchUpInside)
        }
        
        setupCollectionView()
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
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            settingsButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            settingsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            profileImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 40),
            profileImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 150),
            profileImage.heightAnchor.constraint(equalToConstant: 150),
            
            gradientCircleView.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor),
            gradientCircleView.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            gradientCircleView.widthAnchor.constraint(equalToConstant: 225),
            gradientCircleView.heightAnchor.constraint(equalTo: gradientCircleView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
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
            
            bioTextView.topAnchor.constraint(equalTo: inlineBarStackView.bottomAnchor, constant: 20),
            bioTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            bioTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            bioTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            registrationDate.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 20),
            registrationDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            registrationDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            preferencesLabel.topAnchor.constraint(equalTo: registrationDate.bottomAnchor, constant: 40),
            preferencesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            
            collectionView.topAnchor.constraint(equalTo: preferencesLabel.bottomAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            
            editButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 200),
            editButton.heightAnchor.constraint(equalToConstant: 50),
            
            shareButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: 200),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            
            shareButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - StartLoading
    override func startLoading() {
        loadingIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    // MARK: StopLoading
    override func stopLoading() {
        loadingIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    // MARK: - SetupLabels
    private func setupLabels() {
        let songsCount = FavoritesManager.getFavoriteSongs(favoritesManager)().count
        let albumsCount = FavoritesManager.getFavoriteAlbums(favoritesManager)().count
        let totalFavorites = songsCount + albumsCount
        
        if let favoritesStackView = inlineBarStackView.arrangedSubviews.first as? UIStackView,
           let favoritesCountLabel = favoritesStackView.arrangedSubviews.first as? UILabel {
            favoritesCountLabel.text = "\(totalFavorites)"
        }
        
        if let searchesStackView = inlineBarStackView.arrangedSubviews[1] as? UIStackView,
            let searchesCountLabel = searchesStackView.arrangedSubviews.first as? UILabel {
            let playlistsCount = PlaylistStorage().fetchPlaylists().count
            searchesCountLabel.text = "\(playlistsCount)"
        }
        
        if let friendsStackView = inlineBarStackView.arrangedSubviews[2] as? UIStackView,
           let friendsCountLabel = friendsStackView.arrangedSubviews.first as? UILabel {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            
            let db = Firestore.firestore()
            db.collection("users").document(userId).getDocument { [weak self] (document, error) in
                if let document = document, document.exists {
                    if let friends = document.data()?["friends"] as? [String] {
                        DispatchQueue.main.async {
                            friendsCountLabel.text = "\(friends.count)"
                        }
                    } else {
                        DispatchQueue.main.async {
                            friendsCountLabel.text = "0"
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
    
    // MARK: SetupCollectionView
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PreferencesCell.self, forCellWithReuseIdentifier: "PreferencesCell")
        
        contentView.addSubview(collectionView)
    }
    
    // MARK: - FetchData
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
                    if let name = data?["name"] as? String {
                        self.nameLabel.text = name
                    }
                    
                    if let username = data?["username"] as? String {
                        self.usernameLabel.text = "@" + username
                    }
                    
                    if let registrationDate = data?["registrationDate"] as? Timestamp {
                        let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "MMMM d, yyyy"
                            let dateString = dateFormatter.string(from: registrationDate.dateValue())
                            DispatchQueue.main.async {
                                self.registrationDate.text = "On MoodScape since \(dateString)"
                            }
                    } else {
                        print("Registration date not available")
                    }
                    
                    if let bio = data?["bio"] as? String {
                        self.bioTextView.text = bio
                    } else {
                        self.bioTextView.text = "Set up your bio."
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // MARK: - FetchSelectedArtists
    private func fetchSelectedArtists(completion: @escaping ([String]?) -> Void) {
        let db = Firestore.firestore()
        let userId = Auth.auth().currentUser?.uid
        let userDocRef = db.collection("users").document(userId ?? "")
        
        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let artists = data?["selectedArtists"] as? [String]
                completion(artists)
            } else {
                self.showError("Failed to fetch selected artists")
                completion(nil)
            }
        }
    }
    
    // MARK: FetchArtists (Your preferences)
    private func fetchArtists(isRetry: Bool = false) {
        // Start loading at the beginning
        startLoading()
        
        // Reset retry count if this is not a retry attempt
        if !isRetry {
            fetchRetryCount = 0
        }
        
        // Step 1: Fetch selected artist names
        fetchSelectedArtists { [weak self] artistNames in
            guard let self = self else { 
                self?.stopLoading()
                return 
            }
            
            guard let artistNames = artistNames, !artistNames.isEmpty else {
                if self.fetchRetryCount < self.maxRetries {
                    self.fetchRetryCount += 1
                    print("Retry attempt \(self.fetchRetryCount) for fetching artists")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.fetchArtists(isRetry: true)
                    }
                } else {
                    self.stopLoading()
                    self.showError("Failed to fetch artist names after \(self.maxRetries) attempts")
                }
                return
            }
            
            let dispatchGroup = DispatchGroup()
            var artistIDs: [String] = []
            var artistDetails: [Artist] = []
            var hasError = false
            
            // Step 2: Convert artist names to IDs
            for artistName in artistNames {
                dispatchGroup.enter()
                
                SpotifyAPIManager.shared.fetchArtistID(for: artistName) { artistID in
                    if let artistID = artistID {
                        artistIDs.append(artistID)
                    } else {
                        print("Failed to fetch ID for artist: \(artistName)")
                        hasError = true
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                if artistIDs.isEmpty || hasError {
                    if self.fetchRetryCount < self.maxRetries {
                        self.fetchRetryCount += 1
                        print("Retry attempt \(self.fetchRetryCount) for fetching artist IDs")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.fetchArtists(isRetry: true)
                        }
                        return
                    } else {
                        self.stopLoading()
                        self.showError("Failed to fetch artist IDs after \(self.maxRetries) attempts")
                        return
                    }
                }
                
                // Step 3: Fetch artist details using IDs
                let detailGroup = DispatchGroup()
                var detailsError = false
                
                for artistID in artistIDs {
                    detailGroup.enter()
                    
                    SpotifyAPIManager.shared.fetchArtistDetails(for: artistID) { artist in
                        if let artist = artist {
                            artistDetails.append(artist)
                        } else {
                            print("Failed to fetch details for artist ID: \(artistID)")
                            detailsError = true
                        }
                        detailGroup.leave()
                    }
                }
                
                detailGroup.notify(queue: .main) {
                    if artistDetails.isEmpty || detailsError {
                        if self.fetchRetryCount < self.maxRetries {
                            self.fetchRetryCount += 1
                            print("Retry attempt \(self.fetchRetryCount) for fetching artist details")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self.fetchArtists(isRetry: true)
                            }
                            return
                        } else {
                            self.stopLoading()
                            self.showError("Failed to fetch artist details after \(self.maxRetries) attempts")
                            return
                        }
                    }
                    
                    // Step 4: Update the collection view and stop loading
                    self.selectedArtists = artistDetails
                    self.collectionView.reloadData()
                    self.stopLoading()
                }
            }
        }
    }
    
    // MARK: - AttributedText
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
    
    // MARK: ShowError
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - ProfileImageTapped
    @objc private func profileImageTapped() {
        let imagePreview = ImagePreviewViewController()
        imagePreview.image = profileImage.image
        imagePreview.modalPresentationStyle = .overCurrentContext
        present(imagePreview, animated: true, completion: nil)
    }
    
    // MARK: LoadProfileImage
    private func loadProfileImage() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        // Check cache first
        if let cachedImage = ImageCache.shared.getImage(forKey: userId) {
            profileImage.image = cachedImage
            return
        }
        let storageRef = Storage.storage().reference()
        let profileImageRef = storageRef.child("profile_images/\(userId)/profile.jpg")
        
        profileImageRef.getData(maxSize: 5 * 1024 * 1024) { [weak self] data, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error downloading profile image: \(error)")
                DispatchQueue.main.async {
                    self.profileImage.image = UIImage(systemName: "person.crop.circle")
                }
                return
            }
            
            if let imageData = data, let image = UIImage(data: imageData) {
                // Cache the image
                ImageCache.shared.setImage(image, forKey: userId)
                
                DispatchQueue.main.async {
                    self.profileImage.image = image
                }
            }
        }
    }
    
    // MARK: - HandleSettings
    @objc private func handleSettings() {
        settingsView.modalPresentationStyle = .fullScreen
        self.present(settingsView, animated: true)
    }
    
    // MARK: HandleEdit
    @objc private func handleEdit() {
        profileSetupView.modalPresentationStyle = .overCurrentContext
        self.present(profileSetupView, animated: true)
    }
    
    // MARK: HandleShare
    @objc private func handleShare() {
        guard let username = usernameLabel.text else { return }
        // TODO: REPLACE WITH ACTUAL APPSTORE LINK
        let appStoreLink = ""
        let textToShare = "Check out my profile on MoodScape: @\(username)\nDownload the app: \(appStoreLink)"
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - OpenFavoritesView
    @objc private func openFavoritesView() {
        favoritesView.modalPresentationStyle = .fullScreen
        present(favoritesView, animated: true)
    }
    
    // MARK: OpenMoodJournal
    @objc private func openMoodJournal() {
        moodJournal.modalPresentationStyle = .fullScreen
        present(moodJournal, animated: true)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedArtists.count
    }
    
    // - MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreferencesCell", for: indexPath) as! PreferencesCell
        let artist = selectedArtists[indexPath.item]
        cell.configure(with: artist)
        return cell
    }
        
    // - MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 190)
    }
    
    // - MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedArtist = selectedArtists[indexPath.item]
    }
}
