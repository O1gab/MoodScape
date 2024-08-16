//
//  FeedViewController.swift
//  MoodScape
//
//

import UIKit

class FeedViewController: MainBaseView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let topLabel = UILabel()
    private var collectionView: UICollectionView!
    private var albums: [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
        setupCollectionView()
        setupConstraints()
        fetchAlbums()
    }
    
    // - MARK: SetupForm
    private func setupForm() {
        topLabel.text = "Recently"
        topLabel.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        topLabel.font = UIFont.systemFont(ofSize: 37, weight: .bold)
        topLabel.textAlignment = .left
        view.addSubview(topLabel)
    }
    
    private func setupCollectionView() {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 10 // probably we dont need it
            layout.itemSize = CGSize(width: 80, height: 280) // probably we dont need it
            
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: "AlbumCell")
            collectionView.dataSource = self
            collectionView.delegate = self
            view.addSubview(collectionView)
        }
    
    private func setupConstraints() {
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 5),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3)
        ])
    }
    
    private func fetchAlbums() {
            SpotifyAuthenticationManager.shared.authenticate { [weak self] success in
                guard success else { return }
                SpotifyAPIManager.shared.fetchRecentlyPublishedAlbums { albums in
                    guard let albums = albums else { return }
                    DispatchQueue.main.async {
                        self?.albums = albums
                        self?.collectionView.reloadData()
                    }
                }
            }
        }
    
    
    // - MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    // - MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCollectionViewCell
            // Configure the cell with image (replace with actual image fetching)
        let album = albums[indexPath.item]
               
               // Fetch image data
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
        
    // - MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 110, height: 190) // Adjust size as needed
        
    }
    
}
