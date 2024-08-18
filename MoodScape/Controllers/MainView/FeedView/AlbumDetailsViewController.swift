//
//  AlbumDetailsViewController.swift
//  MoodScape
//
//  Created by Olga Batiunia on 18.08.24.
//

import UIKit
import SafariServices
import CoreImage

class AlbumDetailsViewController: UIViewController {
    private var album: Album
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 37
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let albumName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .systemGreen
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private let topSongsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let spotifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Open in Spotify", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 28
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        configureWithAlbum()
    }
    
    // - MARK: SetupView
    private func setupView() {
        view.addSubview(contentView)
        contentView.addSubview(closeButton)
        contentView.addSubview(albumImageView)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(artistLabel)
        contentView.addSubview(albumName)
        contentView.addSubview(spotifyButton)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        closeButton.addTarget(self, action: #selector(closePopUp), for: .touchUpInside)
        spotifyButton.addTarget(self, action: #selector(openInSpotify), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 780),
            
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            albumImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 40),
            albumImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            albumImageView.widthAnchor.constraint(equalToConstant: 300),
            albumImageView.heightAnchor.constraint(equalToConstant: 300),
            
            artistLabel.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 10),
            artistLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            albumName.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 10),
            albumName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                        
            releaseDateLabel.topAnchor.constraint(equalTo: albumName.bottomAnchor, constant: 10),
            releaseDateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                        
            
            
            // topSongsLabel constraints
            /*
            topSongsLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 20),
            topSongsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            topSongsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                        */
            spotifyButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            spotifyButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            spotifyButton.widthAnchor.constraint(equalToConstant: 160),
            spotifyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // - MARK: ClosePopUp
    @objc func closePopUp() {
            animateHide()
        }
    
    // - MARK: AnimateShow
    func animateShow() {
           contentView.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
           UIView.animate(withDuration: 0.3, animations: {
               self.contentView.transform = .identity
           })
       }
    
    // - MARK: AnimateHide
    func animateHide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // - MARK: OpenInSpotify
    @objc private func openInSpotify() {
        if let url = URL(string: album.spotifyUrl) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    // - MARK: ConfigureWithAlbum
    private func configureWithAlbum() {
        if let url = URL(string: album.imageUrl) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.albumImageView.image = image
                    if let color = image.dominantColor() {
                        self.contentView.backgroundColor = color
                        self.artistLabel.textColor = color.contrastingColor()
                        self.albumName.textColor = color.contrastingComplementaryColor()
                    }
                }
            }
            task.resume()
        }
        releaseDateLabel.text = "Release Date: \(album.releaseDate)"
        artistLabel.text = "\(album.artist)"
        albumName.text = "\(album.name)"
    }
}
