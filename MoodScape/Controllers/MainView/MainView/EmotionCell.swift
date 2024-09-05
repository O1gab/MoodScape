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
        label.textColor = .white
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
    
    func configure(with emotion: String, isSelected: Bool) {
        emotionLabel.text = emotion
        contentView.backgroundColor = isSelected ? UIColor(red: 0/255, green: 104/255, blue: 80/255, alpha: 1.0) : UIColor.gray
        contentView.layer.borderColor = isSelected ? UIColor(red: 0/255, green: 104/255, blue: 80/255, alpha: 1.0).cgColor : UIColor.gray.cgColor
    }
}
