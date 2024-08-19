//
//  LoginViewController.swift
//  MoodScape
//
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class LoginViewController: StartBaseView {
    
    private let email: UITextField = {
        let email = UITextField()
        email.borderStyle = .none
        email.backgroundColor = .black
        email.textColor = .white
        email.layer.borderColor = UIColor.white.cgColor
        email.layer.borderWidth = 1
        email.layer.cornerRadius = 18
        email.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: email.frame.height))
        email.leftViewMode = .always
        email.autocapitalizationType = .none
        email.translatesAutoresizingMaskIntoConstraints = false
        return email
    }()
    
    private let password: UITextField = {
        let password = UITextField()
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
        password.translatesAutoresizingMaskIntoConstraints = false
        return password
    }()
    
    private let loginButton: UIButton = {
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        loginButton.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        loginButton.layer.cornerRadius = 18
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        return loginButton
    }()
    
    private let backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .white
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }()
    
    private let notificationMessage: UILabel = {
        let notificationMessage = UILabel()
        notificationMessage.textColor = .red
        notificationMessage.font = UIFont.systemFont(ofSize: 14)
        notificationMessage.numberOfLines = 0
        notificationMessage.textAlignment = .center
        notificationMessage.isHidden = true
        notificationMessage.translatesAutoresizingMaskIntoConstraints = false
        return notificationMessage
    }()
    
    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
        setupConstraints()
    }
    
    // - MARK: SetupForm
    private func setupForm() {
        setPlaceholder(textField: email, placeholder: " Enter your email", color: .systemGray)
        view.addSubview(email)
        
        setPlaceholder(textField: password, placeholder: " Enter your password", color: .systemGray)
        view.addSubview(password)
        
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        view.addSubview(loginButton)
        
        
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        view.addSubview(backButton)
        
        view.addSubview(notificationMessage)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        
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
    
    // - MARK: HandleLogin
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
            if let error = error {
                self.showErrorMessage("Login failed: \(error.localizedDescription)")
                return
            }
        
            guard let user = authResult?.user else {
                self.showErrorMessage("Failed to get user information.")
                return
            }
            
            if user.isEmailVerified {
                self.showSuccessMessage("Login successful")
                self.checkFirstUsage(for: user)
            }
            else {
                self.showErrorMessage("Please verify your email before logging in.")
                do {
                    try Auth.auth().signOut()
                } catch {
                    print("Failed to sign out user: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // - MARK: HandleBack
    @objc private func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    // - MARK: ShowErrorMessage
    private func showErrorMessage(_ message: String) {
        notificationMessage.text = message
        notificationMessage.isHidden = false
    }
    
    // - MARK: ShowSuccessMessage
    private func showSuccessMessage(_ message: String) {
        notificationMessage.text = message
        notificationMessage.textColor = .green
        notificationMessage.isHidden = false
    }
    
    // - MARK: SetPlaceholder
    private func setPlaceholder(textField: UITextField, placeholder: String, color: UIColor) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
    }
    
    // - MARK: CheckFirstUsage
    private func checkFirstUsage(for user: FirebaseAuth.User) {
        let ref = Database.database().reference().child("users").child(user.uid)
        ref.observeSingleEvent(of: .value) { snapshot in
            // Ensure we are on the main thread for UI updates
            DispatchQueue.main.async {
                guard let userData = snapshot.value as? [String: Any],
                      let firstUsage = userData["firstUsage"] as? Bool else {
                        self.showErrorMessage("Failed to retrieve user data or firstUsage field is missing")
                        return
                    }
                
                if firstUsage {
                    
                    let profileSetupVC = ProfileSetupViewController()
                    profileSetupVC.modalTransitionStyle = .crossDissolve
                    profileSetupVC.modalPresentationStyle = .fullScreen
                    self.present(profileSetupVC, animated: true, completion: nil)
                } else {
                    
                    let mainView = MainTabBarController()
                    mainView.modalTransitionStyle = .crossDissolve
                    mainView.modalPresentationStyle = .fullScreen
                    self.present(mainView, animated: true, completion: nil)
                }
            }
        } withCancel: { error in
            DispatchQueue.main.async {
                self.showErrorMessage("Failed to retrieve user data: \(error.localizedDescription)")
            }
        }
    }
}
