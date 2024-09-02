//
//  SongCard.swift
//  MoodScape
//
//  Created by Olga Batiunia on 27.08.24.
//

import UIKit

class SongViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let songTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(songTitleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            artistNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            artistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            songTitleLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 5),
            songTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            songTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with song: Song) {
        imageView.image = nil // Optionally load image from URL here
        if let url = URL(string: song.imageUrl ?? "") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            task.resume()
        }
        artistNameLabel.text = song.artist
        songTitleLabel.text = song.name
    }
}
