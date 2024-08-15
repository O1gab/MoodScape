//
//  LoginViewController.swift
//  MoodScape
//
//

import UIKit
import FirebaseAuth

class LoginViewController: StartBaseView {
    
    private let email = UITextField()
    private let password = UITextField()
    private let loginButton = UIButton(type: .system)
    private let backButton = UIButton(type: .custom)
    private let notificationMessage = UILabel()
    
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
        email.autocapitalizationType = .none
        view.addSubview(email)
        setPlaceholder(textField: email, placeholder: " Enter your email", color: .systemGray)
        
        password.isSecureTextEntry = true
        password.borderStyle = .none
        password.backgroundColor = .black
        password.textColor = .white
        password.layer.borderColor = UIColor.white.cgColor
        password.layer.borderWidth = 1
        password.layer.cornerRadius = 18
        password.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: password.frame.height))
        password.leftViewMode = .always
        let rightViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightViewContainer.addSubview(password.eyeButton)
        password.rightView = rightViewContainer
        password.rightViewMode = .always
        password.autocapitalizationType = .none
        view.addSubview(password)
        setPlaceholder(textField: password, placeholder: " Enter your password", color: .systemGray)
        
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        loginButton.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        loginButton.layer.cornerRadius = 18
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        view.addSubview(loginButton)
        
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .white
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        view.addSubview(backButton)
        
        notificationMessage.textColor = .red
        notificationMessage.font = UIFont.systemFont(ofSize: 14)
        notificationMessage.numberOfLines = 0
        notificationMessage.textAlignment = .center
        notificationMessage.isHidden = true
        view.addSubview(notificationMessage)
    }
    
    private func setupConstraints() {
        email.translatesAutoresizingMaskIntoConstraints = false
        password.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        notificationMessage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
        
            email.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40),
            email.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            email.widthAnchor.constraint(equalToConstant: 320),
            email.heightAnchor.constraint(equalToConstant: 40),
            
            password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 20),
            password.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            password.widthAnchor.constraint(equalToConstant: 320),
            password.heightAnchor.constraint(equalToConstant: 40),
            
            loginButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 160),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            notificationMessage.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            notificationMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            notificationMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func handleLogin() {
        guard let email = email.text, !email.isEmpty else {
            showErrorMessage("Email field is empty")
            return
        }
        guard let password = password.text, !password.isEmpty else {
            showErrorMessage("Password field is empty")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                self.showErrorMessage(error?.localizedDescription ?? "Failed to login")
                return
            }
            if user.isEmailVerified {
                
                
                print("User logged in: \(user.email!)")
                self.showSuccessMessage("Login successful")
                        
                let mainView = MainTabBarController()
                mainView.modalTransitionStyle = .crossDissolve
                mainView.modalPresentationStyle = .fullScreen
                self.present(mainView, animated: true, completion: nil)
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
    
    private func showErrorMessage(_ message: String) {
        notificationMessage.text = message
        notificationMessage.isHidden = false
    }
    
    private func showSuccessMessage(_ message: String) {
        notificationMessage.text = message
        notificationMessage.textColor = .green
        notificationMessage.isHidden = false
    }
    
    private func setPlaceholder(textField: UITextField, placeholder: String, color: UIColor) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
    }
}
