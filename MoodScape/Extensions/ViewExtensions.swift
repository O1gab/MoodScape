//
//  ViewExtensions.swift
//  MoodScape
//
//  Created by Olga Batiunia on 16.08.24.
//
import UIKit

extension UIView {
    
    func startFallingStarsAnimation(numberOfStars: Int = 50, starSize: CGFloat = 10.0, duration: TimeInterval = 2.0) {
        for _ in 0..<numberOfStars {
            let star = createStar(size: starSize)
            animateStar(star, duration: duration)
        }
    }
    
    private func createStar(size: CGFloat) -> UIView {
        let star = UIView()
        star.frame = CGRect(x: 0, y: 0, width: size, height: size)
        star.backgroundColor = UIColor.systemGreen
        star.layer.cornerRadius = size / 2
        star.layer.masksToBounds = true
        star.center = CGPoint(x: CGFloat.random(in: 0...bounds.width), y: CGFloat.random(in: 0...bounds.height))
        addSubview(star)
        return star
    }
    
    private func animateStar(_ star: UIView, duration: TimeInterval) {
        let delay: TimeInterval = TimeInterval.random(in: 0...1)
        let endX = bounds.width + star.bounds.width
        let endY = bounds.height + star.bounds.height
        
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseIn], animations: {
            star.center = CGPoint(x: endX, y: endY)
            star.alpha = 0
        }, completion: { _ in
            star.removeFromSuperview()
        })
    }
}
