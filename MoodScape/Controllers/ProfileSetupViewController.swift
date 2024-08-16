//
//  ProfileSetupViewController.swift
//  MoodScape
//
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileSetupViewController: UIViewController {
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 37
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
        setupConstraints()
    }
    
    // - MARK: SetupForm
    private func setupForm() {
        view.backgroundColor = .black
        view.addSubview(saveButton)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        saveButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 120),
            saveButton.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    // - MARK: HandleSave
    @objc private func handleSave() {
        
    }
            
}



