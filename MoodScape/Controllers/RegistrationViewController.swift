//
//  RegistrationViewController.swift
//  MoodScape
//
//

import UIKit
import Gifu

class RegistrationViewController: UIViewController {
    
    private let label = UILabel()
    
    private let gifImageView = GIFImageView()
    
    private let email = UITextField()
    private let username = UITextField()
    private let password = UITextField()
    private let registerButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGIFBackground()
        setupLabel()
        setupForm()
        setupConstraints()
    }
    
    private func setupLabel() {
        label.text = "MoodScape"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
    }
    
    private func setupForm() {
        email.placeholder = "Email"
        email.borderStyle = .none
        email.backgroundColor = .black
        email.textColor = .white
        email.layer.borderColor = UIColor.white.cgColor
        email.layer.borderWidth = 1
        email.layer.cornerRadius = 18
        view.addSubview(email)
            
        username.placeholder = "Username"
        username.borderStyle = .none
        username.backgroundColor = .black
        username.textColor = .white
        username.layer.borderColor = UIColor.white.cgColor
        username.layer.borderWidth = 1
        username.layer.cornerRadius = 18
        view.addSubview(username)
            
        password.placeholder = "Password"
        password.isSecureTextEntry = true
        password.borderStyle = .none
        password.backgroundColor = .black
        password.textColor = .white
        password.layer.borderColor = UIColor.white.cgColor
        password.layer.borderWidth = 1
        password.layer.cornerRadius = 18
        view.addSubview(password)
            
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        registerButton.layer.cornerRadius = 18
        
        
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        view.addSubview(registerButton)
    }
    
    private func setupConstraints() {
            email.translatesAutoresizingMaskIntoConstraints = false
            username.translatesAutoresizingMaskIntoConstraints = false
            password.translatesAutoresizingMaskIntoConstraints = false
            registerButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                email.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40),
                email.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                email.widthAnchor.constraint(equalToConstant: 320), // width of "email" box
                email.heightAnchor.constraint(equalToConstant: 40), // height of "email" box
                
                username.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 20),
                username.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                username.widthAnchor.constraint(equalToConstant: 320),
                username.heightAnchor.constraint(equalToConstant: 40),
                
                password.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 20),
                password.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                password.widthAnchor.constraint(equalToConstant: 320),
                password.heightAnchor.constraint(equalToConstant: 40),
                
                registerButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 20),
                registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                registerButton.widthAnchor.constraint(equalToConstant: 160),
                registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupGIFBackground() {
        gifImageView.animate(withGIFNamed: "gradient_skyline_blinking_stars")
        gifImageView.contentMode = .scaleAspectFill
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gifImageView)
        view.sendSubviewToBack(gifImageView)

        // Set constraints for the GIFImageView to cover the entire view
        NSLayoutConstraint.activate([
            gifImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifImageView.topAnchor.constraint(equalTo: view.topAnchor),
            gifImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func handleRegister() {
        guard let email = email.text, !email.isEmpty,
              let username = username.text, username.count >= 4,
              let password = password.text, password.count >= 8 else {
            // Show validation error
            return
        }
        
        // Firebase integration needed
    }
    
    
}
