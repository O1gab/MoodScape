//
//  newLogin.swift
//  MoodScape
//
//  Created by Olga Batiunia on 31.08.24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class newLogin: StartBaseView {
    
    private let backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .white
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .none
        field.textColor = .white
        field.layer.borderColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 0.75).cgColor
        field.layer.borderWidth = 2
        field.layer.cornerRadius = 15
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: field.frame.height))
        field.leftViewMode = .always
        field.autocapitalizationType = .none
        field.alpha = 0
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .none
        field.textColor = .white
        field.layer.borderColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 0.75).cgColor
        field.layer.borderWidth = 2
        field.layer.cornerRadius = 15
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: field.frame.height))
        field.leftViewMode = .always
        field.autocapitalizationType = .none
        field.isSecureTextEntry = true
        field.alpha = 0
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        button.setTitleColor(UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 0.9), for: .normal)
        button.backgroundColor = .white.withAlphaComponent(0.5)
        button.layer.cornerRadius = 25
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let notificationMessage: UILabel = {
        let notificationMessage = UILabel()
        notificationMessage.textColor = .red
        notificationMessage.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        notificationMessage.numberOfLines = 0
        notificationMessage.textAlignment = .center
        notificationMessage.isHidden = true
        notificationMessage.translatesAutoresizingMaskIntoConstraints = false
        return notificationMessage
    }()

    private let eyeButton: UIButton = {
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        eyeButton.tintColor = .white
        eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        eyeButton.addTarget(newLogin.self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        eyeButton.alpha = 0
        return eyeButton
    }()
    
    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // - MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.usernameLabel.startTypingAnimation(label: self?.usernameLabel ?? UILabel(), text: "Enter your email or username here", typingSpeed: 0.05) {
                UIView.animate(withDuration: 2.0) {
                    self?.usernameField.alpha = 1.0
                }
                
                self?.passwordLabel.startTypingAnimation(label: self?.passwordLabel ?? UILabel(), text: "Enter your password here", typingSpeed: 0.05) {
                    UIView.animate(withDuration: 2.0) {
                        self?.passwordField.alpha = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                        UIView.animate(withDuration: 2.0) {
                            self?.loginButton.alpha = 1.0
                        }
                    }
                }
            }
        }
    }
    
    // - MARK: SetupView
    private func setupView() {
        view.addSubview(usernameLabel)
        view.addSubview(usernameField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordField)
        view.addSubview(eyeButton)
        view.addSubview(loginButton)
        view.addSubview(notificationMessage)
        view.addSubview(backButton)
        
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 220),
            usernameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            usernameLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            
            usernameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 260),
            usernameField.leftAnchor.constraint(equalTo: usernameLabel.leftAnchor),
            usernameField.widthAnchor.constraint(equalToConstant: 300),
            usernameField.heightAnchor.constraint(equalToConstant: 60),
            
            passwordLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 370),
            passwordLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15),
            
            passwordField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 15),
            passwordField.rightAnchor.constraint(equalTo: passwordLabel.rightAnchor),
            passwordField.widthAnchor.constraint(equalToConstant: 300),
            passwordField.heightAnchor.constraint(equalToConstant: 60),

            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 50),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 120),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            notificationMessage.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 40),
            notificationMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notificationMessage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            //notificationMessage.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    // - MARK: HandleSubmit
    @objc private func handleLogin() {
        // TODO: IMPLEMENT
        guard let username = usernameField.text, !username.isEmpty else {
            showErrorMessage("Username or email field cannot be empty")
            return
        }
        guard let password = passwordField.text, !password.isEmpty else {
            showErrorMessage("Password field cannot be empty")
            return
        }
        
        // LOGIN WITH EMAIL
        if ((usernameField.text?.contains("@")) != nil) {
            // Login with email
            Auth.auth().signIn(withEmail: username, password: password) { [weak self] authResult, error in
                guard let user = authResult?.user, error == nil else {
                    self?.showErrorMessage(error?.localizedDescription ?? "Failed to login")
                    return
                }
                if user.isEmailVerified {
                    print("User logged in: \(user.email!)")
                    self?.showSuccessMessage("Login successful")
                    
                    self?.checkFirstUsage { isFirstUsage in
                        print("is first usage: \(isFirstUsage)")
                        if isFirstUsage {
                            DispatchQueue.main.async {
                            let startSetup = StartSetupView()
                            startSetup.modalPresentationStyle = .fullScreen
                            self?.present(startSetup, animated: true, completion: nil)
                            }
                        } else {
                            DispatchQueue.main.async {
                                let mainView = MainTabBarController()
                                mainView.modalPresentationStyle = .fullScreen
                                self?.present(mainView, animated: true, completion: nil)
                            }
                        }
                    }
                } else {
                    self?.showErrorMessage("Please verify your email before logging in.")
                    do {
                        try Auth.auth().signOut()
                    } catch {
                        print("Failed to sign out user: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        // LOGIN WITH USERNAME
        
    }
                    
    // - MARK: CheckFirstUsage
    private func checkFirstUsage(completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User is not logged in.")
            completion(false)
            return
        }
        
        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(userId)
        
        userDocRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                completion(false)
            } else if let document = document, document.exists {
                if let firstUsage = document.data()?["firstUsage"] as? Bool {
                    completion(firstUsage)
                } else {
                    completion(false)
                }
            } else {
                print("Document does not exist")
                completion(false)
            }
        }
    }
    
    // - MARK: ShowErrorMessage
    private func showErrorMessage(_ message: String) {
        notificationMessage.text = message
        notificationMessage.isHidden = false
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            self?.notificationMessage.startErasingAnimation(label: self?.notificationMessage ?? UILabel(), typingSpeed: 0.05) {}
        }
    }
    
    // - MARK: ShowSuccessMessage -> DELETE LATER!
    private func showSuccessMessage(_ message: String) {
        notificationMessage.text = message
        notificationMessage.textColor = .green
        notificationMessage.isHidden = false
    }
    
    // - MARK: TogglePasswordVisibility
    @objc func togglePasswordVisibility() {
        passwordField.isSecureTextEntry.toggle()
        let imageName = passwordField.isSecureTextEntry ? "eye.slash" : "eye"
        passwordField.eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    // - MARK: HandleBack
    @objc private func handleBack() {
        dismiss(animated: true, completion: nil)
    }
}
