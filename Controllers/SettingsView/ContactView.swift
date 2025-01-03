//
//  ContactView.swift
//  MoodScape
//
//  Created by Olga Batiunia on 22.08.24.
//

import UIKit
import MessageUI

class ContactViewController: ProfileBaseView, MFMailComposeViewControllerDelegate {
    
    // MARK: - Properties
    private let contactLabel: UILabel = {
        let settingsLabel = UILabel()
        settingsLabel.text = "Contact"
        settingsLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        settingsLabel.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        settingsLabel.textAlignment = .center
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        return settingsLabel
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Contact Support", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 25
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let feedbackButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send Feedback", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 25
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let appLabel: UILabel = {
        let settingsLabel = UILabel()
        settingsLabel.text = "MoodScape"
        settingsLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        settingsLabel.textColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        settingsLabel.textAlignment = .center
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        return settingsLabel
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "App Version 1.0.0"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.messageLabel.startTypingAnimation(label: self?.messageLabel ?? UILabel(), text: "You can contact our support at support@moodscape.io or provide feedback at feedback@moodscape.io.", typingSpeed: 0.05) {
                DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
                    UIView.animate(withDuration: 3.0) {
                        self?.emailButton.alpha = 1.0
                        self?.feedbackButton.alpha = 1.0
                    }
                }
            }
        }
    }
    
    // MARK: - SetupView
    private func setupView() {
        view.addSubview(contactLabel)
        view.addSubview(appLabel)
        view.addSubview(messageLabel)
        view.addSubview(emailButton)
        view.addSubview(feedbackButton)
        view.addSubview(versionLabel)
        
        emailButton.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
        feedbackButton.addTarget(self, action: #selector(sendFeedback), for: .touchUpInside)
    }
    
    // MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contactLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            contactLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            appLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            appLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            messageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            messageLabel.topAnchor.constraint(equalTo: contactLabel.bottomAnchor, constant: 100),
            messageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            emailButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 300),
            emailButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emailButton.widthAnchor.constraint(equalToConstant: 200),
            emailButton.heightAnchor.constraint(equalToConstant: 50),
            
            feedbackButton.topAnchor.constraint(equalTo: emailButton.bottomAnchor, constant: 30),
            feedbackButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            feedbackButton.widthAnchor.constraint(equalToConstant: 200),
            feedbackButton.heightAnchor.constraint(equalToConstant: 50),
            
            versionLabel.bottomAnchor.constraint(equalTo: appLabel.bottomAnchor, constant: 15),
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - SendEmail
    @objc private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients(["support@moodscape.io"]) // TODO: Replace with your support email
            mailComposeVC.setSubject("Support Request")
            mailComposeVC.setMessageBody("Hello, I need help with...", isHTML: false)
            
            present(mailComposeVC, animated: true, completion: nil)
        } else {
            // Show alert if mail services are not available
            let alert = UIAlertController(title: "Mail Services Unavailable", message: "Please set up an email account to send mail.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: SendFeedback
    @objc private func sendFeedback() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients(["feedback@moodscape.io"]) // TODO: REPLACE
            mailComposeVC.setSubject("MoodScape Feedback")
            mailComposeVC.setMessageBody("Here is my feedback...", isHTML: false)
            
            present(mailComposeVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Mail Services Unavailable", message: "Please set up an email account to send feedback.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - MailCompose Delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
