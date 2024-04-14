//
//  TextView+Cx.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2022/11/14.
//

#if os(iOS) || os(tvOS)
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
    
    /// The string that displays when there is no other text in the text view.
    public var placeholder: String
    {
        get { base.cx_placeholder }
        set {
            base.cx_placeholder = newValue
        }
    }
    
    /// The placeholder text color.
    public var placeholderColor: UIColor
    {
        get { base.cx_placeholderColor }
        set {
            base.cx_placeholderColor = newValue
        }
    }
    
    /// The styled string that displays when there is no other text in the text view.
    public var attributedPlaceholder: NSAttributedString?
    {
        get { base.cx_attributedPlaceholder }
        set {
            base.cx_attributedPlaceholder = newValue
        }
    }
    
    /// The placeholder text label.
    public var placeholderLabel: UILabel { base.cx_placeholderLabel }
    
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
        #if os(iOS)
        isEditable = false
        #endif
        isScrollEnabled = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = target
    }
    
    /// The string that displays when there is no other text in the text view.
    @IBInspectable @objc public var cx_placeholder: String
    {
        get { cx_placeholderLabel.text ?? "" }
        set {
            cx_placeholderLabel.text = newValue
        }
    }
    
    /// The placeholder text color.
    @IBInspectable @objc public var cx_placeholderColor: UIColor
    {
        get { cx_placeholderLabel.textColor }
        set {
            cx_placeholderLabel.textColor = newValue
        }
    }
    
    /// The styled string that displays when there is no other text in the text view.
    @objc public var cx_attributedPlaceholder: NSAttributedString?
    {
        get { cx_placeholderLabel.attributedText }
        set {
            cx_placeholderLabel.attributedText = newValue
        }
    }
    
    /// The placeholder text label.
    @objc public var cx_placeholderLabel: UILabel
    {
        guard let label = objc_getAssociatedObject(self, &CXAssociatedKey.textViewPlaceholder) as? UILabel else {
            // Prevent abnormal display when there is no size.
            if font == nil {
                font = UIFont.systemFont(ofSize: 14)
            }
            let label = UILabel(frame: bounds)
            label.backgroundColor = .clear
            label.numberOfLines = 0
            label.font = font
            label.textColor = .lightGray
            label.sizeToFit()
            addSubview(label)
            sendSubviewToBack(label)
            objc_setAssociatedObject(self, &CXAssociatedKey.textViewPlaceholder, label, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return label
        }
        return label
    }
    
}

#endif
