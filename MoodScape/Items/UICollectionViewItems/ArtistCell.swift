//
//  ArtistCell.swift
//  MoodScape
//
//  Created by Olga Batiunia on 25.08.24.
//

import UIKit

class ArtistCell: UICollectionViewCell {
    
    private let artistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
        
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // - MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    // - MARK: Init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // - MARK: SetupView
    private func setupView() {
        contentView.addSubview(artistImageView)
        contentView.addSubview(artistNameLabel)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            artistImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            artistImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            artistImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            artistImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
            artistNameLabel.topAnchor.constraint(equalTo: artistImageView.bottomAnchor, constant: 8),
            artistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    // - MARK: Configure
    func configure(with artist: Artist) {
        artistNameLabel.text = artist.name
        /*
        if let url = URL(string: artist.images.first?.url ?? "") {
            // Load image from URL
            // Example: use a library like SDWebImage to load the image asynchronously
            artistImageView.sd_setImage(with: url, completed: nil)
        }
         */
    }
}
