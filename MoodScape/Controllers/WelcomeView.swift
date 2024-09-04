//
//  WelcomeView.swift
//  MoodScape
//
//  Created by Olga Batiunia on 28.08.24.
//

import UIKit
import Gifu

class WelcomeView: StartBaseView {

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let welcomeGradient: GIFImageView = {
        let gifBackground = GIFImageView()
        gifBackground.animate(withGIFNamed: "welcome_gradient")
        gifBackground.contentMode = .scaleAspectFill
        gifBackground.alpha = 0.5
        gifBackground.translatesAutoresizingMaskIntoConstraints = false
        return gifBackground
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
            self?.messageLabel.startTypingAnimation(label: self?.messageLabel ?? UILabel(), text: "We are so happy what you joined us!", typingSpeed: 0.05) {
            }
        }
    }
    
    // - MARK: SetupView
    private func setupView() {
        view.addSubview(welcomeGradient)
        view.addSubview(messageLabel)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            welcomeGradient.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            welcomeGradient.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            welcomeGradient.topAnchor.constraint(equalTo: view.topAnchor),
            welcomeGradient.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    // - MARK: TransitionToNextView
    private func transitionToNextView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let nextViewController = UserSetupView()
            nextViewController.modalPresentationStyle = .fullScreen
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = .push
            transition.subtype = .fromRight
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            self.view.window?.layer.add(transition, forKey: kCATransition)
            self.present(nextViewController, animated: false, completion: nil)
        }
    }
}
