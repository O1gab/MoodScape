//
//  EmotionCell.swift
//  MoodScape
//
//

import UIKit
import Gifu

class EmotionCell: UICollectionViewCell {
    
    let emotionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(emotionLabel)
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            emotionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                emotionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                emotionLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 10),
                emotionLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    func configure(with emotion: String) {
           emotionLabel.text = emotion
           updateAppearance()
       }
       
    private func updateAppearance() {
        if isSelected {
            contentView.backgroundColor = UIColor.green
            emotionLabel.textColor = UIColor.white
            contentView.layer.borderColor = UIColor.green.cgColor
        } else {
            contentView.backgroundColor = UIColor.clear
            emotionLabel.textColor = UIColor.gray
            contentView.layer.borderColor = UIColor.gray.cgColor
        }
    }
}
