//
//  UILabel+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if canImport(UIKit)
import UIKit

extension CXSwiftBase where T : UILabel {
    
    /// The required height for a label.
    public var requiredHeight: CGFloat {
        return base.cx_requiredHeight
    }
    
    /// Returns the height that best fits the specified size.
    public var fittingHeight: CGFloat {
        return base.cx_fittingHeight
    }
    
    /// Returns the width that best fits the specified size.
    public var fittingWidth: CGFloat {
        return base.cx_fittingWidth
    }
    
    /// Appends a string to display with a given font and foreground color for the text view.
    ///
    /// - Parameters:
    ///   - string: A string to display.
    ///   - font: A font to display(Optional).
    ///   - foregroundColor: A foreground Color to display.
    public func appendString(
        string: String,
        font: UIFont? = nil,
        foregroundColor: UIColor)
    {
        base.cx_appendString(string: string, font: font, foregroundColor: foregroundColor)
    }
    
}

//MARK: -  UILabel

extension UILabel {
    
    /// The required height for a label.
    @objc public var cx_requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
    
    /// Returns the height that best fits the specified size.
    @objc public var cx_fittingHeight: CGFloat {
        let specifiedSize = CGSize(width: frame.width, height: .greatestFiniteMagnitude)
        let size = sizeThatFits(specifiedSize)
        return size.height
    }
    
    /// Returns the width that best fits the specified size.
    @objc public var cx_fittingWidth: CGFloat {
        let specifiedSize = CGSize(width: .greatestFiniteMagnitude, height: frame.height)
        let size = sizeThatFits(specifiedSize)
        return size.width
    }
    
    /// Appends a string to display with a given font and foreground color for the text view.
    ///
    /// - Parameters:
    ///   - string: A string to display.
    ///   - font: A font to display(Optional).
    ///   - foregroundColor: A foreground Color to display.
    @objc public func cx_appendString(
        string: String,
        font: UIFont? = nil,
        foregroundColor: UIColor)
    {
        let attrString: NSMutableAttributedString = NSMutableAttributedString()
        attrString.append(attributedText ?? NSAttributedString(string: ""))
        
        let attributes = [NSAttributedString.Key.font: font ?? self.font]
        let appendString = NSMutableAttributedString(string: string, attributes: attributes as [NSAttributedString.Key : Any])
        let range: NSRange = NSMakeRange(0, appendString.length)
        appendString.addAttribute(NSAttributedString.Key.foregroundColor, value: foregroundColor, range: range)
        attrString.append(appendString)
        attributedText = attrString
    }
    
}

#endif
