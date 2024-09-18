//
//  GeneratedPlaylistsViewController.swift
//  MoodScape
//
//  Created by Olga Batiunia on 18.09.24.
//

import UIKit
import Gifu

class GeneratedPlaylistsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var playlists: [Playlist] = []
    private var collectionView: UICollectionView!
    
    // MARK: - Properties
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
        topLabel.text = "Recently"
        topLabel.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        topLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        topLabel.textAlignment = .left
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        return topLabel
    }()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        loadPlaylists()
    }
    
    // MARK: - SetupView
    private func setupView() {
        view.addSubview(gifBackground)
        view.sendSubviewToBack(gifBackground)
        view.addSubview(gifGradient)
        
        view.addSubview(topLabel)
        setupCollectionView()
    }
    
    // MARK: SetupConstraints
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
            
            topLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            collectionView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: -25),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            collectionView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    // MARK: - SetupCollectionView
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GeneratedPlaylistCell.self, forCellWithReuseIdentifier: "GeneratedPlaylistCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    private func loadPlaylists() {
        playlists = PlaylistStorage().fetchPlaylists()
        collectionView.reloadData()
    }
    
    // MARK: UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GeneratedPlaylistCell", for: indexPath) as! GeneratedPlaylistCell
        let playlist = playlists[indexPath.item]
        cell.configure(with: playlist)
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
}
