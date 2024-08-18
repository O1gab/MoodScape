//
//  SettingsViewController.swift
//  MoodScape
//
//

import UIKit

class SettingsViewController: ProfileBaseView {
    
    let settingsLabel: UILabel = {
        let settingsLabel = UILabel()
        settingsLabel.text = "Settings"
        settingsLabel.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        settingsLabel.textAlignment = .center
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        return settingsLabel
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
        setupConstraints()
    }
    
    private func setupForm() {
        view.addSubview(settingsLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            settingsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

}
