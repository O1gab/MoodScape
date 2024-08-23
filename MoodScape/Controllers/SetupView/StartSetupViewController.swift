//
//  StartSetupViewController.swift
//  MoodScape
//
//  Created by Olga Batiunia on 23.08.24.
//

import UIKit

class StartSetupView: UIViewController {

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "We are so happy that you joined us!!"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let appLabel: UILabel = {
        let label = UILabel()
        label.text = "MoodScape"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typingSpeed: TimeInterval = 0.075
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 35/255.0, green: 35/255.0, blue: 35/255.0, alpha: 1.0)
        setupView()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTypingAnimation()
    }

    private func setupView() {
        view.addSubview(messageLabel)
        view.addSubview(appLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            appLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            appLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func startTypingAnimation() {
        let fullText = messageLabel.text ?? ""
        messageLabel.text = ""
        
        var index = 0
        timer = Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if index < fullText.count {
                let endIndex = fullText.index(fullText.startIndex, offsetBy: index)
                self.messageLabel.text = String(fullText[..<endIndex])
                index += 1
            } else {
                timer.invalidate()
                self.transitionToNextView()
            }
        }
    }

    private func transitionToNextView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // TODO: NEXT VIEW, REPLACE IT
            let nextViewController = MainViewController()
            nextViewController.modalTransitionStyle = .crossDissolve
            self.present(nextViewController, animated: true, completion: nil)
        }
    }
}
