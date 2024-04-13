//
//  Color+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if os(iOS) || os(tvOS) || os(macOS)
#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

//The color selector.
//let color = #colorLiteral(

/// A tuple of the components that form the color in the RGB color space.
public typealias CXColorRGBA = (red: CGFloat?, green: CGFloat?, blue: CGFloat?, alpha: CGFloat)

/// The components that form the color in the RGB color space.
public class CXRGBComponents: NSObject {
    var red: CGFloat?
    var green: CGFloat?
    var blue: CGFloat?
    var alpha: CGFloat = 0
}

extension CXSwiftBase where T : CXColor {
    
    /// Creates Color from RGB values with optional alpha.
    ///
    /// - Parameters:
    ///   - hex: Hex Int (example: 0xDEA3B6).
    ///   - alpha: Optional alpha value (default is 1).
    public static func color(withHex hex: Int, alpha: CGFloat = 1) -> CXColor?
    {
        return CXColor.cx_color(withHex: hex, alpha: alpha)
    }
    
    /// Creates Color from hexadecimal string with optional alpha.
    ///
    /// - Parameters:
    ///   - hexString: Hexadecimal string (examples: EDE7F6, 0xEDE7F6, #EDE7F6, #0ff, 0xF0F, ..).
    ///   - alpha: Optional alpha value (default is 1).
    public static func color(withHexString hexString: String, alpha: CGFloat = 1) -> CXColor?
    {
        return CXColor.cx_color(withHexString: hexString, alpha: alpha)
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
    public func diff(byColor color: CXColor) -> Double
    {
        return self.base.cx_diff(byColor: color)
    }
    
    /// Creates a color randomly.
    public static var randomColor: CXColor
    {
        return CXColor.cx_randomColor()
    }
    
    /// Returns the text color to adapt to the background color.
    public var brightnessAdjustedColor: CXColor
    {
        return self.base.cx_brightnessAdjustedColor()
    }
    
    /// Returns a hexadecimal string.
    public var hexString: String
    {
        return self.base.cx_hexString
    }
    
    /// Returns the inverse color.
    public var inverseColor: CXColor
    {
        return base.cx_inverseColor
    }
    
    #if os(iOS) || os(tvOS)
    /// Draws an image of the color with the specified size.
    ///
    /// - Parameter size: The size of getting new image.
    /// - Returns: An image of the color with the specified size.
    public func drawImage(withSize size: CGSize = CGSize(width: 1, height: 1)) -> UIImage?
    {
        self.base.cx_drawImage(withSize: size)
    }
    
    /// Returns a new image with the specified parameters.
    public func makeImageWithSize(
        _ size: CGSize,
        cornerRadius: CGFloat) -> UIImage
    {
        return base.cx_makeImageWithSize(size, cornerRadius: cornerRadius)
    }
    
    /// Returns a new image with the specified parameters.
    public func makeImageWithSize(
        _ size: CGSize,
        cornerRadius: CGFloat,
        borderWidth: CGFloat, borderColor: UIColor) -> UIImage
    {
        return base.cx_makeImageWithSize(size, cornerRadius: cornerRadius, borderWidth: borderWidth, borderColor: borderColor)
    }
    
    /// Returns a new image with the specified parameters.
    public func makeImageWithSize(
        _ size: CGSize,
        byRoundingCorners corners: UIRectCorner,
        cornerRadius: CGFloat,
        borderWidth: CGFloat, borderColor: UIColor) -> UIImage
    {
        return base.cx_makeImageWithSize(size, byRoundingCorners: corners, cornerRadius: cornerRadius, borderWidth: borderWidth, borderColor: borderColor)
    }
    
    /// Returns a new image with the specified parameters.
    public func makeImageWithSize(
        _ size: CGSize,
        byRoundingCorners corners: UIRectCorner,
        cornerRadius: CGFloat,
        borderWidth: CGFloat, borderColor: UIColor,
        lineCap: CGLineCap,
        lineJoin: CGLineJoin,
        lineDashPhase: CGFloat, lineDashLengths: [CGFloat]) -> UIImage
    {
        return base.cx_makeImageWithSize(size, byRoundingCorners: corners, cornerRadius: cornerRadius, borderWidth: borderWidth, borderColor: borderColor, lineCap: lineCap, lineJoin: lineJoin, lineDashPhase: lineDashPhase, lineDashLengths: lineDashLengths)
    }
    #endif
    
}

extension CXColor {
    
    /// Creates a color object using the specified opacity and RGB component values.
    ///
    /// - Parameters:
    ///   - red: The red value of the color object.
    ///   - green: The green value of the color object.
    ///   - blue: The blue value of the color object.
    ///   - alpha: The opacity value of the color object.
    /// - Returns: The color object. The color information represented by this object is in an RGB colorspace.
    @objc public static func cx_color(withRed red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> CXColor?
    {
        guard red >= 0 && red <= 255 else { return nil }
        guard green >= 0 && green <= 255 else { return nil }
        guard blue >= 0 && blue <= 255 else { return nil }
        
        var _alpha = alpha
        if _alpha < 0 { _alpha = 0 }
        if _alpha > 1 { _alpha = 1 }
        
        return CXColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: _alpha)
    }
    
    /// Creates Color from RGB values with optional alpha.
    ///
    /// - Parameters:
    ///   - hex: Hex Int (example: 0xDEA3B6).
    ///   - alpha: Optional alpha value (default is 1).
    @objc public static func cx_color(withHex hex: Int, alpha: CGFloat = 1) -> CXColor?
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
    @objc public static func cx_color(withHexString hexString: String, alpha: CGFloat = 1) -> CXColor?
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
    
    /// Returns the components that form the color in the RGB color space.
    ///
    /// - Returns: The components that form the color in the RGB color space.
    @objc public func cx_getRGBA() -> CXRGBComponents
    {
        let components = CXRGBComponents()
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
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
    @objc public func cx_diff(byColor color: CXColor) -> Double
    {
        let c1 = self.cx_getRGBA()
        let c2 = color.cx_getRGBA()
        
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
    @objc public static func cx_randomColor() -> CXColor
    {
        return cx_color(withRed: CGFloat(arc4random_uniform(256)),
                        green: CGFloat(arc4random_uniform(256)),
                        blue: CGFloat(arc4random_uniform(256)))
        ?? CXColor(white: 0.1, alpha: 0.8)
    }
    
    /// Returns the text color to adapt to the background color.
    @objc public func cx_brightnessAdjustedColor() -> CXColor
    {
        var components = self.cgColor.components
        let alpha = components?.last
        components?.removeLast()
        let color = CGFloat(1-(components?.max())! >= 0.5 ? 1.0 : 0.0)
        return CXColor(red: color, green: color, blue: color, alpha: alpha!)
    }
    
    /// Returns a hexadecimal string.
    @objc public var cx_hexString: String
    {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
    
    /// Returns the inverse color.
    @objc public var cx_inverseColor: CXColor
    {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return CXColor(red: 1 - red, green: 1 - green, blue: 1 - blue, alpha: alpha)
    }
    
}

#if os(iOS) || os(tvOS)
extension UIColor {
    
    /// Draws an image of the color with the specified size.
    ///
    /// - Parameter size: The size of getting new image.
    /// - Returns: An image of the color with the specified size.
    @objc public func cx_drawImage(withSize size: CGSize = CGSize(width: 1, height: 1)) -> UIImage?
    {
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext()
        else {
            UIGraphicsEndImageContext()
            return nil
        }
        context.setFillColor(self.cgColor)
        context.fill(CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// Returns a new image with the specified parameters.
    @objc public func cx_makeImageWithSize(
        _ size: CGSize,
        cornerRadius: CGFloat) -> UIImage
    {
        return cx_makeImageWithSize(size, cornerRadius: cornerRadius, borderWidth: 0, borderColor: .clear)
    }
    
    /// Returns a new image with the specified parameters.
    @objc public func cx_makeImageWithSize(
        _ size: CGSize,
        cornerRadius: CGFloat,
        borderWidth: CGFloat, borderColor: UIColor) -> UIImage
    {
        return cx_makeImageWithSize(size, byRoundingCorners: .allCorners, cornerRadius: cornerRadius, borderWidth: borderWidth, borderColor: borderColor)
    }
    
    /// Returns a new image with the specified parameters.
    @objc public func cx_makeImageWithSize(
        _ size: CGSize,
        byRoundingCorners corners: UIRectCorner,
        cornerRadius: CGFloat,
        borderWidth: CGFloat, borderColor: UIColor) -> UIImage
    {
        return cx_makeImageWithSize(size, byRoundingCorners: corners, cornerRadius: cornerRadius, borderWidth: borderWidth, borderColor: borderColor, lineCap: .butt, lineJoin: .miter, lineDashPhase: 0, lineDashLengths: [])
    }
    
    /// Returns a new image with the specified parameters.
    @objc public func cx_makeImageWithSize(
        _ size: CGSize,
        byRoundingCorners corners: UIRectCorner,
        cornerRadius: CGFloat,
        borderWidth: CGFloat, borderColor: UIColor,
        lineCap: CGLineCap,
        lineJoin: CGLineJoin,
        lineDashPhase: CGFloat, lineDashLengths: [CGFloat]) -> UIImage
    {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let cornerRadii = CGSize(width: cornerRadius, height: cornerRadius)
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: cornerRadii)
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: rect.size)
            let newImage = renderer.image { context in
                context.cgContext.setFillColor(self.cgColor)
                if borderWidth > 0 {
                    context.cgContext.setLineWidth(borderWidth)
                    context.cgContext.setStrokeColor(borderColor.cgColor)
                }
                context.cgContext.setLineJoin(lineJoin)
                context.cgContext.setLineCap(lineCap)
                if !lineDashLengths.isEmpty {
                    context.cgContext.setLineDash(phase: lineDashPhase, lengths: lineDashLengths)
                }
                path.addClip()
                context.cgContext.addPath(path.cgPath)
                context.cgContext.drawPath(using: .fillStroke)
            }
            return newImage
        } else {
            UIGraphicsBeginImageContext(rect.size)
            guard let context = UIGraphicsGetCurrentContext()
            else {
                UIGraphicsEndImageContext()
                return UIImage()
            }
            context.setFillColor(self.cgColor)
            if borderWidth > 0 {
                context.setLineWidth(borderWidth)
                context.setStrokeColor(borderColor.cgColor)
            }
            context.setLineJoin(lineJoin)
            context.setLineCap(lineCap)
            if !lineDashLengths.isEmpty {
                context.setLineDash(phase: lineDashPhase, lengths: lineDashLengths)
            }
            path.addClip()
            context.addPath(path.cgPath)
            context.drawPath(using: .fillStroke)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage ?? UIImage()
        }
    }
    
}
#endif

#endif
