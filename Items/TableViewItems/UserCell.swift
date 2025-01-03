//
//  UserCell.swift
//  MoodScape
//
//  Created by Olga Batiunia on 26.12.24.
//

class UserCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "UserCell"
    
    static let cellHeight: CGFloat = 75
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    // MARK: Init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LayoutSizeFitting
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return CGSize(width: targetSize.width, height: UserCell.cellHeight)
    }
    
    // MARK: - SetupCell
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cardView)
        cardView.addSubview(usernameLabel)
        cardView.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            usernameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            usernameLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            addButton.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 60),
            addButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    // MARK: Configure
    func configure(with username: String) {
        usernameLabel.text = username
    }
}
