//
//  NewPlaylistView.swift
//  MoodScape
//
//  Created by Olga Batiunia on 16.09.24.
//

import UIKit

class NewPlaylistView: UIViewController {
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.9)
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let playlistDate: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()

    private let confettiView: ConfettiView = {
        let confettiView = ConfettiView()
        confettiView.translatesAutoresizingMaskIntoConstraints = false
        return confettiView
    }()

    private let openSpotifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Open on Spotify", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let spotifyLogo: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Spotify_Icon"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), for: .normal)
        button.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.animateShow()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.messageLabel.startTypingAnimation(label: self?.messageLabel ?? UILabel(), text: "Here's the playlist that reflects your current mood. Enjoy! :)", typingSpeed: 0.05) {
                self?.confettiView.alpha = 0
            }
        }
    }
    
    // MARK: - SetupView
    private func setupView() {
        view.addSubview(contentView)
        view.addSubview(confettiView)
        contentView.addSubview(closeButton)
        contentView.addSubview(messageLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(openSpotifyButton)
        contentView.addSubview(spotifyLogo)
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            contentView.widthAnchor.constraint(equalToConstant: 350),
            contentView.heightAnchor.constraint(equalToConstant: 550),
            
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            messageLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor, constant: 5),
            messageLabel.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: 10),
            messageLabel.widthAnchor.constraint(equalToConstant: 300),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 90),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 250),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            
            openSpotifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openSpotifyButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 100),
            openSpotifyButton.widthAnchor.constraint(equalToConstant: 200),
            openSpotifyButton.heightAnchor.constraint(equalToConstant: 55),
            
            spotifyLogo.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            spotifyLogo.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0),
            spotifyLogo.widthAnchor.constraint(equalToConstant: 50),
            spotifyLogo.heightAnchor.constraint(equalToConstant: 50),
            
            confettiView.topAnchor.constraint(equalTo: view.topAnchor),
            confettiView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confettiView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            confettiView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            confettiView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             
        ])
        closeButton.addTarget(self, action: #selector(closePopUp), for: .touchUpInside)
        openSpotifyButton.addTarget(self, action: #selector(openSpotifyTapped), for: .touchUpInside)
    }

        @objc private func openSpotifyTapped() {
            // TODO: implement this
        }

        // Configure with playlist image
    func configure(with color: UIColor, date: Date) {
        imageView.backgroundColor = color
        
        //confettiView.startConfettiAnimation()
    }
    
    // MARK: - ClosePopUp
    @objc private func closePopUp() {
        animateHide()
    }
    
    // MARK: - AnimateShow
    private func animateShow() {
        contentView.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        UIView.animate(withDuration: 0.7, animations: {
            self.contentView.transform = .identity
            self.confettiView.startConfettiAnimation()
        })
    }
    
    // MARK: AnimateHide
    private func animateHide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
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
