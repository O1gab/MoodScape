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
        topLabel.text = "Your Mood Journal"
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
        
        view.addSubview(backButton)
        view.addSubview(topLabel)
        setupCollectionView()
        
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
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
            
            // Back button
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            // "Your Mood Journal"
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75),
            
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
    
    // MARK: HandleBack
    @objc private func handleBack() {
        dismiss(animated: true, completion: nil)
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
    
    // MARK: Open URL when a cell is tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.item]
        UIApplication.shared.open(playlist.spotifyURL, options: [:], completionHandler: nil)
    }
}
