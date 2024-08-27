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

    private var scrollView: UIScrollView!
    private var contentView: UIView!
    
    private var albumCollectionView: UICollectionView!
    private var albums: [Album] = []
    
    private var songCollectionView: UICollectionView!
    private var topWeeklySongs: [Song] = []
    
    private var recommendedSongsCollectionView: UICollectionView!
    private var recommendedSongs: [Song] = []
    
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
        button.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let infoMessage: UILabel = {
        let message = UILabel()
        message.text = "These recommendations are based on your listening history and preferences."
        message.textColor = .white
        message.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        message.textAlignment = .right
        message.backgroundColor = UIColor(white: 0, alpha: 0.7)
        message.layer.cornerRadius = 5
        message.clipsToBounds = true
        message.isHidden = true
        return message
    }()
    
    private let exploreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Explore more", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 28
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        fetchAlbums()
        fetchTopSongs()
    }
    
    // - MARK: SetupView
    private func setupView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        view.addSubview(profileButton)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.addSubview(topLabel)
        contentView.addSubview(topSongsLabel)
        contentView.addSubview(loadingIndicator)
        contentView.addSubview(recommendationsLabel)
        contentView.addSubview(infoButton)
        contentView.addSubview(infoMessage)
        
        
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .allTouchEvents)
        //contentView.addSubview(exploreButton)
        setupAlbumCollectionView()
        setupSongCollectionView()
        
        setupRecommendedSongsCollectionView()
        fetchSelectedArtists { [weak self] artists in
            SpotifyAuthenticationManager.shared.authenticate { [weak self] success in
                SpotifyAPIManager.shared.fetchRecommendedSongs(for: artists ?? [""]) { songs in
                    DispatchQueue.main.async {
                        if let songs = songs {
                            self?.recommendedSongs = songs
                            self?.recommendedSongsCollectionView.reloadData()
                            print("Recommended songs count: \(self?.recommendedSongs.count)")
                        } else {
                            self?.showError("Failed to fetch recommended songs")
                        }
                    }
                }
            }
        }
    }
    
    // - MARK: SetupAlbumCollectionView
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
    
    // - MARK: SetupSongCollectionView (Top songs this week)
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
    
    // - MARK: SetupRecommendedSongsCollectionView (You may also like)
    private func setupRecommendedSongsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            
        recommendedSongsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        recommendedSongsCollectionView.backgroundColor = .blue
        recommendedSongsCollectionView.showsVerticalScrollIndicator = false
        recommendedSongsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        recommendedSongsCollectionView.register(SongCardCollectionViewCell.self, forCellWithReuseIdentifier: "SongCardCell")
        recommendedSongsCollectionView.dataSource = self
        recommendedSongsCollectionView.delegate = self
        contentView.addSubview(recommendedSongsCollectionView)
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
            
            topLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            topLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            albumCollectionView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: -25),
            albumCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            albumCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            albumCollectionView.heightAnchor.constraint(equalToConstant: 300),
            
            topSongsLabel.topAnchor.constraint(equalTo: albumCollectionView.bottomAnchor, constant: -25),
            topSongsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            songCollectionView.topAnchor.constraint(equalTo: topSongsLabel.bottomAnchor, constant: 5),
            songCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            songCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            songCollectionView.heightAnchor.constraint(equalToConstant: 450),
            
            recommendationsLabel.topAnchor.constraint(equalTo: songCollectionView.bottomAnchor, constant: 30),
            recommendationsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            infoButton.leadingAnchor.constraint(equalTo: recommendationsLabel.trailingAnchor, constant: 15),
            infoButton.centerYAnchor.constraint(equalTo: recommendationsLabel.centerYAnchor),
            infoButton.widthAnchor.constraint(equalToConstant: 20),
            infoButton.heightAnchor.constraint(equalToConstant: 20),
            
            recommendedSongsCollectionView.topAnchor.constraint(equalTo: recommendationsLabel.bottomAnchor, constant: 30),
                recommendedSongsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                recommendedSongsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                recommendedSongsCollectionView.heightAnchor.constraint(equalToConstant: 200),
                recommendedSongsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // - MARK: FetchAlbums (recently published popular albums)
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
    
    // - MARK: FetchTopSongs (5 best songs on this week)
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
            SpotifyAPIManager.shared.fetchWeeklyTopSongs { songs in
                DispatchQueue.main.async {
                    self?.loadingIndicator.stopAnimating()
                    if let songs = songs {
                        self?.topWeeklySongs = Array(songs.prefix(5))
                        self?.songCollectionView.reloadData()
                    } else {
                        self?.showError("Failed to fetch top songs")
                    }
                }
            }
        }
    }
    
    // - MARK: FetchSelectedArtists (selection of the user)
    private func fetchSelectedArtists(completion: @escaping ([String]?) -> Void) {
        let db = Firestore.firestore()
        let userId = Auth.auth().currentUser?.uid
        let userDocRef = db.collection("users").document(userId ?? "")
        
        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let artists = data?["selectedArtists"] as? [String]
                print("Selected artists: \(String(describing: artists))")
                completion(artists)
            } else {
                let alert = UIAlertController(title: "Your artists selection not found",
                                              message: "An error with database occured, please, contact us.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                completion(nil)
            }
        }
    }
    
    // - MARK: InfoButtonTapped
    @objc private func infoButtonTapped() {
        UIView.animate(withDuration: 0.3) {
            self.infoMessage.isHidden = !self.infoMessage.isHidden
        }
        
        if !infoMessage.isHidden {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                UIView.animate(withDuration: 0.3) {
                    self.infoMessage.isHidden = true
                }
            }
        }
    }

    // - MARK: ShowError
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // - MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == albumCollectionView {
            return albums.count
        } else if collectionView == songCollectionView {
            return topWeeklySongs.count
        } else if collectionView == recommendedSongsCollectionView {
            return recommendedSongs.count
        }
        return 0
    }
    
    // - MARK: CollectionView
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
        } else if collectionView == recommendedSongsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongCardCell", for: indexPath) as! SongCardCollectionViewCell
            let song = recommendedSongs[indexPath.item]
            cell.configure(with: song)
            return cell
        }
        return UICollectionViewCell()
    }
        
    // - MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == albumCollectionView {
            return CGSize(width: 110, height: 190)
        } else if collectionView == recommendedSongsCollectionView {
            return CGSize(width: collectionView.bounds.width - 20, height: 80)
        }
        return CGSize(width: collectionView.bounds.width - 20, height: 80)
    }
    
    // - MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == albumCollectionView {
            let selectedAlbum = albums[indexPath.item]
            let detailVC = AlbumDetailsViewController(album: selectedAlbum)
            present(detailVC, animated: true, completion: nil)
            
        } else if collectionView == songCollectionView {
            let selectedSong = topWeeklySongs[indexPath.item]
            if let url = URL(string: selectedSong.spotifyUrl) {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        }
    }
}
