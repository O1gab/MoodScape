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
    
    private let fieldLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.numberOfLines = 0
        label.alpha = 0.75
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let input: UITextField = {
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
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
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
        notificationMessage.font = UIFont.systemFont(ofSize: 18, weight: .bold)
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
        startText()
    }
    
    // - MARK: SetupForm
    private func setupForm() {
        view.addSubview(fieldLabel)
        
        setPlaceholder(textField: input, placeholder: "Enter your email or username", color: .systemGray)
        view.addSubview(input)
        
        setPlaceholder(textField: password, placeholder: "Enter your password", color: .systemGray)
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
        
            fieldLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            fieldLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            fieldLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            
            input.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            input.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            input.widthAnchor.constraint(equalToConstant: 320),
            input.heightAnchor.constraint(equalToConstant: 40),
            
            password.topAnchor.constraint(equalTo: input.bottomAnchor, constant: 20),
            password.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            password.widthAnchor.constraint(equalToConstant: 320),
            password.heightAnchor.constraint(equalToConstant: 40),
            
            loginButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 30),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 160),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            notificationMessage.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            notificationMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            notificationMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // - MARK: StartText
    private func startText() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.fieldLabel.startTypingAnimation(label: self?.fieldLabel ?? UILabel(), text: "Please enter your email or username and your password", typingSpeed: 0.05){}
        }
    }
    
    // - MARK: HandleLogin
    @objc private func handleLogin() {
        guard let email = input.text, !email.isEmpty else {
            showErrorMessage("Email or username field is empty")
            return
        }
        guard let password = password.text, !password.isEmpty else {
            showErrorMessage("Password field is empty")
            return
        }

        if email.contains("@") {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    self.showErrorMessage("Login failed: \(error.localizedDescription)")
                    return
                }
                
                guard let user = authResult?.user else {
                    self.showErrorMessage("Failed to get user information.")
                    return
                }
                self.handleSuccessfulLogin(for: user)
            }
            
        } else {
            let db = Firestore.firestore()
            db.collection("users").whereField("username", isEqualTo: input.text ?? "").getDocuments { (querySnapshot, error) in
            if let error = error {
                self.showErrorMessage("Error fetching user data: \(error.localizedDescription)")
                return
            }

            guard let document = querySnapshot?.documents.first else {
                self.showErrorMessage("Username not found.")
                return
            }

            Auth.auth().signIn(withEmail: document.data()["email"] as! String, password: password) { authResult, error in
                    if let error = error {
                        self.showErrorMessage("Login failed: \(error.localizedDescription)")
                        return
                    }

                    guard let user = authResult?.user else {
                        self.showErrorMessage("Failed to get user information.")
                        return
                    }

                    self.handleSuccessfulLogin(for: user)
                }
            }
        }
    }

    // - MARK: HandleSuccessfulLogin
    private func handleSuccessfulLogin(for user: FirebaseAuth.User) {
        if user.isEmailVerified {
            self.showSuccessMessage("Login successful")
            self.checkFirstUsage { isFirstUsage in
                if isFirstUsage {
                    let startSetup = StartSetupView()
                    startSetup.modalPresentationStyle = .fullScreen
                    self.present(startSetup, animated: true, completion: nil)
                } else {
                    let mainView = MainTabBarController()
                    mainView.modalPresentationStyle = .fullScreen
                    self.present(mainView, animated: true)
                }
            }
        } else {
            self.showErrorMessage("Please verify your email before logging in.")
            do {
                try Auth.auth().signOut()
            } catch {
                print("Failed to sign out user: \(error.localizedDescription)")
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
    
    // - MARK: CheckFirstUsage (fix it)
    func checkFirstUsage(completion: @escaping (Bool) -> Void) {
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
}
