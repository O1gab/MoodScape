//
//  UserSetupViewController.swift
//  MoodScape
//
//  Created by Olga Batiunia on 23.08.24.
//

import UIKit
import Gifu

class UserSetupView: UIViewController {

    private let gradientLayer = CAGradientLayer()
    
    private let gifBackground: GIFImageView = {
        let gifBackground = GIFImageView()
        gifBackground.animate(withGIFNamed: "gradient_skyline_blinking_stars")
        gifBackground.contentMode = .scaleAspectFill
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
        let name = UITextField()
        name.backgroundColor = .none
        name.textColor = .white
        name.layer.borderColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 0.75).cgColor
        name.layer.borderWidth = 2
        name.layer.cornerRadius = 15
        name.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: name.frame.height))
        name.leftViewMode = .always
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        button.setTitleColor(UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 0.75), for: .normal)
        button.backgroundColor = .white.withAlphaComponent(0.5)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(UIColor(red: 179/255, green: 23/255, blue: 23/255, alpha: 1.0), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let typingSpeed: TimeInterval = 0.075
    private var timer: Timer?

    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor(red: 35/255.0, green: 35/255.0, blue: 35/255.0, alpha: 1.0)
        setupGradientBackground()
        animateGradient()
        setupView()
        setupConstraints()
    }
    
    // - MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.startTypingAnimation(label: self?.fieldLabel ?? UILabel(), text: "Enter your first name:", typingSpeed: self?.typingSpeed ?? 0.075) {
                // TODO:
            }
        }
    }
  
    // - MARK: SetupView
    private func setupView() {
        view.addSubview(gifBackground)
        view.sendSubviewToBack(gifBackground)
        
        view.addSubview(fieldLabel)
        view.addSubview(textField)
        view.addSubview(submitButton)
        view.addSubview(skipButton)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            fieldLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
            fieldLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            fieldLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            
            textField.topAnchor.constraint(equalTo: fieldLabel.bottomAnchor, constant: 20),
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
    
    // - MARK: StartTypingAnimation
    private func startTypingAnimation(label: UILabel, text: String, typingSpeed: TimeInterval, completion: @escaping () -> Void) {
        let fullText = text
        label.text = ""
        
        var index = 0
        timer = Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if index <= fullText.count {
                let endIndex = fullText.index(fullText.startIndex, offsetBy: index)
                label.text = String(fullText[..<endIndex])
                index += 1
            } else {
                timer.invalidate()
                completion()
            }
        }
    }
    
    // - MARK: StartErasingAnimation
    private func startErasingAnimation(label: UILabel, typingSpeed: TimeInterval, completion: @escaping () -> Void) {
        guard let text = label.text, !text.isEmpty else {
            completion()
            return
        }
        
        var index = text.count
        timer = Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if index > 0 {
                let endIndex = text.index(text.startIndex, offsetBy: index - 1)
                label.text = String(text[..<endIndex])
                index -= 1
            } else {
                timer.invalidate()
                completion()
            }
        }
    }
    
    // - MARK: SetupGradientBackground
    private func setupGradientBackground() {
        let baseColor = UIColor(red: 35/255.0, green: 35/255.0, blue: 35/255.0, alpha: 0.5).cgColor
        let darkColor = UIColor(red: 25/255.0, green: 25/255.0, blue: 25/255.0, alpha: 0.5).cgColor
        let lightColor = UIColor(red: 45/255.0, green: 45/255.0, blue: 45/255.0, alpha: 0.5).cgColor
        
        gradientLayer.colors = [darkColor, baseColor, lightColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // - MARK: AnimateGradient
    private func animateGradient() {
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = [UIColor(red: 70/255.0, green: 70/255.0, blue: 70/255.0, alpha: 0.35).cgColor,
                               UIColor(red: 45/255.0, green: 45/255.0, blue: 45/255.0, alpha: 0.5).cgColor,
                               UIColor(red: 45/255.0, green: 45/255.0, blue: 45/255.0, alpha: 0.5).cgColor]
        animation.toValue = [UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 0.5).cgColor,
                             UIColor(red: 25/255.0, green: 35/255.0, blue: 25/255.0, alpha: 0.5).cgColor,
                             UIColor(red: 0.0, green: 0.4, blue: 0.31, alpha: 1.0).cgColor]
        animation.duration = 7.0
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        gradientLayer.add(animation, forKey: "gradientAnimation")
    }
}

