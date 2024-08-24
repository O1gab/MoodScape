//
//  SetupBaseView.swift
//  MoodScape
//
//  Created by Olga Batiunia on 23.08.24.
//

import UIKit
import Gifu

class SetupBaseView: UIViewController {
    
    private let gradientLayer = CAGradientLayer()
    
    private let gifBackground: GIFImageView = {
        let gifBackground = GIFImageView()
        gifBackground.animate(withGIFNamed: "gradient_skyline_blinking_stars")
        gifBackground.contentMode = .scaleAspectFill
        gifBackground.translatesAutoresizingMaskIntoConstraints = false
        return gifBackground
    }()
    
    let typingSpeed: TimeInterval = 0.075
    var timer: Timer?
    
    // - MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        animateGradient()
        setupView()
        setupConstraints()
    }
    
    // - MARK: SetupView
    private func setupView() {
        view.addSubview(gifBackground)
        view.sendSubviewToBack(gifBackground)
    }
    
    // - MARK: SetupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gifBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifBackground.topAnchor.constraint(equalTo: view.topAnchor),
            gifBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
    
    // - MARK: StartTypingAnimation
    func startTypingAnimation(label: UILabel, text: String, typingSpeed: TimeInterval, completion: @escaping () -> Void) {
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
    func startErasingAnimation(label: UILabel, typingSpeed: TimeInterval, completion: @escaping () -> Void) {
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
    
    // - MARK: RevealButton
    func revealButton(button: UIButton) {
        UIView.animate(withDuration: 1.5) {
            button.alpha = 1
        }
    }
    
    func navigateToNextView(viewController: UIViewController) {
        viewController.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .push
        transition.subtype = .fromRight
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        self.view.window?.layer.add(transition, forKey: kCATransition)
        self.present(viewController, animated: false, completion: nil)
    }
}
