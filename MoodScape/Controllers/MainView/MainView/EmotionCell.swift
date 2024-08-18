//
//  EmotionCell.swift
//  MoodScape
//
//

import UIKit

class EmotionCell: UICollectionViewCell {
    
    let emotionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(emotionLabel)
        contentView.layer.cornerRadius = contentView.frame.width / 2
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            emotionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emotionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with emotion: String) {
        emotionLabel.text = emotion
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .green : .clear
        }
    }
}
