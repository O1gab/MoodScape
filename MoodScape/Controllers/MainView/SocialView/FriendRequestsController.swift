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
        label.alpha = 0
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
    
    private let requestsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Your Friend Requests: 0", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .darkGray
        button.alpha = 0
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.layer.cornerRadius = 20
        button.addShadow()
        button.isUserInteractionEnabled = false // fix it maybe
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 2.0) {
            self.topLabel.alpha = 1
            self.requestsButton.alpha = 1
        }
    }
    
    private func setupView() {
        view.addSubview(topLabel)
        view.addSubview(backButton)
        view.addSubview(requestsButton)
        
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            // "Your Friend Requests"
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75),
            
            // Your Friend Requests: n
            requestsButton.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 10),
            requestsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            requestsButton.heightAnchor.constraint(equalToConstant: 40),
            requestsButton.widthAnchor.constraint(equalToConstant: 220),
        ])
    }
    
    // MARK: - fetchRequests
    private func fetchRequets() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)

        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            if let document = document, document.exists {
                let data = document.data()
                DispatchQueue.main.async {
                    // Update request count
                    if let receivedRequests = data?["received_requests"] as? [String] {
                        let requestCount = receivedRequests.count
                        self.requestsButton.setTitle("Your Friend Requests: \(requestCount)", for: .normal)
                        
                        
                        // TODO: create a table with friend requests
                    }
                }
            } else {
                print("Error occurred") // TODO: make an alarm
            }
        }
    }
    
    // MARK: HandleBack
    @objc private func handleBack() {
        dismiss(animated: true, completion: nil)
    }
}
