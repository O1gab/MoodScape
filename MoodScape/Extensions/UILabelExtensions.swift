//
//  UILabelExtensions.swift
//  MoodScape
//
//  Created by Olga Batiunia on 30.08.24.
//

import UIKit

extension UILabel {
    
    // - MARK: StartTypingAnimation
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
    
    // - MARK: StartErasingAnimation
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
