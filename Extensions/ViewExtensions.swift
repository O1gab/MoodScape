//
//  ViewExtensions.swift
//  MoodScape
//
//  Created by Olga Batiunia on 16.08.24.
//
import UIKit

extension UIView {
    
    func colorAtPoint(point: CGPoint) -> UIColor? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let image = renderer.image { ctx in
            layer.render(in: ctx.cgContext)
        }
        
        guard let cgImage = image.cgImage else { return nil }
        let dataProvider = cgImage.dataProvider
        guard let data = dataProvider?.data else { return nil }
        let bytes = CFDataGetBytePtr(data)
        
        let bytesPerPixel = cgImage.bitsPerPixel / cgImage.bitsPerComponent
        let pixelIndex = ((Int(point.y) * cgImage.bytesPerRow) + (Int(point.x) * bytesPerPixel))
        
        let red = CGFloat(bytes![pixelIndex]) / 255.0
        let green = CGFloat(bytes![pixelIndex+1]) / 255.0
        let blue = CGFloat(bytes![pixelIndex+2]) / 255.0
        let alpha = CGFloat(bytes![pixelIndex+3]) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
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
