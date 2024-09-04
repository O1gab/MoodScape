//
//  FavoritesViewController.swift
//  MoodScape
//
//  Created by Olga Batiunia on 03.09.24.
//

import UIKit
import Gifu

class FavoritesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let gifBackground: GIFImageView = {
        let gifBackground = GIFImageView()
        gifBackground.animate(withGIFNamed: "gradient_skyline_blinking_stars")
        gifBackground.contentMode = .scaleAspectFill
        gifBackground.translatesAutoresizingMaskIntoConstraints = false
        return gifBackground
    }()
    
    private let gifGradient: GIFImageView = {
        let gifBackground = GIFImageView()
        gifBackground.animate(withGIFNamed: "green_gradient")
        gifBackground.contentMode = .scaleAspectFill
        gifBackground.alpha = 0.5
        gifBackground.translatesAutoresizingMaskIntoConstraints = false
        return gifBackground
    }()
    
    private let topLabel: UILabel = {
        let topLabel = UILabel()
        topLabel.text = "Favorites"
        topLabel.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        topLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        topLabel.textAlignment = .left
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        return topLabel
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let albumsLabel: UILabel = {
        let label = GradientLabel()
        label.text = "Albums"
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.gradientColors = [UIColor.white, UIColor.gray, UIColor(red: 0/255.0, green: 104/255.0, blue: 80/255.0, alpha: 1.0)]
        return label
    }()
    
    private let albumsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FavoritesCollectionViewCell.self, forCellWithReuseIdentifier: "AlbumCell")
        return collectionView
    }()
    
    private let songsLabel: UILabel = {
        let label = GradientLabel()
        label.text = "Songs"
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.gradientColors = [UIColor.white, UIColor.gray, UIColor(red: 0/255.0, green: 104/255.0, blue: 80/255.0, alpha: 1.0)]
        return label
    }()
    
    private let songsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FavoritesCollectionViewCell.self, forCellWithReuseIdentifier: "SongCell")
        return collectionView
    }()
    
    private let noAlbumsLabel: UILabel = {
        let label = UILabel()
        label.text = "No albums added to favorites"
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let noSongsLabel: UILabel = {
        let label = UILabel()
        label.text = "No songs added to favorites"
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var favoriteAlbums: [Album] = []
    private var favoriteSongs: [Song] = []
    private let favoritesManager = FavoritesManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(handleSongRemoved(_:)), name: .songRemoved, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavorites()
    }
    
    private func setupView() {
        view.addSubview(gifBackground)
        view.sendSubviewToBack(gifBackground)
        view.addSubview(gifGradient)
        view.addSubview(backButton)
        view.addSubview(topLabel)
        view.addSubview(albumsLabel)
        view.addSubview(albumsCollectionView)
        view.addSubview(songsLabel)
        view.addSubview(songsCollectionView)
        view.addSubview(noAlbumsLabel)
        view.addSubview(noSongsLabel)
        
        albumsCollectionView.dataSource = self
        albumsCollectionView.delegate = self
        songsCollectionView.dataSource = self
        songsCollectionView.delegate = self
        
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gifBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifBackground.topAnchor.constraint(equalTo: view.topAnchor),
            gifBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            gifGradient.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifGradient.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifGradient.topAnchor.constraint(equalTo: view.topAnchor),
            gifGradient.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            // "Favorites"
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            
            albumsLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 30),
            albumsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            albumsLabel.bottomAnchor.constraint(equalTo: albumsLabel.topAnchor, constant: 30),
            
            // Albums
            albumsCollectionView.topAnchor.constraint(equalTo: albumsLabel.bottomAnchor, constant: 10),
            albumsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            albumsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            albumsCollectionView.heightAnchor.constraint(equalToConstant: 220),
            
            songsLabel.topAnchor.constraint(equalTo: albumsCollectionView.bottomAnchor, constant: 30),
            songsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // Songs
            songsCollectionView.topAnchor.constraint(equalTo: songsLabel.bottomAnchor, constant: 10),
            songsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            songsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            songsCollectionView.heightAnchor.constraint(equalToConstant: 220),
            
            noAlbumsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noAlbumsLabel.centerYAnchor.constraint(equalTo: albumsCollectionView.centerYAnchor),
            
            // No songs label
            noSongsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noSongsLabel.centerYAnchor.constraint(equalTo: songsCollectionView.centerYAnchor)
        ])
    }
    
    // - MARK: FetchFavorites
    private func fetchFavorites() {
        favoriteAlbums = favoritesManager.getFavoriteAlbums()
        favoriteSongs = favoritesManager.getFavoriteSongs()
        
        print("Favorite Albums count: \(favoriteAlbums.count)") // DEBUG
        print("Favorite Songs count: \(favoriteSongs.count)") // DEBUG
        
        noAlbumsLabel.isHidden = !favoriteAlbums.isEmpty
        albumsCollectionView.isHidden = favoriteAlbums.isEmpty
        
        noSongsLabel.isHidden = !favoriteSongs.isEmpty
        songsCollectionView.isHidden = favoriteSongs.isEmpty
        
        albumsCollectionView.reloadData()
        songsCollectionView.reloadData()
    }
    
    // - MARK: HandleSongRemoved
    @objc private func handleSongRemoved(_ notification: Notification) {
        if let removedSong = notification.userInfo?["song"] as? Song {
            if let index = favoriteSongs.firstIndex(where: { $0.name == removedSong.name && $0.artist == removedSong.artist }) {
                favoriteSongs.remove(at: index)
            }
            
            songsCollectionView.reloadData()
        }
    }
    
    // - MARK: HandleBack
    @objc private func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == albumsCollectionView {
            return favoriteAlbums.count
        } else {
            return favoriteSongs.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionView == albumsCollectionView ? "AlbumCell" : "SongCell", for: indexPath) as! FavoritesCollectionViewCell
        
        if collectionView == albumsCollectionView {
            let album = favoriteAlbums[indexPath.item]
            cell.configure(with: album.imageUrl, title: album.name, subtitle: album.artist)
        } else {
            let song = favoriteSongs[indexPath.item]
            cell.configure(with: song.imageUrl ?? "", title: song.name, subtitle: song.artist)
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    
    // minimum interitem spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // minimum line spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // - MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == songsCollectionView) {
            let selectedSong = favoriteSongs[indexPath.item]
            let detailView = SongDetailsViewController(song: selectedSong)
            present(detailView, animated: true, completion: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension Notification.Name {
    static let songRemoved = Notification.Name("songRemoved")
    static let albumRemoved = Notification.Name("albumRemoved")
}

