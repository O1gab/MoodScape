//
//  NewPlaylistView.swift
//  MoodScape
//
//  Created by Olga Batiunia on 16.09.24.
//

import UIKit

class NewPlaylistView: UIView {
    
    private let imageView = UIImageView()

    // Confetti animation view
    //private let confettiView = ConfettiView()

    
    private let openSpotifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to Spotify", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .black.withAlphaComponent(0.8)
        
        addSubview(imageView)
        addSubview(openSpotifyButton)
        //addSubview(confettiView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //confettiView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            
            openSpotifyButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            openSpotifyButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            openSpotifyButton.widthAnchor.constraint(equalToConstant: 200),
            openSpotifyButton.heightAnchor.constraint(equalToConstant: 50)
            /*
            confettiView.topAnchor.constraint(equalTo: topAnchor),
            confettiView.leadingAnchor.constraint(equalTo: leadingAnchor),
            confettiView.trailingAnchor.constraint(equalTo: trailingAnchor),
            confettiView.bottomAnchor.constraint(equalTo: bottomAnchor),
             */
        ])
        
        openSpotifyButton.addTarget(self, action: #selector(openSpotifyTapped), for: .touchUpInside)
    }

        @objc private func openSpotifyTapped() {
            // TODO: implement this
        }

        // Configure with playlist image
    func configure(with imageURL: String) {
        if let url = URL(string: imageURL) {
            imageView.loadImage(from: url)
        }
        //confettiView.startConfettiAnimation()
    }
}

    // Helper method for loading image from URL
extension UIImageView {
    func loadImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
