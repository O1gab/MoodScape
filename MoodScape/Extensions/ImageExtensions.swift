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
}
