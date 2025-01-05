//
//  SimilarSongCell.swift
//  MoodScape
//
//  Created by Olga Batiunia on 05.01.25.
//


class SimilarSongCell: UICollectionViewCell {
    private let songLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
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
        contentView.addSubview(songLabel)
        
        NSLayoutConstraint.activate([
            songLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            songLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            songLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with song: Song) {
        songLabel.text = "\"\(song.name)\" by \(song.artist)"
    }
}
