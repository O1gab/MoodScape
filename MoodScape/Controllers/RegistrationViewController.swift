//
//  RegistrationViewController.swift
//  MoodScape
//
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegistrationViewController: StartBaseView, UITextFieldDelegate {
    private let email: UITextField = {
        let email = UITextField()
        email.borderStyle = .none
        email.backgroundColor = .black
        email.textColor = .white
        email.layer.borderColor = UIColor.white.cgColor
        email.layer.borderWidth = 1
        email.layer.cornerRadius = 18
        email.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        email.leftViewMode = .always
        email.autocapitalizationType = .none
        email.translatesAutoresizingMaskIntoConstraints = false
        return email
    }()
    
    private let username: UITextField = {
        let username = UITextField()
        username.borderStyle = .none
        username.backgroundColor = .black
        username.textColor = .white
        username.layer.borderColor = UIColor.white.cgColor
        username.layer.borderWidth = 1
        username.layer.cornerRadius = 18
        username.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        username.leftViewMode = .always
        username.autocapitalizationType = .none
        username.translatesAutoresizingMaskIntoConstraints = false
        return username
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
        password.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        password.leftViewMode = .always
        let rightViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        password.rightView = rightViewContainer
        password.rightViewMode = .always
        password.autocapitalizationType = .none
        password.translatesAutoresizingMaskIntoConstraints = false
        return password
    }()
    
    private let registerButton: UIButton = {
        let registerButton = UIButton(type: .system)
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        registerButton.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        registerButton.layer.cornerRadius = 18
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        return registerButton
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
        view.addSubview(email)
        email.delegate = self
        
        view.addSubview(username)
        username.delegate = self
            
        view.addSubview(password)
        
        setPlaceholder(textField: email, placeholder: "Enter your email", color: .systemGray)
        setPlaceholder(textField: username, placeholder: "Enter your username", color: .systemGray)
        setPlaceholder(textField: password, placeholder: "Enter your password", color: .systemGray)
            
        view.addSubview(registerButton)
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        view.addSubview(backButton)
        
        view.addSubview(notificationMessage)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            email.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100), // Adjusted for safe area
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
                
            notificationMessage.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 10),
            notificationMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            notificationMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
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
        
        if !emailCheck() || !passwordCheck() {
            return
        }
        
        // Check username asynchronously
        usernameCheck { valid in
            if valid {
                self.registerUser(email: email, password: password, username: username)
            }
        }
    }
    
    private func registerUser(email: String, password: String, username: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                self.showErrorMessage(error?.localizedDescription ?? "Failed to register")
                return
            }
            // Send email verification
            user.sendEmailVerification { error in
                if let error = error {
                    self.showErrorMessage("Failed to send verification email: \(error.localizedDescription)")
                    return
                }
                self.showSuccessMessage("Verification email sent. Please check your email.")
            }
            
            // Save username to the database
            let ref = Database.database().reference().child("users").child(user.uid)
            let userData: [String: Any] = [
                "email": email,
                "username": username,
                "firstUsage": true,
                "registrationDate": ServerValue.timestamp()
            ]
            ref.setValue(userData) { error, _ in
                if let error = error {
                    self.showErrorMessage("Failed to save user data: \(error.localizedDescription)")
                } else {
                    print("\(user.email!) created")
                }
            }
        }
    }
    
    // - MARK: HandleBack
    @objc private func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    // - MARK: EmailCheck
    private func emailCheck() -> Bool {
        guard let email = email.text, !email.isEmpty else {
            showErrorMessage("Email field is empty!")
            return false
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if !emailPredicate.evaluate(with: email) {
            showErrorMessage("The email address is badly formatted!")
            return false
        }
        return true
    }
    
    // - MARK: UsernameCheck
    private func usernameCheck(completion: @escaping (Bool) -> Void) {
        guard let username = username.text, !username.isEmpty else {
            showErrorMessage("Username field is empty!")
            completion(false)
            return
        }
        
        if username.count < 4 {
            showErrorMessage("Username must be at least 4 characters long")
            completion(false)
            return
        }
        
        let ref = Database.database().reference().child("usernames")
        ref.observeSingleEvent(of: .value) { snapshot in
            if snapshot.hasChild(username) {
                self.showErrorMessage("Username already taken!")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // - MARK: PasswordCheck
    private func passwordCheck() -> Bool {
        guard let password = password.text, !password.isEmpty else {
            showErrorMessage("Password field is empty!")
            return false
        }
        
        if password.count < 6 {
            showErrorMessage("Password must be at least 6 characters long")
            return false
        }
        return true
    }
    
    // - MARK: Error Handling
    private func showErrorMessage(_ message: String) {
        notificationMessage.text = message
        notificationMessage.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.notificationMessage.isHidden = true
        }
    }
    
    private func showSuccessMessage(_ message: String) {
        notificationMessage.textColor = .green
        notificationMessage.text = message
        notificationMessage.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.notificationMessage.isHidden = true
        }
    }
    
    private func setPlaceholder(textField: UITextField, placeholder: String, color: UIColor) {
        let placeholderAttributes = [
            NSAttributedString.Key.foregroundColor: color
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
    }
}
