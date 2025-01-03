//
//  StartSetupViewController.swift
//  MoodScape
//
//  Created by Olga Batiunia on 23.08.24.
//

import UIKit
import Gifu

class StartSetupView: SetupBaseView {

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.startTypingAnimation(label: self?.messageLabel ?? UILabel(), text: "We are so happy that you joined us!", typingSpeed: 0.04) {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self?.startErasingAnimation(label: self?.messageLabel ?? UILabel(), typingSpeed: 0.02) {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                            self?.messageLabel.text = ""
                            self?.startTypingAnimation(label: self?.messageLabel ?? UILabel(), text: "Now we would like to know you better :) Please, configure your profile", typingSpeed: 0.04) {
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    self?.startErasingAnimation(label: self?.messageLabel ?? UILabel(), typingSpeed: 0.02) {
                                        self?.transitionToNextView()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // - MARK: SetupView
    private func setupView() {
        view.addSubview(messageLabel)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
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
