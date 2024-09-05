//
//  test.swift
//  MoodScape
//
//  Created by Olga Batiunia on 05.09.24.
//

import UIKit

class GradientCircleView: UIView {

    private let shadowLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadow()
        startShadowAnimation()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShadow()
        startShadowAnimation()
    }

    private func setupShadow() {
        shadowLayer.fillColor = UIColor.clear.cgColor
        shadowLayer.shadowColor = UIColor(red: 127/255, green: 255/255, blue: 212/255, alpha: 1.0).cgColor
        shadowLayer.shadowOpacity = 0.7
        shadowLayer.shadowRadius = 40
        shadowLayer.shadowOffset = .zero
        
        layer.addSublayer(shadowLayer)
    }

    private func startShadowAnimation() {
        let shadowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        shadowAnimation.fromValue = 0.2
        shadowAnimation.toValue = 0.6
        shadowAnimation.duration = 2
        shadowAnimation.autoreverses = true
        shadowAnimation.repeatCount = .infinity
        shadowLayer.add(shadowAnimation, forKey: "shadowOpacityAnimation")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = bounds.width / 2
        shadowLayer.frame = bounds
        shadowLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        shadowLayer.shadowPath = shadowLayer.path
    }
}

