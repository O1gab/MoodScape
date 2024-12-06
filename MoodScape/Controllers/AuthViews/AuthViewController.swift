//
//  StartViewController.swift
//  MoodScape
//
//

import UIKit
import Gifu

class AuthViewController: StartBaseView {

    // MARK: - Properties
    private let introLabel: GradientLabel = {
        let label = GradientLabel()
        label.text = "Let your emotions set the playlist."
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.alpha = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.gradientColors = [UIColor.white, UIColor.gray, UIColor(red: 0/255.0, green: 104/255.0, blue: 80/255.0, alpha: 1.0)]

        return label
    }()
    
    private let instructions: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.alpha = 0.85
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let googleButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Continue with Google"
        configuration.image = UIImage(named: "google-icon")
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        
        configuration.imagePadding = 10
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -20, bottom: 0, trailing: 0)
        configuration.imagePlacement = .leading
        configuration.cornerStyle = .capsule
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            return outgoing
        }

        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let appleButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Continue with Apple"
        configuration.image = UIImage(named: "apple-icon")
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        
        configuration.imagePadding = 10
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -30, bottom: 0, trailing: 0)
        configuration.imagePlacement = .leading
        configuration.cornerStyle = .capsule
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            return outgoing
        }

        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up with Email", for: .normal)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 30
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        
        let fullText = "Already user? Log in"
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "Log in")
        
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: range)
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0), range: range)
        
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0), range: range)
        
        label.attributedText = attributedString
        label.isUserInteractionEnabled = true
        label.alpha = 0
        
        return label
    }()
    
    private lazy var registrationView: RegistrationViewController = {
        let viewController = RegistrationViewController()
        viewController.loadViewIfNeeded()
        return viewController
    }()
    
    private lazy var loginView: LoginViewController = {
        let viewController = LoginViewController()
        viewController.loadViewIfNeeded()
        return viewController
    }()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        appearingAnimation()
    }
    
    // MARK: SetupView
    private func setupView() {
        view.addSubview(introLabel)
        view.addSubview(instructions)
        
        view.addSubview(googleButton)
        view.addSubview(appleButton)
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        view.addSubview(registerButton)
        
        view.addSubview(loginLabel)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLogin))
        loginLabel.addGestureRecognizer(tapGesture)
    }

    // MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            introLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 110),
            introLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            introLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            instructions.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: 160),
            instructions.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            instructions.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            googleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 435),
            googleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleButton.widthAnchor.constraint(equalToConstant: 320),
            googleButton.heightAnchor.constraint(equalToConstant: 60),
            
            appleButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 20),
            appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleButton.widthAnchor.constraint(equalToConstant: 320),
            appleButton.heightAnchor.constraint(equalToConstant: 60),

            registerButton.topAnchor.constraint(equalTo: appleButton.bottomAnchor, constant: 20),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.widthAnchor.constraint(equalToConstant: 320),
            registerButton.heightAnchor.constraint(equalToConstant: 60),
            
            loginLabel.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 20),
            loginLabel.trailingAnchor.constraint(equalTo: registerButton.trailingAnchor, constant: -20)
        ])
    }

    // MARK: - HandleRegister
    @objc private func handleRegister() {
        registrationView.modalPresentationStyle = .fullScreen
        present(registrationView, animated: false)
    }

    // MARK: HandleLogin
    @objc private func handleLogin() {
        loginView.modalPresentationStyle = .fullScreen
        present(loginView, animated: false)
    }
    
    // MARK: - AppearingAnimation
    private func appearingAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            UIView.animate(withDuration: 1.5) {
                self?.introLabel.alpha = 1
            }
            UIView.animate(withDuration: 2.5) {
                self?.googleButton.alpha = 1
                self?.appleButton.alpha = 1
                self?.registerButton.alpha = 1
                self?.loginLabel.alpha = 1
            }
            
            self?.instructions.startTypingAnimation(label: self?.instructions ?? UILabel(), text: "Create an account to save your activity", typingSpeed: 0.05) {}
        }
    }
}
