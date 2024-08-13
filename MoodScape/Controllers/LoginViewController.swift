//
//  LoginViewController.swift
//  MoodScape
//
//

import UIKit
import FirebaseAuth

class LoginViewController: StartBaseView {
    
    private let username = UITextField()
    private let password = UITextField()
    private let loginButton = UIButton(type: .system)
    private let backButton = UIButton(type: .custom)
    private let errorMessageLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
        setupConstraints()
    }
    
    // - MARK: SetupForm
    private func setupForm() {
        username.borderStyle = .none
        username.backgroundColor = .black
        username.textColor = .white
        username.layer.borderColor = UIColor.white.cgColor
        username.layer.borderWidth = 1
        username.layer.cornerRadius = 18
        view.addSubview(username)
        setPlaceholder(textField: username, placeholder: " Enter your username or email", color: .systemGray)
        
        password.isSecureTextEntry = true
        password.borderStyle = .none
        password.backgroundColor = .black
        password.textColor = .white
        password.layer.borderColor = UIColor.white.cgColor
        password.layer.borderWidth = 1
        password.layer.cornerRadius = 18
        view.addSubview(password)
        setPlaceholder(textField: password, placeholder: " Enter your password", color: .systemGray)
        
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        loginButton.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        loginButton.layer.cornerRadius = 18
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        view.addSubview(loginButton)
        
        backButton.setTitle("<-", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        view.addSubview(backButton)
        
        // Error labels
        errorMessageLabel.textColor = .red
        errorMessageLabel.font = UIFont.systemFont(ofSize: 14)
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.isHidden = true
        view.addSubview(errorMessageLabel)
    }
    
    private func setupConstraints() {
        username.translatesAutoresizingMaskIntoConstraints = false
        password.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
        
            username.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40),
            username.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            username.widthAnchor.constraint(equalToConstant: 320),
            username.heightAnchor.constraint(equalToConstant: 40),
            
            password.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 20),
            password.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            password.widthAnchor.constraint(equalToConstant: 320),
            password.heightAnchor.constraint(equalToConstant: 40),
            
            loginButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 160),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            errorMessageLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            errorMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorMessageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func handleLogin() {
        guard let username = username.text, !username.isEmpty else {
            showErrorMessage("Username field is empty")
            return
        }
        guard let password = password.text, !password.isEmpty else {
            showErrorMessage("Password field is empty")
            return
        }
        
        Auth.auth().signIn(withEmail: username, password: password) { authResult, error in
            if error != nil {
                self.showErrorMessage("User with this username and password not found!")
                return
            }
        }
    }
    
    @objc private func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessageLabel.text = message
        errorMessageLabel.isHidden = false
    }
    
    private func setPlaceholder(textField: UITextField, placeholder: String, color: UIColor) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
    }
    
}
