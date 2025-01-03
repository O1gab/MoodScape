//
//  SongCollectionView.swift
//  MoodScape
//
//  Created by Olga Batiunia on 20.08.24.
//

import UIKit
import SafariServices

class SongCardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.darkGray
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(artistLabel)
        contentView.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            artistLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            artistLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            playButton.widthAnchor.constraint(equalToConstant: 30),
            playButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: Initialization
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        contentView.backgroundColor = UIColor.darkGray
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(artistLabel)
        contentView.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            artistLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            artistLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            playButton.widthAnchor.constraint(equalToConstant: 30),
            playButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: - Configure
    func configure(with song: Song) {
        titleLabel.text = song.name
        artistLabel.text = song.artist
        playButton.addAction(UIAction { _ in
            if let url = URL(string: song.spotifyUrl) {
                UIApplication.shared.open(url)
            }
        }, for: .touchUpInside)
    }
}
