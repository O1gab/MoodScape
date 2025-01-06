//
//  SpotifyLinkView.swift
//  MoodScape
//
//  Created by Olga Batiunia on 06.01.25.
//


import UIKit

class SpotifyLinkView: UIView {
    private let spotifyIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "spotify.logo")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let songLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        layer.cornerRadius = 10
        
        addSubview(spotifyIcon)
        addSubview(songLabel)
        
        NSLayoutConstraint.activate([
            spotifyIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            spotifyIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            spotifyIcon.widthAnchor.constraint(equalToConstant: 24),
            spotifyIcon.heightAnchor.constraint(equalToConstant: 24),
            
            songLabel.leadingAnchor.constraint(equalTo: spotifyIcon.trailingAnchor, constant: 10),
            songLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            songLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with songInfo: String) {
        songLabel.text = songInfo
    }
}
