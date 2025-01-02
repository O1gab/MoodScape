//
//  ArtistCell.swift
//  MoodScape
//
//  Created by Olga Batiunia on 25.08.24.
//

import UIKit

class ArtistCell: UICollectionViewCell {
    
    // MARK: - Properties
    let artistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 37.5
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
        
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - SetupView
    private func setupView() {
        contentView.addSubview(artistImageView)
        contentView.addSubview(artistNameLabel)
        contentView.layer.cornerRadius = 37.5
    }
    
    // MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            artistImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            artistImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            artistImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            artistImageView.heightAnchor.constraint(equalTo: artistImageView.widthAnchor),
            
            artistNameLabel.topAnchor.constraint(equalTo: artistImageView.bottomAnchor, constant: 3),
            artistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    // MARK: - Configure
    func configure(with artist: Artist, isSelected: Bool) {
        artistNameLabel.text = artist.name
        contentView.backgroundColor = isSelected ? UIColor(red: 0/255, green: 104/255, blue: 80/255, alpha: 1.0) : UIColor.clear
    }
}
