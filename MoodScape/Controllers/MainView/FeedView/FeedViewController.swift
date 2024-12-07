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
    
    private var songCollectionView: UICollectionView!
    private var topWeeklySongs: [Song] = []
    
    private var firstRecommendedSongsCollectionView: UICollectionView!
    private var firstRecommendedSongs: [Song] = []
    
    private var secondRecommendedSongsCollectionView: UICollectionView!
    private var secondRecommendedSongs: [Song] = []
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
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
    
    private let topSongsLabel: UILabel = {
        let label = UILabel()
        label.text = "Top songs this week"
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first {
               window.addSubview(view)
           }
        
        let label = UILabel()
        label.text = "These recommendations are based on your preferences that you set up before."
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
        loadingIndicator.startAnimating()
        setupView()
        setupConstraints()
        fetchAlbums()
        fetchTopSongs()
        fetchRecommendedSongs()
        loadingIndicator.stopAnimating()
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
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.addSubview(tabBar)
        contentView.addSubview(topLabel)
        contentView.addSubview(topSongsLabel)
        contentView.addSubview(loadingIndicator)
        contentView.addSubview(recommendationsLabel)
        contentView.addSubview(infoButton)
        contentView.addSubview(infoMessage)
        contentView.addSubview(exploreButton)
        
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .allTouchEvents)
        exploreButton.addTarget(self, action: #selector(handleExplore), for: .touchUpInside)
        setupAlbumCollectionView()
        setupSongCollectionView()
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
            
            // "Top songs this week"
            topSongsLabel.topAnchor.constraint(equalTo: albumCollectionView.bottomAnchor, constant: -25),
            topSongsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            songCollectionView.topAnchor.constraint(equalTo: topSongsLabel.bottomAnchor, constant: 5),
            songCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            songCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            songCollectionView.heightAnchor.constraint(equalToConstant: 450),
            
            // "You may also like"
            recommendationsLabel.topAnchor.constraint(equalTo: songCollectionView.bottomAnchor, constant: 25),
            recommendationsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recommendationsLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            firstRecommendedSongsCollectionView.topAnchor.constraint(equalTo: recommendationsLabel.bottomAnchor, constant: -45),
            firstRecommendedSongsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            firstRecommendedSongsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            firstRecommendedSongsCollectionView.heightAnchor.constraint(equalToConstant: 300),
            
            secondRecommendedSongsCollectionView.topAnchor.constraint(equalTo: firstRecommendedSongsCollectionView.bottomAnchor, constant: -50),
            secondRecommendedSongsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            secondRecommendedSongsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            secondRecommendedSongsCollectionView.heightAnchor.constraint(equalToConstant: 300),
            
            
            infoButton.leadingAnchor.constraint(equalTo: recommendationsLabel.trailingAnchor, constant: 40),
            infoButton.centerYAnchor.constraint(equalTo: recommendationsLabel.centerYAnchor),
            infoButton.widthAnchor.constraint(equalToConstant: 25),
            infoButton.heightAnchor.constraint(equalToConstant: 25),
            infoButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
            
            infoMessage.topAnchor.constraint(equalTo: recommendationsLabel.bottomAnchor, constant: 8),
            infoMessage.leadingAnchor.constraint(equalTo: recommendationsLabel.leadingAnchor),
            infoMessage.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor, constant: -8),
            infoMessage.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            exploreButton.topAnchor.constraint(equalTo: secondRecommendedSongsCollectionView.bottomAnchor, constant: 100),
            exploreButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            exploreButton.widthAnchor.constraint(equalToConstant: 180),
            exploreButton.heightAnchor.constraint(equalToConstant: 50),
            exploreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100)
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
    
    // MARK: - SetupSongCollectionView (Top songs this week)
    private func setupSongCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        songCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        songCollectionView.backgroundColor = .clear
        songCollectionView.showsVerticalScrollIndicator = false
        songCollectionView.scrollsToTop = false
        songCollectionView.isScrollEnabled = false
        songCollectionView.translatesAutoresizingMaskIntoConstraints = false
        songCollectionView.register(SongCardCollectionViewCell.self, forCellWithReuseIdentifier: "SongCardCell")
        songCollectionView.dataSource = self
        songCollectionView.delegate = self
        contentView.addSubview(songCollectionView)
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
    private func fetchAlbums() {
        loadingIndicator.startAnimating()
        SpotifyAuthenticationManager.shared.authenticate { [weak self] success in
            guard success else {
                DispatchQueue.main.async {
                    self?.loadingIndicator.stopAnimating()
                    self?.showError("Authentication failed")
                }
                return
            }
            SpotifyAPIManager.shared.fetchRecentlyPublishedAlbums { albums in
                DispatchQueue.main.async {
                    self?.loadingIndicator.stopAnimating()
                    if let albums = albums {
                        self?.albums = albums
                        self?.albumCollectionView.reloadData()
                    } else {
                        self?.showError("Failed to fetch albums")
                    }
                }
            }
        }
    }
    
    // MARK: FetchTopSongs (5 best songs on this week)
    private func fetchTopSongs() {
        loadingIndicator.startAnimating()
        SpotifyAuthenticationManager.shared.authenticate { [weak self] success in
            guard success else {
                DispatchQueue.main.async {
                    self?.loadingIndicator.stopAnimating()
                    self?.showError("Authentication failed")
                }
                return
            }
            
            SpotifyAPIManager.shared.fetchWeeklyTopSongs { [weak self] songs in
                DispatchQueue.main.async {
                    
                    self?.loadingIndicator.stopAnimating()
                    if let songs = songs {
                        self?.topWeeklySongs = Array(songs.prefix(5))
                        print("Fetched \(songs.count) songs") // Debug print
                        self?.songCollectionView.reloadData()
                    } else {
                        self?.showError("Failed to fetch top songs")
                    }
                }
            }
        }
    }
    
    // MARK: FetchRecommendedSongs (you may also like)
    private func fetchRecommendedSongs() {
        fetchSelectedArtists { [weak self] artistNames in
            guard let artistNames = artistNames, !artistNames.isEmpty else {
                self?.showError("No artists selected")
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
    
    // MARK: NavigateToFavorites
    @objc private func navigateToFavorites() {
        favoritesView.modalPresentationStyle = .fullScreen
        self.present(favoritesView, animated: true)
    }

    // MARK: NavigateToMoodJournal
    @objc private func navigateToMoodJournal() {
        moodJournal.modalPresentationStyle = .fullScreen
        self.present(moodJournal, animated: true)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == albumCollectionView {
            return albums.count
        } else if collectionView == songCollectionView {
            return topWeeklySongs.count
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
        // SONG COLLECTION VIEW
        } else if collectionView == songCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongCardCell", for: indexPath) as! SongCardCollectionViewCell
            let song = topWeeklySongs[indexPath.item]
            cell.configure(with: song)
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
            
        } else if collectionView == songCollectionView {
            let selectedSong = topWeeklySongs[indexPath.item]
            if let url = URL(string: selectedSong.spotifyUrl) {
                let safariView = SFSafariViewController(url: url)
                present(safariView, animated: true, completion: nil)
            }
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
