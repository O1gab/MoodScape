//
//  newLogin.swift
//  MoodScape
//
//  Created by Olga Batiunia on 31.08.24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: StartBaseView {
    
    // MARK: - Properties
    private let backButton: UIButton = {
        let backButton = UIButton(type: .system)
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
        let rightViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        field.alpha = 0
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let eyeButton: UIButton = {
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        eyeButton.tintColor = .white
        eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        eyeButton.addTarget(LoginViewController.self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        eyeButton.alpha = 0
        return eyeButton
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 30
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
    
    private lazy var startSetup: StartSetupView = {
        let viewController = StartSetupView()
        viewController.loadViewIfNeeded()
        return viewController
    }()
    
    private lazy var mainView: MainTabBarController = {
        let viewController = MainTabBarController()
        viewController.loadViewIfNeeded()
        return viewController
    }()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    // MARK: Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.usernameLabel.startTypingAnimation(label: self?.usernameLabel ?? UILabel(), text: "Enter your email here", typingSpeed: 0.04) {
                UIView.animate(withDuration: 2.0) {
                    self?.usernameField.alpha = 1.0
                }
                
                self?.passwordLabel.startTypingAnimation(label: self?.passwordLabel ?? UILabel(), text: "Enter your password here", typingSpeed: 0.04) {
                    UIView.animate(withDuration: 2.0) {
                        self?.passwordField.alpha = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                        UIView.animate(withDuration: 2.0) {
                            self?.loginButton.alpha = 1.0
                        }
                    }
                }
            }
        }
    }
    
    // MARK: SetupView
    private func setupView() {
        view.addSubview(usernameLabel)
        view.addSubview(usernameField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordField)
        view.addSubview(eyeButton)
        view.addSubview(loginButton)
        view.addSubview(notificationMessage)
        view.addSubview(backButton)
        
        let rightViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightViewContainer.addSubview(passwordField.eyeButton)
        passwordField.rightView = rightViewContainer
        passwordField.rightViewMode = .always
        passwordField.eyeButton.addTarget(self, action: #selector(self.togglePasswordVisibility), for: .touchUpInside)
        
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }
    
    // MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 220),
            usernameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            usernameField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20),
            usernameField.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            usernameField.widthAnchor.constraint(equalToConstant: 300),
            usernameField.heightAnchor.constraint(equalToConstant: 60),
            
            passwordLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 370),
            passwordLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            passwordField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: passwordLabel.trailingAnchor),
            passwordField.widthAnchor.constraint(equalToConstant: 300),
            passwordField.heightAnchor.constraint(equalToConstant: 60),

            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 50),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 150),
            loginButton.heightAnchor.constraint(equalToConstant: 60),
            
            notificationMessage.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 40),
            notificationMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notificationMessage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            //notificationMessage.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    // MARK: - HandleSubmit
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
            Auth.auth().signIn(withEmail: username, password: password) { [weak self] authResult, error in
                guard let user = authResult?.user, error == nil else {
                    self?.showErrorMessage("Wrong password or email")
                    return
                }
                if user.isEmailVerified {
                    print("User logged in: \(user.email!)")
                    self?.showSuccessMessage("Login successful")
                    
                    self?.checkFirstUsage { isFirstUsage in
                        print("is first usage: \(isFirstUsage)")
                        if isFirstUsage {
                            DispatchQueue.main.async {
                                guard let startSetup = self?.startSetup else { return }
                                startSetup.modalPresentationStyle = .fullScreen
                                self?.present(startSetup, animated: true)
                            }
                        } else {
                            DispatchQueue.main.async {
                                guard let mainView = self?.mainView else { return }
                                mainView.modalPresentationStyle = .fullScreen
                                self?.present(mainView, animated: true)
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
    }
                    
    // MARK: - CheckFirstUsage
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
    
    // MARK: - ShowErrorMessage
    private func showErrorMessage(_ message: String) {
        notificationMessage.text = message
        notificationMessage.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            self?.notificationMessage.startErasingAnimation(label: self?.notificationMessage ?? UILabel(), typingSpeed: 0.05) {}
        }
    }
    
    // MARK: ShowSuccessMessage -> DELETE LATER!
    private func showSuccessMessage(_ message: String) {
        notificationMessage.text = message
        notificationMessage.textColor = .green
        notificationMessage.isHidden = false
    }
    
    // MARK: - TogglePasswordVisibility
    @objc func togglePasswordVisibility() {
        passwordField.isSecureTextEntry.toggle()
        let imageName = passwordField.isSecureTextEntry ? "eye.slash" : "eye"
        passwordField.eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    // MARK: HandleBack
    @objc private func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - KeyboardWillShow
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 150
            }
        }
    }

    // MARK: KeyboardWillHide
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // MARK: DismissKeyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
