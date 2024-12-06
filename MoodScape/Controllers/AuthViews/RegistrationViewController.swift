//
//  RegistrationViewController.swift
//  MoodScape
//
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegistrationViewController: StartBaseView {
    
    private var currentQuestionIndex = 0
    private let questions = ["Enter your email:", "Enter your preferred username:", "Enter your password:"]
    private let firestoreKeys = ["email", "username", "password"]
    private var userData: [String: String] = [:]
    
    private let backButton: UIButton = {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .white
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }()
    
    private let fieldLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textField: UITextField = {
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
    
    private let submitButton: UIButton = {
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
        notificationMessage.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        notificationMessage.numberOfLines = 0
        notificationMessage.textAlignment = .left
        notificationMessage.lineBreakMode = .byWordWrapping
        notificationMessage.adjustsFontSizeToFitWidth = true
        notificationMessage.minimumScaleFactor = 0.5
        notificationMessage.isHidden = true
        notificationMessage.translatesAutoresizingMaskIntoConstraints = false
        return notificationMessage
    }()
    
    private let successMessage: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let eyeButton: UIButton = {
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        eyeButton.tintColor = .white
        eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        eyeButton.addTarget(RegistrationViewController.self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        eyeButton.alpha = 0
        return eyeButton
    }()
    
    private lazy var authView: AuthViewController = {
        let viewController = AuthViewController()
        viewController.loadViewIfNeeded()
        return viewController
    }()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.fieldLabel.startTypingAnimation(label: self?.fieldLabel ?? UILabel(), text: self?.questions[self?.currentQuestionIndex ?? 0] ?? "", typingSpeed: 0.04) {
                UIView.animate(withDuration: 2.0) {
                    self?.textField.alpha = 1.0
                    self?.submitButton.alpha = 1.0
                }
            }
        }
    }
    
    // MARK: SetupView
    private func setupView() {
        view.addSubview(fieldLabel)
        view.addSubview(textField)
        view.addSubview(eyeButton)
        view.addSubview(submitButton)
        view.addSubview(notificationMessage)
        view.addSubview(successMessage)
        view.addSubview(backButton)
        
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            
            fieldLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
            fieldLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            fieldLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 290),
            textField.leadingAnchor.constraint(equalTo: fieldLabel.leadingAnchor),
            textField.widthAnchor.constraint(equalToConstant: 300),
            textField.heightAnchor.constraint(equalToConstant: 60),

            submitButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30),
            submitButton.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 10),
            submitButton.widthAnchor.constraint(equalToConstant: 150),
            submitButton.heightAnchor.constraint(equalToConstant: 60),
            
            notificationMessage.topAnchor.constraint(equalTo: submitButton.topAnchor),
            notificationMessage.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
            notificationMessage.leadingAnchor.constraint(equalTo: submitButton.trailingAnchor, constant: 5),
            notificationMessage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            notificationMessage.heightAnchor.constraint(equalToConstant: 350),
            
            successMessage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 230),
            successMessage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            successMessage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 15),
            successMessage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    // - MARK: HandleSubmit
    @objc private func handleSubmit() {
        guard let answer = textField.text, !answer.isEmpty else {
            showErrorMessage("The field cannot be empty")
            return
        }
        
        if currentQuestionIndex == 0 {
            if emailCheck() {
                saveData(data: textField.text ?? "")
                currentQuestionIndex+=1
                proceedToNextQuestion()
            }
            return
        }
        else if currentQuestionIndex == 1 {
            if usernameCheck() {
                saveData(data: textField.text ?? "")
                currentQuestionIndex+=1
                proceedToNextQuestion()
            }
            return
        }
        else if currentQuestionIndex == 2 {
            if passwordCheck() {
                saveData(data: textField.text ?? "")
                currentQuestionIndex+=1
                proceedToNextQuestion()
            }
            showErrorMessage("Invalid password format. Password must contain letters and numbers and be at least 8 characters long.")
            return
        }
        proceedToNextQuestion()
    }
    
    // - MARK: EmailCheck
    private func emailCheck() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        let emailText = textField.text

        if !emailPredicate.evaluate(with: emailText) {
            showErrorMessage("The email address is badly formatted!")
            return false
        }
        // TODO: check if the email is already taken
        return true
    }
    
    // - MARK: UsernameCheck
    private func usernameCheck() -> Bool {
        let usernameText = textField.text
        // minimum 4 chars
        if usernameText?.count ?? 0 < 4 {
            showErrorMessage("Username must be at least 4 characters long")
            return false
        }
        
        if usernameText?.count ?? 0 > 20 {
            showErrorMessage("Username must be max. 20 characters long")
        }
       
        // only alphanumeric and underscores are allowed.
        let usernameRegEx = "^[A-Za-z0-9_.]{4,20}$"
        let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegEx)
        
        if !usernamePredicate.evaluate(with: usernameText) {
            showErrorMessage("Username contains forbidden characters")
            return false
        }
        
        // cannot contain the forbidden characters
        let forbiddenChars = CharacterSet(charactersIn: "!@#$%^&*()+=[]{}|\\:;\"'<>,?/~` ")
        if usernameText?.rangeOfCharacter(from: forbiddenChars) != nil {
            showErrorMessage("Username contains forbidden characters")
            return false
        }
        
        // TODO: CHECK IF THE USERNAME IS ALREADY TAKEN
        return true
    }
    
    // - MARK: PasswordCheck
    private func passwordCheck() -> Bool {
        // letters and numeric Values, minimum 8 characters
        let password = textField.text
        
        if password?.count ?? 0 < 8 {
            showErrorMessage("Password must contain at least 8 characters")
            return false
        }
        
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPredicate.evaluate(with: password)
    }
    
    // - MARK: SaveUserData
    private func saveData(data: String) {
        let firestoreKey = firestoreKeys[currentQuestionIndex]
        userData[firestoreKey] = data
    }
    
    // - MARK: ProceedToNextQuestion
    private func proceedToNextQuestion() {
        self.fieldLabel.startErasingAnimation(label: fieldLabel, typingSpeed: 0.02) { [weak self] in
            self?.textField.text = ""
            
            if self?.currentQuestionIndex == 2 {
                self?.textField.isSecureTextEntry = true
                let rightViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                rightViewContainer.addSubview((self?.textField.eyeButton)!)
                self?.textField.rightView = rightViewContainer
                self?.textField.rightViewMode = .always
                self?.textField.eyeButton.addTarget(self, action: #selector(self?.togglePasswordVisibility), for: .touchUpInside)
            }
            if self?.currentQuestionIndex ?? 0 < self?.questions.count ?? 0 {
                let nextQuestion = self?.questions[self?.currentQuestionIndex ?? 0] ?? ""
                self?.fieldLabel.startTypingAnimation(label: self?.fieldLabel ?? UILabel(), text: nextQuestion, typingSpeed: 0.04) {}
            } else {
                self?.handleRegistration()
            }
        }
    }
    
    // - MARK: HandleRegistrationCompletion
    private func handleRegistration() {
        guard let email = userData["email"], let username = userData["username"], let password = userData["password"] else {
            showErrorMessage("Registration data is incomplete.")
            return
        }
        
        registerUser(email: email, username: username, password: password) { [weak self] error in
            if let error = error {
                self?.showErrorMessage("Registration failed: \(error.localizedDescription)")
            } else {
                self?.showSuccessMessage("Verification email sent. Please check your email.")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self?.dismiss(animated: true)
                }
            }
        }
    }
    
    // - MARK: RegisterUser
       private func registerUser(email: String, username: String, password: String, completion: @escaping (Error?) -> Void) {
        // Step 1: Create the user with Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                completion(error)
                return
            }
            
            // Step 2: Send email verification
            user.sendEmailVerification { error in
                if let error = error {
                    completion(error)
                    self.currentQuestionIndex = 0
                    self.proceedToNextQuestion()
                    return
                }
                self.notificationMessage.text = ""
                self.showSuccessMessage("Verification email sent. Please check your email.")
            }
            
            // Step 3: Save user data to Firestore
            self.saveUserData(userId: user.uid, username: username, email: email) { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                    print("User's data successfully saved")
                }
            }
        }
    }
    
    // - MARK: SaveUserData
    private func saveUserData(userId: String, username: String, email: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        
        let userData: [String: Any] = [
            "email": email,
            "username": username,
            "registrationDate": Timestamp(date: Date()),
            "firstUsage": true
        ]
        
        db.collection("users").document(userId).setData(userData) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    // - MARK: ShowErrorMessage
    private func showErrorMessage(_ message: String) {
        notificationMessage.text = message
        notificationMessage.textColor = .red
        notificationMessage.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            self?.notificationMessage.startErasingAnimation(label: self?.notificationMessage ?? UILabel(), typingSpeed: 0.05) {}
        }
    }
    
    // - MARK: ShowSuccessMessage
    private func showSuccessMessage(_ message: String) {
        successMessage.startTypingAnimation(label: successMessage, text: message, typingSpeed: 0.04) {}
    }
    
    // - MARK: TogglePasswordVisibility
    @objc func togglePasswordVisibility() {
        textField.isSecureTextEntry.toggle()
        let imageName = textField.isSecureTextEntry ? "eye.slash" : "eye"
        textField.eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    // - MARK: HandleBack
    @objc private func handleBack() {
        dismiss(animated: true, completion: nil)
    }
}
