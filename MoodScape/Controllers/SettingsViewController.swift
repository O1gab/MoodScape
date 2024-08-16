//
//  SettingsViewController.swift
//  MoodScape
//
//

import UIKit

class SettingsViewController: UIViewController {
    
    let backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setupForm()
        setupConstraints()
    }
    
    private func setupForm() {
        view.addSubview(backButton)
    }
    
    private func setupConstraints() {
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        ])
    }
    
    @objc private func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
}
