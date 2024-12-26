//
//  FriendRequestsController.swift
//  MoodScape
//
//  Created by Olga Batiunia on 26.12.24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FriendRequestsController: MainBaseView {
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Friend Requests"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .left
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.addSubview(topLabel)
        view.addSubview(backButton)
        
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            // "Your Friend Requests"
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75)
        ])
    }
    
    // MARK: HandleBack
    @objc private func handleBack() {
        dismiss(animated: true, completion: nil)
    }
}
