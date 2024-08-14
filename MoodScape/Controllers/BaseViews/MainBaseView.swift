//
//  MainBaseView.swift
//  MoodScape
//
//  Created by Olga Batiunia on 14.08.24.
//

import UIKit
import Gifu

class MainBaseView: UIViewController {
    
    let gifImageView = GIFImageView()
    let profileButton = UIButton(type: .custom)
    
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
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gifImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifImageView.topAnchor.constraint(equalTo: view.topAnchor),
            gifImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            profileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 210),
            profileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
        ])
    }
    
    @objc private func profileTapped() {
        let profileView = MainViewController()
        profileView.modalTransitionStyle = .crossDissolve
        profileView.modalPresentationStyle = .fullScreen
        self.present(profileView, animated: true, completion: nil)
    }
}
