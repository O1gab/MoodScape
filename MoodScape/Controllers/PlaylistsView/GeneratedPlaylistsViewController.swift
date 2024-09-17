//
//  GeneratedPlaylistsViewController.swift
//  MoodScape
//
//  Created by Olga Batiunia on 18.09.24.
//

import Foundation

class GeneratedPlaylistsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var playlists: [Playlist] = []
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadPlaylists()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 200)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GeneratedPlaylistCell.self, forCellWithReuseIdentifier: "GeneratedPlaylistCell")
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GeneratedPlaylistCell", for: indexPath) as! GeneratedPlaylistCell
        let playlist = playlists[indexPath.item]
        cell.configure(with: playlist)
        return cell
    }
}
