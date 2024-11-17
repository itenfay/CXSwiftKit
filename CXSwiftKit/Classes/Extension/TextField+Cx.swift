//
//  TextField+Cx.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2022/11/14.
//

#if os(iOS) || os(tvOS)
import UIKit

/// Text input type of `UITextField`.
@objc public enum CXTextInputType: Int {
    /// `UITextField` is used to enter email addresses.
    case emailAddress
    /// `UITextField` is used to enter passwords.
    case password
    /// `UITextField` is used to enter generic text.
    case generic
}

extension CXSwiftBase where T : UITextField {
    
    public var textInutType: CXTextInputType {
        get {
            return base.cx_textInutType
        }
        set (type) {
            base.cx_textInutType = type
        }
    }
    
    /// Clear text.
    public func clear() {
        base.cx_clear()
    }
    
    /// Set placeholder text color.
    ///
    /// - Parameter color: placeholder text color.
    public func setPlaceholderTextColor(_ color: UIColor) {
        base.cx_setPlaceholderTextColor(color)
    }
    
    /// Add padding to the left of the textfield.
    ///
    /// - Parameter padding: The value of padding to apply to the left of the textfield.
    public func addPaddingLeft(_ padding: CGFloat) {
        base.cx_addPaddingLeft(padding)
    }
    
    /// Add padding to the left of the textfield.
    /// - Parameters:
    ///   - image: Left image.
    ///   - padding: The value of padding between icon and the left of textfield.
    public func addPaddingLeftIcon(_ image: UIImage, padding: CGFloat) {
        base.cx_addPaddingLeftIcon(image, padding: padding)
    }
    
    /// Add padding to the right of the textfield.
    ///
    /// - Parameter padding: The value of padding to apply to the right of the textfield.
    public func addPaddingRight(_ padding: CGFloat) {
        base.cx_addPaddingRight(padding)
    }
    
    /// Add padding to the right of the textfield.
    ///
    /// - Parameters:
    ///   - image: Right image.
    ///   - padding: The value of padding between icon and the right of textfield.
    public func addPaddingRightIcon(_ image: UIImage, padding: CGFloat) {
        base.cx_addPaddingRightIcon(image, padding: padding)
    }
    
    /// Check if textFields text is a valid email format.
    public var hasValidEmail: Bool {
        return base.cx_hasValidEmail
    }
    
    /// Check if text field is empty.
    public var isEmpty: Bool {
        return base.cx_isEmpty
    }
    
    /// Return text with no spaces or new lines in beginning and end.
    public var trimmedText: String? {
        return base.cx_trimmedText
    }
    
    /// Left view tint color.
    var leftViewTintColor: UIColor? {
        get {
            return base.cx_leftViewTintColor
        }
        set {
            base.cx_leftViewTintColor = newValue
        }
    }
    
    /// Right view tint color.
    var rightViewTintColor: UIColor? {
        get {
            return base.cx_rightViewTintColor
        }
        set {
            base.cx_rightViewTintColor = newValue
        }
    }
    
}

extension UITextField {
    
    @objc public var cx_textInutType: CXTextInputType {
        get {
            if keyboardType == .emailAddress {
                return .emailAddress
            } else if isSecureTextEntry {
                return .password
            }
            return .generic
        }
        set {
            switch newValue {
            case .emailAddress:
                keyboardType = .emailAddress
                autocorrectionType = .no
                autocapitalizationType = .none
                isSecureTextEntry = false
            case .password:
                keyboardType = .asciiCapable
                autocorrectionType = .no
                autocapitalizationType = .none
                isSecureTextEntry = true
            case .generic:
                isSecureTextEntry = false
            }
        }
    }
    
    /// Clear text.
    @objc public func cx_clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }
    
    /// Set placeholder text color.
    ///
    /// - Parameter color: placeholder text color.
    @objc public func cx_setPlaceholderTextColor(_ color: UIColor) {
        guard let holder = placeholder, !holder.isEmpty else { return }
        attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: color])
    }
    
    /// Add padding to the left of the textfield.
    ///
    /// - Parameter padding: The value of padding to apply to the left of the textfield.
    @objc public func cx_addPaddingLeft(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
    
    /// Add padding to the left of the textfield.
    ///
    /// - Parameters:
    ///   - image: Left image.
    ///   - padding: The value of padding between icon and the left of textfield.
    @objc public func cx_addPaddingLeftIcon(_ image: UIImage, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        leftView = imageView
        leftView?.frame.size = CGSize(width: image.size.width + padding, height: image.size.height)
        leftViewMode = .always
    }
    
    /// Add padding to the right of the textfield.
    ///
    /// - Parameter padding: The value of padding to apply to the right of the textfield.
    @objc public func cx_addPaddingRight(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        rightView = paddingView
        rightViewMode = .always
    }
    
    /// Add padding to the right of the textfield.
    ///
    /// - Parameters:
    ///   - image: Right image.
    ///   - padding: The value of padding between icon and the right of textfield.
    @objc public func cx_addPaddingRightIcon(_ image: UIImage, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        rightView = imageView
        rightView?.frame.size = CGSize(width: image.size.width + padding, height: image.size.height)
        rightViewMode = .always
    }
    
    /// Check if textFields text is a valid email format.
    @objc public var cx_hasValidEmail: Bool {
        guard let _text = text else { return false }
        // http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
        return _text.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}",
                           options: String.CompareOptions.regularExpression,
                           range: nil, locale: nil) != nil
    }
    
    /// Check if text field is empty.
    @objc public var cx_isEmpty: Bool {
        return text?.isEmpty == true
    }
    
    /// Return text with no spaces or new lines in beginning and end.
    @objc public var cx_trimmedText: String? {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Left view tint color.
    @IBInspectable @objc public var cx_leftViewTintColor: UIColor? {
        get {
            return leftView?.tintColor
        }
        set {
            guard let iconView = leftView as? UIImageView else {
                leftView?.tintColor = newValue
                return
            }
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = newValue
        }
    }
    
    /// Right view tint color.
    @IBInspectable @objc public var cx_rightViewTintColor: UIColor? {
        get {
            return rightView?.tintColor
        }
        set {
            guard let iconView = rightView as? UIImageView else {
                rightView?.tintColor = newValue
                return
            }
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = newValue
        }
    }
    
}

#endif
