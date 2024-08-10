//
//  LoginViewController.swift
//  MoodScape
//
//

import UIKit

class LoginViewController: UIViewController {

    private let label = UILabel()
    private let registerButton = UIButton(type: .system)
    private let loginButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupLabel()
        setupButtons()
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

    private func setupButtons() {

        registerButton.setTitle("Sign up", for: .normal)
        registerButton.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 20) // Set larger font size
        
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
            // Position the label at the top center
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Position the register button below the label
            loginButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 210),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 250),
            loginButton.heightAnchor.constraint(equalToConstant: 55),

            // Position the login button below the register button
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.widthAnchor.constraint(equalToConstant: 250),
            registerButton.heightAnchor.constraint(equalToConstant: 55),
        ])
    }

    @objc private func handleRegister() {
        // Handle register action
        print("Register button tapped")
    }

    @objc private func handleLogin() {
        // Handle login action
        print("Login button tapped")
    }
}

