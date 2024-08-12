//
//  RegistrationViewController.swift
//  MoodScape
//
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegistrationViewController: StartBaseView {
    
    private let email = UITextField()
    private let username = UITextField()
    private let password = UITextField()
    private let registerButton = UIButton(type: .system)
    private let backButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
        setupConstraints()
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
    }
    
    private func setupConstraints() {
            email.translatesAutoresizingMaskIntoConstraints = false
            username.translatesAutoresizingMaskIntoConstraints = false
            password.translatesAutoresizingMaskIntoConstraints = false
            registerButton.translatesAutoresizingMaskIntoConstraints = false
            backButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                
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
    
    @objc private func handleRegister() {
        guard let email = email.text, !email.isEmpty,
              let username = username.text, username.count >= 4,
              let password = password.text, password.count >= 8 else {
            // Show validation error
            return
        }
        
        // Firebase integration
        
        // Check if username is taken
        let ref = Database.database().reference()
        ref.child("usernames").child(username).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                // Username is taken
                
                return
            } else {
                // Create user in Firebase
                Auth.auth().createUser(withEmail: email, password: password) {
                    authResult, error in
                    guard let user = authResult?.user, error == nil else {
                        // Show error
                        return
                    }
                    
                    // Save the username
                    ref.child("usernames").child(username).setValue(user.uid)
                    
                    // Save the user data
                    let userData = ["email": email, "username": username]
                    ref.child("users").child(user.uid).setValue(userData)
                    
                    // Successfully registered
                }
            }
        }
    }
    
    @objc private func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    
}
