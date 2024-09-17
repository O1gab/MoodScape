//
//  ConfettiView.swift
//  MoodScape
//
//  Created by Olga Batiunia on 17.09.24.
//

import UIKit

class ConfettiView: UIView, CAAnimationDelegate {
    private var emitterLayer: CAEmitterLayer?

    func startConfettiAnimation() {
        emitterLayer = CAEmitterLayer()
        emitterLayer?.emitterPosition = CGPoint(x: self.bounds.width / 2, y: 0)
        emitterLayer?.emitterShape = .line
        emitterLayer?.emitterSize = CGSize(width: self.bounds.width, height: 1)

        let confettiColors: [UIColor] = [
            .red, .blue, .green, .yellow, .orange, .purple, .cyan, .magenta
        ]
        
        let confettiCells = confettiColors.map { makeConfettiCell(color: $0) }
        
        emitterLayer?.emitterCells = confettiCells
        self.layer.addSublayer(emitterLayer!)
        
        // Animation setup
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.fromValue = 1.0
        fadeOutAnimation.toValue = 0.0
        fadeOutAnimation.duration = 5.0
        fadeOutAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [fadeOutAnimation]
        groupAnimation.duration = 7.0
        groupAnimation.delegate = self
        
        // Start animations
        emitterLayer?.add(groupAnimation, forKey: "confettiAnimation")
        
        // Remove emitterLayer after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
            self.emitterLayer?.removeFromSuperlayer()
        }
    }

    private func makeConfettiCell(color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.contents = circleImage(color: color).cgImage
        cell.birthRate = 100
        cell.lifetime = 5.0
        cell.velocity = 200
        cell.velocityRange = 50
        cell.emissionRange = .pi
        cell.scale = 0.2
        cell.scaleRange = 0.1
        cell.yAcceleration = 150
        return cell
    }

    // Helper to create a small circle UIImage
    private func circleImage(color: UIColor) -> UIImage {
        let diameter: CGFloat = 10.0
        let size = CGSize(width: diameter, height: diameter)
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fillEllipse(in: CGRect(origin: .zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
}
