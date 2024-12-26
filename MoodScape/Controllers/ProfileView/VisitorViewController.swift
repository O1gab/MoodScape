//
//  VisitorViewController.swift
//  MoodScape
//
//  Created by Olga Batiunia on 26.12.24.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class VisitorViewController: ProfileBaseView {
    
    // MARK: - Properties
    private let userId: String
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let gradientCircleView: GradientCircleView = {
        let view = GradientCircleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 75
        // Set default system person image with proper configuration
        let config = UIImage.SymbolConfiguration(pointSize: 150, weight: .regular)
        imageView.image = UIImage(systemName: "person.circle.fill", withConfiguration: config)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1.0)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var fetchRetryCount = 0
    private let maxRetries = 3
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Init
    init(userId: String) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
        setupView()
        setupConstraints()
        fetchData()
        //fetchArtists()
        
        stopLoading()
    }
    
    // MARK: - SetupView
    private func setupView() {
        view.addSubview(scrollView)
        view.addSubview(loadingIndicator)
        view.addSubview(backButton)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(gradientCircleView)
        contentView.addSubview(profileImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(separatorLine)
    }
    
    // MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            profileImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 40),
            profileImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 150),
            profileImage.heightAnchor.constraint(equalToConstant: 150),
            
            gradientCircleView.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor),
            gradientCircleView.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            gradientCircleView.widthAnchor.constraint(equalToConstant: 225),
            gradientCircleView.heightAnchor.constraint(equalTo: gradientCircleView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: profileImage.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            usernameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            
            separatorLine.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            separatorLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            separatorLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            separatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    // MARK: - FetchData
    private func fetchData() {
        // TODO: FIX IT
        // fetch the data from the uid of selected user
    }
}
