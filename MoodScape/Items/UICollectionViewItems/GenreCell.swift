//
//  GenreCell.swift
//  MoodScape
//
//  Created by Olga Batiunia on 24.08.24.
//

import UIKit

class GenreCell: UICollectionViewCell {
    
    static let identifier = "GenreCell"
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(genreLabel)
        contentView.backgroundColor = .gray
        contentView.layer.cornerRadius = 15
        
        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            genreLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with genre: String, isSelected: Bool) {
        genreLabel.text = genre
        contentView.backgroundColor = isSelected ? UIColor(red: 0/255, green: 104/255, blue: 80/255, alpha: 1.0) : UIColor.gray
    }
}
