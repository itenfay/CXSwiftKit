//
//  UIColor+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

import UIKit

/// A tuple of the components that form the color in the RGB color space.
public typealias CXColorRGBA = (red: CGFloat?, green: CGFloat?, blue: CGFloat?, alpha: CGFloat)

/// The components that form the color in the RGB color space.
public class CXRGBComponents: NSObject {
    var red: CGFloat?
    var green: CGFloat?
    var blue: CGFloat?
    var alpha: CGFloat = 0
}

extension CXSwiftBase where T : UIColor {
    
    /// Creates Color from RGB values with optional alpha.
    ///
    /// - Parameters:
    ///   - hex: Hex Int (example: 0xDEA3B6).
    ///   - alpha: Optional alpha value (default is 1).
    public static func cx_color(withHex hex: Int, alpha: CGFloat = 1) -> UIColor?
    {
        return UIColor.cx_color(withHex: hex, alpha: alpha)
    }
    
    /// Creates Color from hexadecimal string with optional alpha.
    ///
    /// - Parameters:
    ///   - hexString: Hexadecimal string (examples: EDE7F6, 0xEDE7F6, #EDE7F6, #0ff, 0xF0F, ..).
    ///   - alpha: Optional alpha value (default is 1).
    public static func cx_color(withHexString hexString: String, alpha: CGFloat = 1) -> UIColor?
    {
        return UIColor.cx_color(withHexString: hexString, alpha: alpha)
    }
    
    /// Converts the color to an image with the specified size.
    ///
    /// - Parameter size: The size of getting new image.
    /// - Returns: An image of the color with the specified size.
    public func asImage(withSize size: CGSize = CGSize(width: 1, height: 1)) -> UIImage?
    {
        self.base.cx_asImage(withSize: size)
    }
    
    /// Returns the components that form the color in the RGB color space.
    ///
    /// - Returns: A tuple of the components that form the color in the RGB color space.
    public func getRGBA() -> CXColorRGBA
    {
        let components = self.base.cx_getRGBA()
        return (components.red, components.green, components.blue, components.alpha)
    }
    
    /// Calculates the color difference of two colors.
    ///
    /// - Parameter color: Another color you specify.
    /// - Returns: The color difference of two colors.
    public func diff(byColor color: UIColor) -> Double
    {
        return self.base.cx_diff(byColor: color)
    }
    
    /// Creates a color randomly.
    public static var randomColor: UIColor
    {
        return UIColor.cx_randomColor()
    }
    
    /// Returns the text color to adapt to the background color.
    public var brightnessAdjustedColor: UIColor
    {
        return self.base.cx_brightnessAdjustedColor()
    }
    
}

extension UIColor {
    
    /// Creates a color object using the specified opacity and RGB component values.
    ///
    /// - Parameters:
    ///   - red: The red value of the color object.
    ///   - green: The green value of the color object.
    ///   - blue: The blue value of the color object.
    ///   - alpha: The opacity value of the color object.
    /// - Returns: The color object. The color information represented by this object is in an RGB colorspace.
    @objc public static func cx_color(withRed red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor?
    {
        guard red >= 0 && red <= 255 else { return nil }
        guard green >= 0 && green <= 255 else { return nil }
        guard blue >= 0 && blue <= 255 else { return nil }
        
        var _alpha = alpha
        if _alpha < 0 { _alpha = 0 }
        if _alpha > 1 { _alpha = 1 }
        
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: _alpha)
    }
    
    /// Creates Color from RGB values with optional alpha.
    ///
    /// - Parameters:
    ///   - hex: Hex Int (example: 0xDEA3B6).
    ///   - alpha: Optional alpha value (default is 1).
    @objc public static func cx_color(withHex hex: Int, alpha: CGFloat = 1) -> UIColor?
    {
        let red = (hex >> 16) & 0xff
        let green = (hex >> 8) & 0xff
        let blue = hex & 0xff
        return cx_color(withRed: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: alpha)
    }
    
    /// Creates Color from hexadecimal string with optional alpha.
    ///
    /// - Parameters:
    ///   - hexString: Hexadecimal string (examples: EDE7F6, 0xEDE7F6, #EDE7F6, #0ff, 0xF0F, ..).
    ///   - alpha: Optional alpha value (default is 1).
    @objc public static func cx_color(withHexString hexString: String, alpha: CGFloat = 1) -> UIColor?
    {
        var string = ""
        if hexString.lowercased().hasPrefix("0x") {
            string = hexString.replacingOccurrences(of: "0x", with: "")
        } else if hexString.hasPrefix("#") {
            string = hexString.replacingOccurrences(of: "#", with: "")
        } else {
            string = hexString
        }
        
        if string.count == 3 { // convert hex to 6 digit format if in short format
            var str = ""
            string.forEach { str.append(String(repeating: String($0), count: 2)) }
            string = str
        }
        
        guard let hexValue = Int(string, radix: 16) else { return nil }
        return cx_color(withHex: hexValue, alpha: alpha)
    }
    
    /// Converts the color to an image with the specified size.
    ///
    /// - Parameter size: The size of getting new image.
    /// - Returns: An image of the color with the specified size.
    @objc public func cx_asImage(withSize size: CGSize = CGSize(width: 1, height: 1)) -> UIImage?
    {
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// Returns the components that form the color in the RGB color space.
    ///
    /// - Returns: The components that form the color in the RGB color space.
    @objc public func cx_getRGBA() -> CXRGBComponents
    {
        var components = CXRGBComponents()
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        else {
            return components
        }
        
        let multiplier: CGFloat = 255.0
        components.red = red * multiplier
        components.green = green * multiplier
        components.blue = blue * multiplier
        components.alpha = alpha
        
        return components
    }
    
    /// Calculates the color difference of two colors.
    ///
    /// - Parameter color: Another color you specify.
    /// - Returns: The color difference of two colors.
    @objc public func cx_diff(byColor color: UIColor) -> Double
    {
        let c1 = self.cx.getRGBA()
        let c2 = color.cx.getRGBA()
        
        if c1.red == nil || c2.red == nil {
            // failure.
            return -1
        }
        
        let m = (c1.red! + c2.red!) * 0.5
        let r = c1.red! - c2.red!
        let g = c1.green! - c2.green!
        let b = c1.blue! - c2.blue!
        
        return sqrt((2 + m/256) * pow(r, 2) + 4 * pow(g, 2) + (2 + (255 - m)/256 * pow(b, 2)))
    }
    
    /// Creates a color randomly.
    /// - Returns: A color that was created randomly.
    @objc public static func cx_randomColor() -> UIColor
    {
        return cx_color(withRed: CGFloat(arc4random_uniform(256)),
                        green: CGFloat(arc4random_uniform(256)),
                        blue: CGFloat(arc4random_uniform(256)))
        ?? UIColor(white: 0.1, alpha: 0.8)
    }
    
    /// Returns the text color to adapt to the background color.
    @objc public func cx_brightnessAdjustedColor() -> UIColor
    {
        var components = self.cgColor.components
        let alpha = components?.last
        components?.removeLast()
        let color = CGFloat(1-(components?.max())! >= 0.5 ? 1.0 : 0.0)
        return UIColor(red: color, green: color, blue: color, alpha: alpha!)
    }
    
}
