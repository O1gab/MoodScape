//
//  FeedViewController.swift
//  MoodScape
//
//

import UIKit
import SafariServices

class FeedViewController: MainBaseView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /*
     TODO: Add previous searches history of the current user + maybe stats???
     */
    
    private var albumCollectionView: UICollectionView!
    private var albums: [Album] = []
    private var songCollectionView: UICollectionView!
    private var topWeeklySongs: [Song] = []
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
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
    
    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAlbumCollectionView()
        setupSongCollectionView()
        setupConstraints()
        
        fetchAlbums()
        fetchTopSongs()
    }
    
    // - MARK: SetupView
    private func setupView() {
        view.addSubview(topLabel)
        view.addSubview(topSongsLabel)
        view.addSubview(loadingIndicator)
        
        loadingIndicator.center = view.center
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
        view.addSubview(albumCollectionView)
    }
    
    // - MARK: SetupSongCollectionView
    private func setupSongCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            
        songCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        songCollectionView.backgroundColor = .clear
        songCollectionView.showsVerticalScrollIndicator = true
        songCollectionView.translatesAutoresizingMaskIntoConstraints = false
        songCollectionView.register(SongCardCollectionViewCell.self, forCellWithReuseIdentifier: "SongCardCell")
        songCollectionView.dataSource = self
        songCollectionView.delegate = self
        view.addSubview(songCollectionView)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            albumCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            albumCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            albumCollectionView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 5),
            albumCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3),
            
            topSongsLabel.topAnchor.constraint(equalTo: albumCollectionView.bottomAnchor),
            topSongsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            songCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            songCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            songCollectionView.topAnchor.constraint(equalTo: topSongsLabel.bottomAnchor, constant: 5),
            songCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // - MARK: FetchAlbums
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
    
    // - MARK: FetchTopSongs
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
                            self?.topWeeklySongs = Array(songs.prefix(5)) // Top 5 songs
                            self?.songCollectionView.reloadData()
                        } else {
                            self?.showError("Failed to fetch top songs")
                        }
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
        }
        return topWeeklySongs.count
    }
    
    // - MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
            }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongCardCell", for: indexPath) as! SongCardCollectionViewCell
        let song = topWeeklySongs[indexPath.item]
        cell.configure(with: song)
        return cell
    }
        
    // - MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == albumCollectionView {
            return CGSize(width: 110, height: 190)
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
