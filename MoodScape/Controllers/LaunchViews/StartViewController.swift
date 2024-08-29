//
//  LoginViewController.swift
//  MoodScape
//
//

import UIKit
import Gifu

class StartViewController: StartBaseView {

    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // - MARK: SetupView
    private func setupView() {
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        view.addSubview(registerButton)

        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        view.addSubview(loginButton)
    }

    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: appLabel.bottomAnchor, constant: 210),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 250),
            loginButton.heightAnchor.constraint(equalToConstant: 55),

            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.widthAnchor.constraint(equalToConstant: 250),
            registerButton.heightAnchor.constraint(equalToConstant: 55),
        ])
    }

    // - MARK: HandleRegister
    @objc private func handleRegister() {
        let registrationView = RegistrationViewController()
        registrationView.modalPresentationStyle = .fullScreen
        present(registrationView, animated: true, completion: nil)
    }

    // - MARK: HandleLogin
    @objc private func handleLogin() {
        let loginView = LoginViewController()
        loginView.modalPresentationStyle = .fullScreen
        present(loginView, animated: true, completion: nil)
    }
}

