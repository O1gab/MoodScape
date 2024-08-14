//
//  RegistrationViewController.swift
//  MoodScape
//
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegistrationViewController: StartBaseView, UITextFieldDelegate {
    
    private let email = UITextField()
    private let username = UITextField()
    private let password = UITextField()
    private let registerButton = UIButton(type: .system)
    private let backButton = UIButton(type: .custom)
    private let errorMessageLabel = UILabel()
    private let successMessageLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
        setupConstraints()
    }
    
    // - MARK: SetupForm
    private func setupForm() {
        email.borderStyle = .none
        email.backgroundColor = .black
        email.textColor = .white
        email.layer.borderColor = UIColor.white.cgColor
        email.layer.borderWidth = 1
        email.layer.cornerRadius = 18
        email.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: email.frame.height))
        email.leftViewMode = .always
        email.delegate = self
        view.addSubview(email)
        
        username.borderStyle = .none
        username.backgroundColor = .black
        username.textColor = .white
        username.layer.borderColor = UIColor.white.cgColor
        username.layer.borderWidth = 1
        username.layer.cornerRadius = 18
        username.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: username.frame.height))
        username.leftViewMode = .always
        username.delegate = self
        view.addSubview(username)
            
        password.isSecureTextEntry = true
        password.borderStyle = .none
        password.backgroundColor = .black
        password.textColor = .white
        password.layer.borderColor = UIColor.white.cgColor
        password.layer.borderWidth = 1
        password.layer.cornerRadius = 18
        password.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: password.frame.height))
        password.leftViewMode = .always
        view.addSubview(password)
        
        setPlaceholder(textField: email, placeholder: " Enter your email", color: .systemGray)
        setPlaceholder(textField: username, placeholder: " Enter your username", color: .systemGray)
        setPlaceholder(textField: password, placeholder: " Enter your password", color: .systemGray)
            
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        registerButton.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        registerButton.layer.cornerRadius = 18
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        view.addSubview(registerButton)
        
        backButton.setTitle("<-", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        view.addSubview(backButton)
        
        errorMessageLabel.textColor = .red
        errorMessageLabel.font = UIFont.systemFont(ofSize: 14)
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.isHidden = true
        view.addSubview(errorMessageLabel)
    }
    
    private func setupConstraints() {
            email.translatesAutoresizingMaskIntoConstraints = false
            username.translatesAutoresizingMaskIntoConstraints = false
            password.translatesAutoresizingMaskIntoConstraints = false
            registerButton.translatesAutoresizingMaskIntoConstraints = false
            backButton.translatesAutoresizingMaskIntoConstraints = false
            errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                
                email.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40),
                email.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                email.widthAnchor.constraint(equalToConstant: 320),
                email.heightAnchor.constraint(equalToConstant: 40),
                
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
                registerButton.heightAnchor.constraint(equalToConstant: 50),
                
                errorMessageLabel.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 10),
                errorMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                errorMessageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // - MARK: HANDLE REGISTER
    @objc private func handleRegister() {
        guard let email = email.text, !email.isEmpty,
              let username = username.text, !username.isEmpty,
              let password = password.text, !password.isEmpty else {
            showErrorMessage("Please fill in all fields")
            return
        }
        emailCheck()
        usernameCheck()
        passwordCheck()
        
        // - MARK: FIREBASE INTEGRATION
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    guard let user = authResult?.user, error == nil else {
                        self.showErrorMessage(error?.localizedDescription ?? "Failed to login")
                        return
                    }
                    
                    if user.isEmailVerified {
                        // Proceed to next screen or main app
                        print("User logged in: \(user.email!)")
                        self.showSuccessMessage("Login successful")
                    } else {
                        // Email not verified
                        self.showErrorMessage("Please verify your email before logging in.")
                        do {
                            try Auth.auth().signOut()
                        } catch {
                            print("Failed to sign out user: \(error.localizedDescription)")
                        }
                    }
                }
    }
            
    
    @objc private func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    private func emailCheck() {
        // TODO: Email must be valid and existing, not taken
    }
    
    private func usernameCheck() {
        // TODO: Username must be valid (at least, 4 letters) and not taken
    }
    
    private func passwordCheck() {
        // TODO: Password must be valid (min. 8 chars, containing letters and numbers)
    }

    
    private func showErrorMessage(_ message: String) {
        errorMessageLabel.text = message
        errorMessageLabel.textColor = .green
        errorMessageLabel.isHidden = false
    }
    
    private func showSuccessMessage(_ message: String) {
        errorMessageLabel.text = message
        errorMessageLabel.isHidden = false
    }
    
    // Helper function to set placeholder with custom color
    private func setPlaceholder(textField: UITextField, placeholder: String, color: UIColor) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
    }
    
    
}
