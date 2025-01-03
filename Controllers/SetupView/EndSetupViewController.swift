//
//  EndSetupViewController.swift
//  MoodScape
//
//  Created by Olga Batiunia on 25.08.24.
//

import UIKit
import Gifu
import FirebaseAuth
import FirebaseFirestore

class EndSetupView: SetupBaseView {
    
    private let gifGradient: GIFImageView = {
        let gifBackground = GIFImageView()
        gifBackground.animate(withGIFNamed: "green_gradient")
        gifBackground.contentMode = .scaleAspectFill
        gifBackground.alpha = 0.5
        gifBackground.translatesAutoresizingMaskIntoConstraints = false
        return gifBackground
    }()
    
    private let fieldLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // - MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.startTypingAnimation(label: self?.fieldLabel ?? UILabel(), text: "Thank you for configuring your profile! Now we are configuring the app for you.", typingSpeed: 0.04) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self?.startErasingAnimation(label: self?.fieldLabel ?? UILabel(), typingSpeed: 0.02) {
                        self?.updateData()
                        self?.navigateToNextView(viewController: MainTabBarController())
                    }
                }
            }
        }
    }
  
    // - MARK: SetupView
    private func setupView() {
        view.addSubview(gifGradient)
        view.addSubview(fieldLabel)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gifGradient.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifGradient.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifGradient.topAnchor.constraint(equalTo: view.topAnchor),
            gifGradient.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            fieldLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
            fieldLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            fieldLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            fieldLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    // - MARK: UpdateData
    private func updateData() {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).updateData(["firstUsage": false]) { error in
            if let error = error {
                print("Error updating firstUsage: \(error.localizedDescription)")
            } else {
                print("firstUsage updated successfully.")
            }
        }
    }
}
