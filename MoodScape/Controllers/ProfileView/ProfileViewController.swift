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

class ProfileViewController: ProfileBaseView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        label.text = "Your music preferences"
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.gradientColors = [UIColor.white, UIColor.gray, UIColor(red: 0/255.0, green: 104/255.0, blue: 80/255.0, alpha: 1.0)]
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
        button.layer.borderColor = UIColor.white.cgColor
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
    
    private let favoritesManager = FavoritesManager()
    
    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
        setupView()
        setupConstraints()
        determineGreeting()
        setupLabels()
        loadProfileImage()
        stopLoading()
    }
    
    // - MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
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
        scrollView.addSubview(greetingLabel)
        scrollView.addSubview(preferencesLabel)
        scrollView.addSubview(registrationDate)
        scrollView.addSubview(shareButton)
        scrollView.addSubview(editButton)
        
        settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
        
        if let favouritesStackView = inlineBarStackView.arrangedSubviews.first as? UIStackView,
           let favouritesButton = favouritesStackView.arrangedSubviews.last as? UIButton {
            favouritesButton.addTarget(self, action: #selector(openFavoritesView), for: .touchUpInside)
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
            
            greetingLabel.topAnchor.constraint(equalTo: inlineBarStackView.bottomAnchor, constant: 30),
            greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            preferencesLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 20),
            preferencesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            collectionView.topAnchor.constraint(equalTo: preferencesLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 120),
            
            registrationDate.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            registrationDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            registrationDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            editButton.topAnchor.constraint(equalTo: registrationDate.bottomAnchor, constant: 40),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 250),
            editButton.heightAnchor.constraint(equalToConstant: 50),
            
            shareButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: 250),
            shareButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // - MARK: DetermineGreeting
    private func determineGreeting() {
        guard let userId = Auth.auth().currentUser?.uid else {
            // TODO: ERROR HANDLING
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] (document, error) in
            if let error = error {
                print("Error fetching user document: \(error)")
                return
            }
            
            guard let document = document, document.exists else {
                print("User document does not exist")
                return
            }
            
            if let name = document.data()?["name"] as? String {
                print("fetched name: \(name)")
                DispatchQueue.main.async {
                    let hour = Calendar.current.component(.hour, from: Date())
                    var greeting = ""
                    
                switch hour {
                    case 5..<12:
                        greeting = "Good Morning"
                    case 12..<17:
                        greeting = "Hello"
                    case 17..<21:
                        greeting = "Good Afternoon"
                    case 21..<24, 0..<5:
                        greeting = "Good Night"
                    default:
                        greeting = "Hello"
                }
                    self?.greetingLabel.text = "\(greeting), \(name)"
                }
            } else {
                self?.greetingLabel.text = "Good to see you here"
            }
        }
    }
    
    private func setupLabels() {
        let songsCount = FavoritesManager.getFavoriteSongs(favoritesManager)().count
        let albumsCount = FavoritesManager.getFavoriteAlbums(favoritesManager)().count
        let totalFavorites = songsCount + albumsCount
        
        // Assuming the first subview in `inlineBarStackView` is the favorites stack view
        if let favoritesStackView = inlineBarStackView.arrangedSubviews.first as? UIStackView,
           let favoritesCountLabel = favoritesStackView.arrangedSubviews.first as? UILabel {
            favoritesCountLabel.text = "\(totalFavorites)"
        }
    }
    
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
        
        view.addSubview(collectionView)
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
                        let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "MMMM d, yyyy"
                            let dateString = dateFormatter.string(from: registrationDate.dateValue())
                            DispatchQueue.main.async {
                                self.registrationDate.text = "On MoodScape since \(dateString)"
                            }
                    } else {
                        print("Registration date not available")
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
    
    // - MARK: HandleShare
    @objc private func handleShare() {
        guard let username = usernameLabel.text else { return }
        // TODO: REPLACE WITH ACTUAL APPSTORE LINK
        let appStoreLink = ""
        let textToShare = "Check out my profile on MoodScape: @\(username)\nDownload the app: \(appStoreLink)"
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    // - MARK: OpenFavoritesView
    @objc private func openFavoritesView() {
        let favoritesView = FavoritesViewController()
        favoritesView.modalPresentationStyle = .fullScreen
        present(favoritesView, animated: true, completion: nil)
    }
    
    // - MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedArtists.count
    }
    
    // - MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreferencesCell", for: indexPath) as! PreferencesCell
         let artist = selectedArtists[indexPath.item]
         
         // Fetch image data asynchronously
         URLSession.shared.dataTask(with: artist.imageURL) { data, response, error in
             if let data = data, let image = UIImage(data: data) {
                 DispatchQueue.main.async {
                     cell.configure(with: image)
                 }
             }
         }.resume()
         
         return cell
    }
        
    // - MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 190)
    }
    
    // - MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAlbum = preferences[indexPath.item]
        // TODO: FIX IT
    }
}
