//
//  ImageExtensions.swift
//  MoodScape
//
//  Created by Olga Batiunia on 18.08.24.
//

import UIKit
import CoreImage

extension UIImage {
    func dominantColor() -> UIColor? {
        guard let cgImage = self.cgImage else { return nil }
        let width = 1
        let height = 1
        let bitsPerComponent = cgImage.bitsPerComponent
        let bytesPerRow = cgImage.bytesPerRow
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else { return nil }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let data = context.data else { return nil }
        let buffer = data.bindMemory(to: UInt8.self, capacity: width * height * 4)
        let r = CGFloat(buffer[0]) / 255.0
        let g = CGFloat(buffer[1]) / 255.0
        let b = CGFloat(buffer[2]) / 255.0
        let a = CGFloat(buffer[3]) / 255.0
            
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func applyCircularGradientOverlay(colors: [UIColor]) -> UIImage? {
            let size = self.size
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }

            self.draw(in: CGRect(origin: .zero, size: size))

            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = CGRect(origin: .zero, size: size)
            gradientLayer.colors = colors.map { $0.cgColor }
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)

            let radius = min(size.width, size.height) / 2
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.mask = gradientLayer
            
            context.saveGState()
            shapeLayer.render(in: context)
            context.restoreGState()
            
            let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return gradientImage
        }
}
