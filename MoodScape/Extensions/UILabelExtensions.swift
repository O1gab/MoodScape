//
//  UILabelExtensions.swift
//  MoodScape
//
//  Created by Olga Batiunia on 30.08.24.
//

import UIKit

extension UILabel {
    
    // MARK: - StartTypingAnimation
    func startTypingAnimation(label: UILabel, text: String, typingSpeed: TimeInterval, completion: @escaping () -> Void) {
        var timer: Timer?
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
    
    // MARK: - StartErasingAnimation
    func startErasingAnimation(label: UILabel, typingSpeed: TimeInterval, completion: @escaping () -> Void) {
        var timer: Timer?
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
}

class GradientLabel: UILabel {

    var gradientColors: [UIColor] = [UIColor.white, UIColor.gray, UIColor.systemGreen]
       private var gradientLayer: CAGradientLayer!

       override func layoutSubviews() {
           super.layoutSubviews()
           applyGradientMask()
       }

    private func applyGradientMask() {
        if gradientLayer == nil {
            gradientLayer = CAGradientLayer()
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            gradientLayer.frame = bounds
            
            let textLayer = CATextLayer()
            textLayer.string = createAttributedString()
            textLayer.font = font
            textLayer.fontSize = font.pointSize
            textLayer.alignmentMode = convertAlignment()
            textLayer.frame = bounds
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.isWrapped = true
            textLayer.truncationMode = .end
            
            gradientLayer.mask = textLayer
            
            layer.addSublayer(gradientLayer)
        }
        
        animateGradient()
    }
    
    private func createAttributedString() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = textAlignment
           
        return NSAttributedString(
            string: text ?? "",
            attributes: [
                .font: font as Any,
                .paragraphStyle: paragraphStyle
            ]
        )
    }

    private func convertAlignment() -> CATextLayerAlignmentMode {
        switch textAlignment {
        case .center:
            return .center
        case .right:
            return .right
        case .left:
            return .left
        case .justified:
            return .justified
        case .natural:
            return .natural
        @unknown default:
            return .left
        }
    }
    
    private func animateGradient() {
        let colorAnimation = CABasicAnimation(keyPath: "colors")
        colorAnimation.fromValue = gradientColors.map { $0.cgColor }
        colorAnimation.toValue = [UIColor.systemGreen.cgColor, UIColor.gray.cgColor, UIColor.white.cgColor]
        colorAnimation.duration = 3.0
        colorAnimation.autoreverses = true
        colorAnimation.repeatCount = .infinity
        
        gradientLayer.add(colorAnimation, forKey: "colorChange")
           
        gradientLayer.colors = [UIColor.systemGreen.cgColor, UIColor.gray.cgColor, UIColor.white.cgColor]
    }

    override func draw(_ rect: CGRect) {}
}
