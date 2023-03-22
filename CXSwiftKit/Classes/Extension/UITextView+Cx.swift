//
//  UITextView+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if canImport(UIKit)
import UIKit

extension CXSwiftBase where T : UITextView {
    
    /// Clears text.
    public func clear()
    {
        base.cx_clear()
    }
    
    ///  Scroll to the top of text view.
    public func scrollToTop()
    {
        base.cx_scrollToTop()
    }
    
    ///  Scrolls to the bottom of text view.
    public func scrollToBottom()
    {
        base.cx_scrollToBottom()
    }
    
    /// Wrap to the content (Text/Attributed Text).
    public func wrapToContent()
    {
        base.cx_wrapToContent()
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
    
    /// Appends a url string to display with a given font and foreground color for the text view.
    ///
    /// - Parameters:
    ///   - urlString: A url string to display.
    ///   - font: A font to display(Optional).
    ///   - foregroundColor: A foreground Color to display.
    public func appendLinkString(
        urlString: String,
        font: UIFont? = nil,
        foregroundColor: UIColor)
    {
        base.cx_appendLinkString(urlString: urlString, font: font, foregroundColor: foregroundColor)
    }
    
    /// Adds clickable action of the link string for the text view.
    /// IMPL: func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
    ///
    /// - Parameter target: The text view’s delegate.
    public func addLinkClickable(withTarget target: UITextViewDelegate)
    {
        base.cx_addLinkClickable(withTarget: target)
    }
    
}

//MARK: -  UITextView

extension UITextView {
    
    /// Clears text.
    @objc public func cx_clear()
    {
        text = ""
        attributedText = NSAttributedString(string: "")
    }
    
    ///  Scroll to the top of text view.
    @objc public func cx_scrollToTop()
    {
        let range = NSMakeRange(0, 1)
        scrollRangeToVisible(range)
    }
    
    ///  Scrolls to the bottom of text view.
    @objc public func cx_scrollToBottom()
    {
        let range = NSMakeRange(text.cx.length - 1, 1)
        scrollRangeToVisible(range)
    }
    
    /// Wrap to the content (Text/Attributed Text).
    @objc public func cx_wrapToContent()
    {
        contentInset = .zero
        scrollIndicatorInsets = .zero
        contentOffset = .zero
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        sizeToFit()
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
        attrString.append(attributedText)
        
        let attributes = [NSAttributedString.Key.font: font ?? self.font]
        let appendString = NSMutableAttributedString(string: string, attributes: attributes as [NSAttributedString.Key : Any])
        let range: NSRange = NSMakeRange(0, appendString.length)
        appendString.addAttribute(NSAttributedString.Key.foregroundColor, value: foregroundColor, range: range)
        attrString.append(appendString)
        attributedText = attrString
    }
    
    /// Appends a url string to display with a given font and foreground color for the text view.
    ///
    /// - Parameters:
    ///   - urlString: A url string to display.
    ///   - font: A font to display(Optional).
    ///   - foregroundColor: A foreground Color to display.
    @objc public func cx_appendLinkString(
        urlString: String,
        font: UIFont? = nil,
        foregroundColor: UIColor)
    {
        let attrString: NSMutableAttributedString = NSMutableAttributedString()
        attrString.append(attributedText)
        
        let attributes = [NSAttributedString.Key.font: font ?? self.font]
        let appendString = NSMutableAttributedString(string: urlString, attributes: attributes as [NSAttributedString.Key : Any])
        let range: NSRange = NSMakeRange(0, appendString.length)
        if !urlString.isEmpty {
            appendString.beginEditing()
            appendString.addAttribute(NSAttributedString.Key.link, value: urlString, range: range)
            appendString.endEditing()
            linkTextAttributes = [NSAttributedString.Key.foregroundColor : foregroundColor]
        } else {
            appendString.addAttribute(NSAttributedString.Key.foregroundColor, value: foregroundColor, range: range)
        }
        
        attrString.append(appendString)
        attributedText = attrString
    }
    
    /// Adds clickable action of the link string for the text view.
    /// IMPL: func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
    ///
    /// - Parameter target: The text view’s delegate.
    @objc public func cx_addLinkClickable(withTarget target: UITextViewDelegate)
    {
        isUserInteractionEnabled = true
        isEditable = false
        isScrollEnabled = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = target
    }
    
}

#endif
