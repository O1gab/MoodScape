//
//  ButtonExtensions.swift
//  MoodScape
//
//

import UIKit
import ObjectiveC

extension UITextField {
    
    var eyeButton: UIButton {
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        button.tintColor = .white
        button.frame = CGRect(x: -5, y: 0, width: 40, height: 40)
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return button
    }
    
    @objc private func togglePasswordVisibility() {
        isSecureTextEntry.toggle()
        eyeButton.isSelected.toggle()
    }
}
