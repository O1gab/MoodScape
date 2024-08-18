//
//  ColorExtensions.swift
//  MoodScape
//
//  Created by Olga Batiunia on 18.08.24.
//

import UIKit

extension UIColor {
    // Calculates the luminance to determine if the contrasting color should be black or white
    func contrastingColor() -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let luminance = (0.299 * red + 0.587 * green + 0.114 * blue)
        
        return luminance > 0.5 ? UIColor.black : UIColor.white
    }
    
    // Function to find the complementary color
    func complementaryColor() -> UIColor {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
            
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            
        let complementaryHue = (hue + 0.5).truncatingRemainder(dividingBy: 1.0)
            
        return UIColor(hue: complementaryHue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}
