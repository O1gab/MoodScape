//
//  LoginViewController.swift
//  MoodScape
//
//

import UIKit
import Gifu

class StartViewController: StartBaseView {

    private let introLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.alpha = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    private let guestButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue as guest", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.introLabel.startTypingAnimation(label: self?.introLabel ?? UILabel(), text: "Create an account to save your activity", typingSpeed: 0.05) {
                UIView.animate(withDuration: 2.0) {
                }
            }
        }
    }
    
    // - MARK: SetupView
    private func setupView() {
        view.addSubview(introLabel)
        
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        view.addSubview(registerButton)

        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        view.addSubview(loginButton)
        
        guestButton.addTarget(self, action: #selector(handleGuest), for: .touchUpInside)
        view.addSubview(guestButton)
    }

    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            introLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            introLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            introLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            loginButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 250),
            loginButton.heightAnchor.constraint(equalToConstant: 55),

            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.widthAnchor.constraint(equalToConstant: 250),
            registerButton.heightAnchor.constraint(equalToConstant: 55),
            
            guestButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 10),
            guestButton.centerXAnchor.constraint(equalTo: registerButton.centerXAnchor)
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
    
    // - MARK: HandleGuest
    @objc private func handleGuest() {
        let mainView = MainTabBarController()
        mainView.modalPresentationStyle = .fullScreen
        present(mainView, animated: true, completion: nil)
    }
}

