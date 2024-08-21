//
//  ContactView.swift
//  MoodScape
//
//  Created by Olga Batiunia on 22.08.24.
//

import UIKit

class ContactViewController: ProfileBaseView {
    
    private let contactLabel: UILabel = {
        let settingsLabel = UILabel()
        settingsLabel.text = "Contact"
        settingsLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        settingsLabel.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        settingsLabel.textAlignment = .center
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        return settingsLabel
    }()
    
    private let label: UILabel = {
        let settingsLabel = UILabel()
        settingsLabel.text = "MoodScape"
        settingsLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        settingsLabel.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        settingsLabel.textAlignment = .center
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        return settingsLabel
    }()
    
    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // - MARK: SetupView
    private func setupView() {
        view.addSubview(contactLabel)
        view.addSubview(label)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contactLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            contactLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
