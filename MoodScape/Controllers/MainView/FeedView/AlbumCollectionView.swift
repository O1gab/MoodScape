//
//  AlbumCollectionView.swift
//  MoodScape
//
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // - MARK: SetupView
    private func setupView() {
        contentView.addSubview(imageView)
        contentView.layer.borderColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0).cgColor
        contentView.layer.borderWidth = 2
        contentView.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with image: UIImage?) {
        imageView.image = image
    }
}
