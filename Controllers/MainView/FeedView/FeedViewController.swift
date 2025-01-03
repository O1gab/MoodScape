//
//  FeedViewController.swift
//  MoodScape
//
//

import UIKit
import SafariServices
import FirebaseAuth
import FirebaseFirestore

class FeedViewController: MainBaseView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Properties
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    
    private var albumCollectionView: UICollectionView!
    private var albums: [Album] = []
    
    private var firstRecommendedSongsCollectionView: UICollectionView!
    private var firstRecommendedSongs: [Song] = []
    
    private var secondRecommendedSongsCollectionView: UICollectionView!
    private var secondRecommendedSongs: [Song] = []
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
    indicator.color = .white
    indicator.hidesWhenStopped = true
    indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let topLabel: UILabel = {
        let topLabel = UILabel()
        topLabel.text = "Recently"
        topLabel.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        topLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        topLabel.textAlignment = .left
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        return topLabel
    }()
    
    private let recommendationsLabel: UILabel = {
        let label = UILabel()
        label.text = "You may also like"
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 0.75)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let infoMessage: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.isHidden = true
        view.layer.zPosition = CGFloat.greatestFiniteMagnitude
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "These recommendations are based on your favorite arists."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
        return view
    }()
    
    private let exploreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Explore more", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0).cgColor
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tabBar: UIStackView = {
        let favorites = UIButton(type: .system)
        favorites.setTitle("Favorites", for: .normal)
        favorites.titleLabel?.textAlignment = .center
        favorites.setTitleColor(UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0), for: .normal)
        favorites.backgroundColor = .clear
        favorites.layer.cornerRadius = 20
        favorites.layer.borderWidth = 2
        favorites.layer.borderColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0).cgColor
        favorites.clipsToBounds = true
        favorites.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        favorites.translatesAutoresizingMaskIntoConstraints = false
        favorites.addTarget(self, action: #selector(navigateToFavorites), for: .touchUpInside)
        
        let moodJournal = UIButton(type: .system)
        moodJournal.setTitle("Mood Journal", for: .normal)
        moodJournal.titleLabel?.textAlignment = .center
        moodJournal.setTitleColor(UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0), for: .normal)
        moodJournal.backgroundColor = .clear
        moodJournal.layer.cornerRadius = 20
        moodJournal.layer.borderWidth = 2
        moodJournal.layer.borderColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0).cgColor
        moodJournal.clipsToBounds = true
        moodJournal.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        moodJournal.translatesAutoresizingMaskIntoConstraints = false
        moodJournal.addTarget(self, action: #selector(navigateToMoodJournal), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [favorites, moodJournal])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white.withAlphaComponent(0.05)
        stackView.layer.cornerRadius = 20
        
        return stackView
    }()
    
    private lazy var mainView: MainViewController = {
        let viewController = MainViewController()
        viewController.loadViewIfNeeded()
        return viewController
    }()
    
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
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup UI first but hide content
        setupView()
        setupConstraints()
        
        // Hide all content initially
        contentView.alpha = 0
        profileButton.alpha = 0
        
        // Show loading indicator immediately
        view.bringSubviewToFront(loadingIndicator)
        loadingIndicator.startAnimating()
        
        // Create a dispatch group to track all async operations
        let loadingGroup = DispatchGroup()
        
        // Enter group for albums fetch
        loadingGroup.enter()
        fetchAlbums {
            loadingGroup.leave()
        }
        
        // Enter group for recommended songs fetch
        loadingGroup.enter()
        fetchRecommendedSongs {
            loadingGroup.leave()
        }
        
        // When all operations complete
        loadingGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            // Animate the transition
            UIView.animate(withDuration: 1.0) {
                self.contentView.alpha = 1
                self.profileButton.alpha = 1
                self.loadingIndicator.alpha = 0
            } completion: { _ in
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        infoButton.layoutIfNeeded()
        infoMessage.layoutIfNeeded()
    }
    
    // MARK: SetupView
    private func setupView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        view.addSubview(profileButton)
        view.addSubview(loadingIndicator)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.addSubview(tabBar)
        contentView.addSubview(topLabel)
        contentView.addSubview(loadingIndicator)
        contentView.addSubview(recommendationsLabel)
        contentView.addSubview(infoButton)
        contentView.addSubview(infoMessage)
        contentView.addSubview(exploreButton)
        
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .allTouchEvents)
        exploreButton.addTarget(self, action: #selector(handleExplore), for: .touchUpInside)
        setupAlbumCollectionView()
        setupRecommendedSongsCollectionView()
        setupSecondRecommendedSongsCollectionView()
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
            
            tabBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            tabBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tabBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            tabBar.heightAnchor.constraint(equalToConstant: 40),
            
            // "Recently"
            topLabel.topAnchor.constraint(equalTo: tabBar.bottomAnchor, constant: 20),
            topLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            albumCollectionView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: -25),
            albumCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            albumCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            albumCollectionView.heightAnchor.constraint(equalToConstant: 300),
            
            // "You may also like"
            recommendationsLabel.topAnchor.constraint(equalTo: albumCollectionView.bottomAnchor, constant: -25),
            recommendationsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recommendationsLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            // Songs recommendations
            firstRecommendedSongsCollectionView.topAnchor.constraint(equalTo: recommendationsLabel.bottomAnchor, constant: -10),
            firstRecommendedSongsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            firstRecommendedSongsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            firstRecommendedSongsCollectionView.heightAnchor.constraint(equalToConstant: 300),
            
            secondRecommendedSongsCollectionView.topAnchor.constraint(equalTo: firstRecommendedSongsCollectionView.bottomAnchor, constant: -50),
            secondRecommendedSongsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            secondRecommendedSongsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            secondRecommendedSongsCollectionView.heightAnchor.constraint(equalToConstant: 300),
            
            // Info buttons and labels
            infoButton.leadingAnchor.constraint(equalTo: recommendationsLabel.trailingAnchor, constant: 40),
            infoButton.centerYAnchor.constraint(equalTo: recommendationsLabel.centerYAnchor),
            infoButton.widthAnchor.constraint(equalToConstant: 25),
            infoButton.heightAnchor.constraint(equalToConstant: 25),
            infoButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
            
            infoMessage.topAnchor.constraint(equalTo: recommendationsLabel.bottomAnchor, constant: 5),
            infoMessage.leadingAnchor.constraint(equalTo: recommendationsLabel.leadingAnchor),
            infoMessage.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor, constant: -8),
            infoMessage.widthAnchor.constraint(lessThanOrEqualToConstant: 275),
            
            exploreButton.topAnchor.constraint(equalTo: secondRecommendedSongsCollectionView.bottomAnchor, constant: 100),
            exploreButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            exploreButton.widthAnchor.constraint(equalToConstant: 180),
            exploreButton.heightAnchor.constraint(equalToConstant: 50),
            exploreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - SetupAlbumCollectionView
    private func setupAlbumCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
            
        albumCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        albumCollectionView.backgroundColor = .clear
        albumCollectionView.showsHorizontalScrollIndicator = false
        albumCollectionView.translatesAutoresizingMaskIntoConstraints = false
        albumCollectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: "AlbumCell")
        albumCollectionView.dataSource = self
        albumCollectionView.delegate = self
        contentView.addSubview(albumCollectionView)
    }
    
    // MARK: - SetupRecommendedSongsCollectionView (You may also like)
    private func setupRecommendedSongsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        firstRecommendedSongsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        firstRecommendedSongsCollectionView.backgroundColor = .clear
        firstRecommendedSongsCollectionView.showsHorizontalScrollIndicator = false
        firstRecommendedSongsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        firstRecommendedSongsCollectionView.register(SongViewCell.self, forCellWithReuseIdentifier: "SongViewCell")
        firstRecommendedSongsCollectionView.dataSource = self
        firstRecommendedSongsCollectionView.delegate = self
        
        contentView.addSubview(firstRecommendedSongsCollectionView)
    }
    
    // MARK: - SetupSecondRecommendedSongsCollectionView (You may also like)
    private func setupSecondRecommendedSongsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        secondRecommendedSongsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        secondRecommendedSongsCollectionView.backgroundColor = .clear
        secondRecommendedSongsCollectionView.showsHorizontalScrollIndicator = false
        secondRecommendedSongsCollectionView.translatesAutoresizingMaskIntoConstraints = false

        secondRecommendedSongsCollectionView.register(SongViewCell.self, forCellWithReuseIdentifier: "SecondSongViewCell")
        secondRecommendedSongsCollectionView.dataSource = self
        secondRecommendedSongsCollectionView.delegate = self

        contentView.addSubview(secondRecommendedSongsCollectionView)
    }
    
    // MARK: - FetchAlbums (recently published popular albums)
    private func fetchAlbums(completion: @escaping () -> Void) {
        SpotifyAuthenticationManager.shared.authenticate { [weak self] success in
            guard success else {
                DispatchQueue.main.async {
                    self?.showError("Authentication failed")
                    completion()
                }
                return
            }
            
            SpotifyAPIManager.shared.fetchRecentlyPublishedAlbums { albums in
                DispatchQueue.main.async {
                    if let albums = albums {
                        self?.albums = albums
                        self?.albumCollectionView.reloadData()
                    } else {
                        self?.showError("Failed to fetch albums")
                    }
                    completion()
                }
            }
        }
    }
    
    // MARK: FetchRecommendedSongs (you may also like)
    private func fetchRecommendedSongs(completion: @escaping () -> Void) {
        fetchSelectedArtists { [weak self] artistNames in
            guard let artistNames = artistNames, !artistNames.isEmpty else {
                self?.showError("No artists selected")
                completion()
                return
            }
            
            let group = DispatchGroup()
            var allSongs: [Song] = []
            
            for artistName in artistNames {
                group.enter()
                
                SpotifyAPIManager.shared.fetchArtistID(for: artistName) { artistID in
                    guard let artistID = artistID else {
                        group.leave()
                        return
                    }
                    
                    SpotifyAPIManager.shared.fetchTopTracks(for: artistID) { songs in
                        if let songs = songs {
                            allSongs.append(contentsOf: songs)
                        }
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) {
                let shuffledSongs = Array(allSongs.shuffled().prefix(30))
                self?.firstRecommendedSongs = Array(shuffledSongs.prefix(15))
                self?.secondRecommendedSongs = Array(shuffledSongs.dropFirst(15))
                self?.firstRecommendedSongsCollectionView.reloadData()
                self?.secondRecommendedSongsCollectionView.reloadData()
                completion()
            }
        }
    }
    
    // MARK: FetchSelectedArtists
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
    
    // MARK: - ShowError
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - InfoButtonTapped
    @objc private func infoButtonTapped() {
        self.infoMessage.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.infoMessage.isHidden = true
        }
    }
    
    // TODO: FIX THAT!!!
    // MARK: HandleExplore
    @objc private func handleExplore() {
        let favoritesView = MoodJournalViewController()
        favoritesView.modalPresentationStyle = .fullScreen
        self.present(favoritesView, animated: true)
    }
    
    // MARK: - NavigateToFavorites
    @objc private func navigateToFavorites() {
        favoritesView.modalPresentationStyle = .fullScreen
        favoritesView.view.alpha = 0
        
        present(favoritesView, animated: false) { [weak self] in
            UIView.animate(withDuration: 0.2) {
                self?.favoritesView.view.alpha = 1
            }
        }
    }

    // MARK: - NavigateToMoodJournal
    @objc private func navigateToMoodJournal() {
        moodJournal.modalPresentationStyle = .fullScreen
        moodJournal.view.alpha = 0
        self.present(moodJournal, animated: false) { [weak self] in
            UIView.animate(withDuration: 0.2) {
                self?.moodJournal.view.alpha = 1
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == albumCollectionView {
            return albums.count
        } else if collectionView == firstRecommendedSongsCollectionView {
            return firstRecommendedSongs.count
        } else if collectionView == secondRecommendedSongsCollectionView {
            return secondRecommendedSongs.count
        }
        return 0
    }
    
    // MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // ALBUM COLLECTION VIEW
        if collectionView == albumCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCollectionViewCell
            let album = albums[indexPath.item]
            if let url = URL(string: album.imageUrl) {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let data = data, error == nil, let image = UIImage(data: data) else { return }
                        DispatchQueue.main.async {
                            cell.configure(with: image)
                        }
                    }
                    task.resume()
                }
            return cell

        // RECOMMENDED SONGS COLLECTIONS VIEW
        } else if collectionView == firstRecommendedSongsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongViewCell", for: indexPath) as! SongViewCell
            let song = firstRecommendedSongs[indexPath.item]
            cell.configure(with: song)
            return cell
        } else if collectionView == secondRecommendedSongsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondSongViewCell", for: indexPath) as! SongViewCell
            let song = secondRecommendedSongs[indexPath.item]
            cell.configure(with: song)
            return cell
        }
        
        return UICollectionViewCell()
    }
        
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // "Recently"
        if collectionView == albumCollectionView {
            return CGSize(width: 110, height: 190)
            
        // "You may also like"
        }  else if collectionView == firstRecommendedSongsCollectionView || collectionView == secondRecommendedSongsCollectionView {
            return CGSize(width: 150, height: 150) // Adjust height as necessary
        }
        
        // "Top songs this week"
        return CGSize(width: collectionView.bounds.width - 20, height: 80)
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == albumCollectionView {
            let selectedAlbum = albums[indexPath.item]
            let detailView = AlbumDetailsViewController(album: selectedAlbum)
            present(detailView, animated: true, completion: nil)
            
        } else if collectionView == firstRecommendedSongsCollectionView {
            let selectedSong = firstRecommendedSongs[indexPath.item]
            let detailView = SongDetailsViewController(song: selectedSong)
            present(detailView, animated: true, completion: nil)
        } else if collectionView == secondRecommendedSongsCollectionView {
            let selectedSong = secondRecommendedSongs[indexPath.item]
            let detailView = SongDetailsViewController(song: selectedSong)
            present(detailView, animated: true, completion: nil)
        }
    }
}
