//
//  LoginViewController.swift
//  MoodScape
//
//

import UIKit
import Gifu

class LoginViewController: BaseView {

    private let registerButton = UIButton(type: .system)
    private let loginButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupConstraints()
    }
    
    private func setupButtons() {

        registerButton.setTitle("Sign up", for: .normal)
        registerButton.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        
        registerButton.layer.cornerRadius = 25
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        view.addSubview(registerButton)

        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 20) // Set larger font size
        
        loginButton.layer.cornerRadius = 25
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        view.addSubview(loginButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 210),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 250),
            loginButton.heightAnchor.constraint(equalToConstant: 55),

            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.widthAnchor.constraint(equalToConstant: 250),
            registerButton.heightAnchor.constraint(equalToConstant: 55),
        ])
    }

    @objc private func handleRegister() {
        // Handle register action
        let registrationVC = RegistrationViewController()
  
        registrationVC.modalPresentationStyle = .fullScreen
        present(registrationVC, animated: false, completion: nil)
    }

    @objc private func handleLogin() {
        // Handle login action
        print("Login button tapped")
    }
}

