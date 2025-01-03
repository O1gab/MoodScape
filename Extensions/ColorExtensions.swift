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
        
    // Function to calculate brightness of the color
    private func brightness() -> CGFloat {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
            
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
        // Using the formula for luminance to determine brightness
        return (0.299 * red + 0.587 * green + 0.114 * blue)
    }
        
    func contrastingComplementaryColor() -> UIColor {
        let compColor = complementaryColor()
        let compColorBrightness = compColor.brightness()
           
        // Ensure the contrasting color is visible on the background
        if compColorBrightness > 0.5 {
        // If the complementary color is light, darken it
            return compColor.darker()
        } else {
        // If the complementary color is dark, lighten it
            return compColor.lighter()
        }
    }
       
    // Function to lighten a color
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return adjustBrightness(by: abs(percentage))
    }
       
    // Function to darken a color
    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return adjustBrightness(by: -abs(percentage))
    }
       
    // Function to adjust brightness
    private func adjustBrightness(by percentage: CGFloat = 30.0) -> UIColor {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
           
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(
                red: min(red + percentage/100, 1.0),
                   green: min(green + percentage/100, 1.0),
                   blue: min(blue + percentage/100, 1.0),
                   alpha: alpha
            )
        } else {
            return self
        }
    }
    
    func isTooSimilar(to color: UIColor) -> Bool {
        let threshold: CGFloat = 0.1
        
        var red1: CGFloat = 0
        var green1: CGFloat = 0
        var blue1: CGFloat = 0
        var alpha1: CGFloat = 0
        self.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        
        var red2: CGFloat = 0
        var green2: CGFloat = 0
        var blue2: CGFloat = 0
        var alpha2: CGFloat = 0
        color.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        
        return abs(red1 - red2) < threshold && abs(green1 - green2) < threshold && abs(blue1 - blue2) < threshold
    }
}
