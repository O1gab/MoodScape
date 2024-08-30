//
//  UserSetupViewController.swift
//  MoodScape
//
//  Created by Olga Batiunia on 23.08.24.
//

import UIKit
import Gifu
import Firebase
import FirebaseAuth
import FirebaseFirestore

class UserSetupView: SetupBaseView {

    private var currentQuestionIndex = 0
    private let questions = ["Enter your name:", "Enter your location:"]
    private let firestoreKeys = ["name", "location"]
    private var userData: [String: String] = [:]
    
    private let gifGradient: GIFImageView = {
        let gifBackground = GIFImageView()
        gifBackground.animate(withGIFNamed: "green_gradient")
        gifBackground.contentMode = .scaleAspectFill
        gifBackground.alpha = 0.5
        gifBackground.translatesAutoresizingMaskIntoConstraints = false
        return gifBackground
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
        field.alpha = 0
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let submitButton: UIButton = {
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
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(UIColor(red: 181/255, green: 23/255, blue: 23/255, alpha: 1.0), for: .normal)
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
            self?.startTypingAnimation(label: self?.fieldLabel ?? UILabel(), text: self?.questions[self?.currentQuestionIndex ?? 0] ?? "", typingSpeed: 0.05) {
                    DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
                        UIView.animate(withDuration: 2.0) {
                            self?.textField.alpha = 1.0
                            self?.submitButton.alpha = 1.0
                    }
                }
            }
        }
    }
  
    // - MARK: SetupView
    private func setupView() {
        view.addSubview(gifGradient)
        view.addSubview(fieldLabel)
        view.addSubview(textField)
        view.addSubview(submitButton)
        view.addSubview(skipButton)
        
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gifGradient.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifGradient.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifGradient.topAnchor.constraint(equalTo: view.topAnchor),
            gifGradient.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            fieldLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
            fieldLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            fieldLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 280),
            textField.leftAnchor.constraint(equalTo: fieldLabel.leftAnchor),
            textField.widthAnchor.constraint(equalToConstant: 300),
            textField.heightAnchor.constraint(equalToConstant: 60),
            
            skipButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30),
            skipButton.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            skipButton.widthAnchor.constraint(equalToConstant: 120),
            skipButton.heightAnchor.constraint(equalToConstant: 50),
            
            submitButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30),
            submitButton.leadingAnchor.constraint(equalTo: skipButton.trailingAnchor, constant: 45),
            submitButton.widthAnchor.constraint(equalToConstant: 120),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // - MARK: HandleSubmit
    @objc private func handleSubmit() {
        guard let answer = textField.text, !answer.isEmpty else {
            let errorAlert = UIAlertController(title: "Oops!", message: "The field is empty. Please fill it in.", preferredStyle: .alert)
            errorAlert.view.tintColor = UIColor(red: 0/255, green: 215/255, blue: 96/255, alpha: 1.0)
            
            if let titleLabel = errorAlert.view.subviews.first?.subviews.first?.subviews.first as? UILabel {
                titleLabel.textColor = .white
            }
            
            if let messageLabel = errorAlert.view.subviews.first?.subviews.first?.subviews.last as? UILabel {
                messageLabel.textColor = .lightGray
            }
            
            errorAlert.view.subviews.first?.subviews.first?.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1.0)
            
            let okAction = UIAlertAction(title: "Got it", style: .default, handler: nil)
            errorAlert.addAction(okAction)
            
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        let firestoreKey = firestoreKeys[currentQuestionIndex]
        userData[firestoreKey] = answer

        let db = Firestore.firestore()
        db.collection("users").document(userId).setData(userData, merge: true) { error in
            if let error = error {
                print("Error saving data: \(error)")
            } else {
                print("Data successfully saved!")
            }
        }

        proceedToNextQuestion()
    }
    
    // - MARK: HandleSkip
    @objc private func handleSkip() {
        proceedToNextQuestion()
    }

    // - MARK: ProceedToNextQuestion
    private func proceedToNextQuestion() {
        startErasingAnimation(label: fieldLabel, typingSpeed: 0.045) { [weak self] in
            self?.textField.text = ""
            self?.currentQuestionIndex += 1
            
            if (self?.currentQuestionIndex == 1) {
                DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
                    UIView.animate(withDuration: 2.0) {
                        self?.skipButton.alpha = 1.0
                    }
                }
            }
            
            if self?.currentQuestionIndex ?? 0 < self?.questions.count ?? 0 {
                let nextQuestion = self?.questions[self?.currentQuestionIndex ?? 0] ?? ""
                self?.startTypingAnimation(label: self?.fieldLabel ?? UILabel(), text: nextQuestion, typingSpeed: 0.05) {}
            } else {
                self?.navigateToNextView(viewController: ImageSetupView())
            }
        }
    }
}

