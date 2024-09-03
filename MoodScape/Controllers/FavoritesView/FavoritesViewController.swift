//
//  FavoritesViewController.swift
//  MoodScape
//
//  Created by Olga Batiunia on 03.09.24.
//

import UIKit

class FavoritesViewController: MainBaseView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    
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
        let topLabel = UILabel()
        topLabel.text = "Albums"
        topLabel.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        topLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        topLabel.textAlignment = .left
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        return topLabel
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
        let topLabel = UILabel()
        topLabel.text = "Songs"
        topLabel.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        topLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        topLabel.textAlignment = .left
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        return topLabel
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
    
    private var favoriteAlbums: [Album] = []
    private var favoriteSongs: [Song] = []
    private let favoritesManager = FavoritesManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        fetchFavorites()
    }
    
    private func setupView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        view.addSubview(backButton)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.addSubview(topLabel)
        
        contentView.addSubview(albumsLabel)
        contentView.addSubview(albumsCollectionView)
        contentView.addSubview(songsLabel)
        contentView.addSubview(songsCollectionView)
        
        albumsCollectionView.dataSource = self
        albumsCollectionView.delegate = self
        songsCollectionView.dataSource = self
        songsCollectionView.delegate = self
        
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }
    
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
            
            // "Favorites"
            topLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            topLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            topLabel.heightAnchor.constraint(equalToConstant: 32),
            
            albumsLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 20),
            albumsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            // Albums
            albumsCollectionView.topAnchor.constraint(equalTo: albumsLabel.bottomAnchor, constant: 20),
            albumsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            albumsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            albumsCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            songsLabel.topAnchor.constraint(equalTo: albumsCollectionView.bottomAnchor, constant: 30),
            songsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            // Songs
            songsCollectionView.topAnchor.constraint(equalTo: songsLabel.bottomAnchor, constant: 20),
            songsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            songsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            songsCollectionView.heightAnchor.constraint(equalToConstant: 200),
            songsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            // Back button
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        ])
    }
    
    // - MARK: FetchFavorites
    private func fetchFavorites() {
        favoriteAlbums = favoritesManager.getFavoriteAlbums()
        favoriteSongs = favoritesManager.getFavoriteSongs()
        
        print("Favorite Albums count: \(favoriteAlbums.count)") // Debugging statement
        print("Favorite Songs count: \(favoriteSongs.count)") // Debugging statement
    
        albumsCollectionView.reloadData()
        songsCollectionView.reloadData()
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
}

