//
//  SettingsViewController.swift
//  MoodScape
//
//

import UIKit
import FirebaseAuth

class SettingsViewController: ProfileBaseView {
    
    private let settingsLabel: UILabel = {
        let settingsLabel = UILabel()
        settingsLabel.text = "Settings"
        settingsLabel.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        settingsLabel.textAlignment = .center
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        return settingsLabel
    }()
   
    private let exitButton: UIButton = {
        let exitButton = UIButton(type: .system)
        exitButton.setImage(UIImage(systemName: "arrowshape.left.fill"), for: .normal)
        exitButton.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        return exitButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.addSubview(settingsLabel)
        view.addSubview(exitButton)
        
        exitButton.addTarget(self, action: #selector(exitTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            settingsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            exitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            exitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // - MARK: ExitTapped
    @objc private func exitTapped() {
        do {
            try Auth.auth().signOut()
            let startView = StartViewController()
            startView.modalPresentationStyle = .fullScreen
            self.present(startView, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
