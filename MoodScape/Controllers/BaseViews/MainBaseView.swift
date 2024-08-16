//
//  MainBaseView.swift
//  MoodScape
//
//

import UIKit
import Gifu
import FirebaseAuth

class MainBaseView: UIViewController {
    
    private let gifImageView = GIFImageView()
    private let profileButton = UIButton(type: .custom)
    private let exitButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGIFBackground()
        setupProfileButton()
        setupConstraints()
    }
    
    private func setupGIFBackground() {
        gifImageView.animate(withGIFNamed: "gradient_skyline_blinking_stars")
        gifImageView.contentMode = .scaleAspectFill
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gifImageView)
        view.sendSubviewToBack(gifImageView)
    }
    
    private func setupProfileButton() {
        profileButton.frame = CGRect(x: self.view.frame.width - 60, y: 40, width: 40, height: 40)
        profileButton.layer.cornerRadius = 20
        profileButton.clipsToBounds = true
        profileButton.backgroundColor = .blue
        profileButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        view.addSubview(profileButton)
        
        exitButton.setImage(UIImage(systemName: "arrowshape.left.fill"), for: .normal)
        exitButton.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        exitButton.addTarget(self, action: #selector(exitTapped), for: .touchUpInside)
        view.addSubview(exitButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gifImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifImageView.topAnchor.constraint(equalTo: view.topAnchor),
            gifImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            profileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 210),
            profileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
        ])
    }
    
    @objc private func exitTapped() {
        do {
                    try Auth.auth().signOut()
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
    }
    
    @objc private func profileTapped() {
        let profileView = ProfileViewController()
        profileView.modalTransitionStyle = .flipHorizontal // delete maybe
        profileView.modalPresentationStyle = .fullScreen
        self.present(profileView, animated: true, completion: nil)
    }
}
