//
//  Button+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if os(iOS) || os(tvOS)
import UIKit

extension CXSwiftBase where T : UIButton {
    
    /// Adjust the edge insets of image and title of the button with a given alignment and padding.
    ///
    /// - Parameters:
    ///   - alignment: Button image and text alignment
    ///   - padding: The value of padding to adjust the edge insets of image and title of the button.
    public func adjustEdgeInsets(by alignment: CXButtonImageTextAlignment, padding: CGFloat)
    {
        self.base.cx_adjustEdgeInsets(by: alignment, padding: padding)
    }
    
    ///  Sets an image to the button for a specified state with a given url string.
    ///
    /// - Parameters:
    ///   - url: A given url string
    ///   - state: The button state to which the image should be set.
    ///   - placeholder: A placeholder to show while retrieving the image from the given url string.
    ///   - headers: Sets the HTTP header fields of the receiver to the given dictionary.
    ///   - progressBlock: Called when the image downloading progress gets updated.
    public func setImage(
        withUrl url: String?,
        forState state: UIControl.State,
        placeholder: UIImage? = nil,
        headers: [String : String] = [:],
        progressBlock: ((_ receivedSize: Int64, _ totalSize: Int64) -> Void)? = nil)
    {
        self.base.cx_setImage(withUrl: url, forState: state, placeholder: placeholder, headers: headers, progressBlock: progressBlock)
    }
    
    public var whiteIndicator: UIActivityIndicatorView
    {
        get {
            return base.cx_whiteIndicator
        }
        set (indicator) {
            base.cx_whiteIndicator = indicator
        }
    }
    
}

/// An enum for button image and text alignment.
@objc public enum CXButtonImageTextAlignment: Int {
    /// The image is on the left, the text is on the right, and the whole is centered.
    case `default`
    /// The image is on the left, the text is on the right, and the whole is centered.
    case left
    /// The image is on the right, the text is on the left, and the whole is centered.
    case right
    /// The image is on the top, the text is on the bottom, and the whole is in the center.
    case top
    /// The image is on the bottom, the text is on the top, and the whole is in the center.
    case bottom
    /// The image is in the center and the text is under the image.
    case centerTop
    /// The image is in the center and the text is on top of the image.
    case centerBottom
    /// The image is centered and the text is at the top of the button.
    case centerUp
    /// The image is centered and the text is below the button.
    case centerDown
    /// The image is on the right, the text is on the left, and they are on both sides of the button.
    case rightLeft
    /// The image is on the left, the text is on the right, and they are on both sides of the button.
    case leftRight
}

extension UIButton {
    
    /// Adjust the edge insets of image and title of the button with a given alignment and padding.
    ///
    /// - Parameters:
    ///   - alignment: Button image and text alignment
    ///   - padding: The value of padding to adjust the edge insets of image and title of the button.
    @objc public func cx_adjustEdgeInsets(by alignment: CXButtonImageTextAlignment, padding: CGFloat)
    {
        if imageView?.image != nil && titleLabel?.text != nil {
            // Reset title edge insets and image edge insets.
            titleEdgeInsets = .zero
            imageEdgeInsets = .zero
            
            let imageRect: CGRect = imageView!.frame
            let titleRect: CGRect = titleLabel!.frame
            let totalHeight: CGFloat = (imageRect.size.height) + padding + (titleRect.size.height)
            let selfWidth  = frame.size.width
            let selfHeight = frame.size.height
            
            switch alignment {
            case .left:
                if padding != 0 {
                    titleEdgeInsets = UIEdgeInsets(top: 0, left: padding/2, bottom: 0, right: -padding/2)
                    imageEdgeInsets = UIEdgeInsets(top: 0, left: -padding/2, bottom: 0, right: padding/2)
                }
                break
            case .right:
                titleEdgeInsets = UIEdgeInsets(top: 0, left: -((imageRect.size.width) + padding/2), bottom: 0, right: ((imageRect.size.width) + padding/2))
                imageEdgeInsets = UIEdgeInsets(top: 0, left: ((titleRect.size.width) + padding/2), bottom: 0, right: -((titleRect.size.width) + padding/2))
                break
            case .top:
                titleEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight)/2 + imageRect.size.height + padding - titleRect.origin.y),
                                               left: (selfWidth/2 - titleRect.origin.x - titleRect.size.width/2) - (selfWidth - titleRect.size.width)/2,
                                               bottom: -((selfHeight - totalHeight)/2 + imageRect.size.height + padding - titleRect.origin.y),
                                               right: -(selfWidth/2 - titleRect.origin.x - titleRect.size.width/2) - (selfWidth - titleRect.size.width)/2)
                imageEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight)/2 - imageRect.origin.y),
                                               left: (selfWidth/2 - imageRect.origin.x - imageRect.size.width/2),
                                               bottom: -((selfHeight - totalHeight)/2 - imageRect.origin.y),
                                               right: -(selfWidth/2 - imageRect.origin.x - imageRect.size.width/2))
                break
            case .bottom:
                titleEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight)/2 - titleRect.origin.y),
                                               left: (selfWidth/2 - titleRect.origin.x - titleRect.size.width/2) - (selfWidth - titleRect.size.width)/2,
                                               bottom: -((selfHeight - totalHeight)/2 - titleRect.origin.y),
                                               right: -(selfWidth/2 - titleRect.origin.x - titleRect.size.width/2) - (selfWidth - titleRect.size.width)/2)
                imageEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight)/2 + titleRect.size.height + padding - imageRect.origin.y),
                                               left: (selfWidth/2 - imageRect.origin.x - imageRect.size.width/2),
                                               bottom: -((selfHeight - totalHeight)/2 + titleRect.size.height + padding - imageRect.origin.y),
                                               right: -(selfWidth/2 - imageRect.origin.x - imageRect.size.width/2))
                break
            case .centerTop:
                titleEdgeInsets = UIEdgeInsets(top: -(titleRect.origin.y - padding),
                                               left: (selfWidth/2 -  titleRect.origin.x - titleRect.size.width/2) - (selfWidth - titleRect.size.width)/2,
                                               bottom: (titleRect.origin.y - padding),
                                               right: -(selfWidth/2 -  titleRect.origin.x - titleRect.size.width/2) - (selfWidth - titleRect.size.width)/2)
                imageEdgeInsets = UIEdgeInsets(top: 0,
                                               left: (selfWidth/2 - imageRect.origin.x - imageRect.size.width/2),
                                               bottom: 0,
                                               right: -(selfWidth/2 - imageRect.origin.x - imageRect.size.width/2))
                break
            case .centerBottom:
                titleEdgeInsets = UIEdgeInsets(top: (selfHeight - padding - titleRect.origin.y - titleRect.size.height),
                                               left: (selfWidth/2 -  titleRect.origin.x - titleRect.size.width/2) - (selfWidth - titleRect.size.width)/2,
                                               bottom: -(selfHeight - padding - titleRect.origin.y - titleRect.size.height),
                                               right: -(selfWidth/2 -  titleRect.origin.x - titleRect.size.width/2) - (selfWidth - titleRect.size.width)/2)
                imageEdgeInsets = UIEdgeInsets(top: 0,
                                               left: (selfWidth/2 - imageRect.origin.x - imageRect.size.width/2),
                                               bottom: 0,
                                               right: -(selfWidth/2 - imageRect.origin.x - imageRect.size.width/2))
                break
            case .centerUp:
                titleEdgeInsets = UIEdgeInsets(top: -(titleRect.origin.y + titleRect.size.height - imageRect.origin.y + padding),
                                               left: (selfWidth/2 -  titleRect.origin.x - titleRect.size.width/2) - (selfWidth - titleRect.size.width)/2,
                                               bottom: (titleRect.origin.y + titleRect.size.height - imageRect.origin.y + padding),
                                               right: -(selfWidth/2 -  titleRect.origin.x - titleRect.size.width/2) - (selfWidth - titleRect.size.width)/2)
                imageEdgeInsets = UIEdgeInsets(top: 0,
                                               left: (selfWidth/2 - imageRect.origin.x - imageRect.size.width/2),
                                               bottom: 0,
                                               right: -(selfWidth/2 - imageRect.origin.x - imageRect.size.width/2))
                break
            case .centerDown:
                titleEdgeInsets = UIEdgeInsets(top: (imageRect.origin.y + imageRect.size.height - titleRect.origin.y + padding),
                                               left: (selfWidth/2 -  titleRect.origin.x - titleRect.size.width/2) - (selfWidth - titleRect.size.width)/2,
                                               bottom: -(imageRect.origin.y + imageRect.size.height - titleRect.origin.y + padding),
                                               right: -(selfWidth/2 -  titleRect.origin.x - titleRect.size.width/2) - (selfWidth - titleRect.size.width)/2)
                imageEdgeInsets = UIEdgeInsets(top: 0,
                                               left: (selfWidth/2 - imageRect.origin.x - imageRect.size.width/2),
                                               bottom: 0,
                                               right: -(selfWidth/2 - imageRect.origin.x - imageRect.size.width/2))
                break
            case .rightLeft:
                titleEdgeInsets = UIEdgeInsets(top: 0,
                                               left: -(titleRect.origin.x - padding),
                                               bottom: 0,
                                               right: (titleRect.origin.x - padding))
                imageEdgeInsets = UIEdgeInsets(top: 0,
                                               left: (selfWidth - padding - imageRect.origin.x - imageRect.size.width),
                                               bottom: 0,
                                               right: -(selfWidth - padding - imageRect.origin.x - imageRect.size.width))
                break
            case .leftRight:
                titleEdgeInsets = UIEdgeInsets(top: 0,
                                               left: (selfWidth - padding - titleRect.origin.x - titleRect.size.width),
                                               bottom: 0,
                                               right: -(selfWidth - padding - titleRect.origin.x - titleRect.size.width))
                imageEdgeInsets = UIEdgeInsets(top: 0,
                                               left: -(imageRect.origin.x - padding),
                                               bottom: 0,
                                               right: (imageRect.origin.x - padding))
                break
            default:
                titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                break
            }
        } else {
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
}

#if canImport(Kingfisher)
import Kingfisher
#endif

extension UIButton {
    
    ///  Sets an image to the button for a specified state with a given url string.
    ///
    /// - Parameters:
    ///   - url: A given url string
    ///   - state: The button state to which the image should be set.
    ///   - placeholder: A placeholder to show while retrieving the image from the given url string.
    ///   - headers: Sets the HTTP header fields of the receiver to the given dictionary.
    ///   - progressBlock: Called when the image downloading progress gets updated.
    @objc public func cx_setImage(
        withUrl url: String?,
        forState state: UIControl.State,
        placeholder: UIImage? = nil,
        headers: [String : String] = [:],
        progressBlock: ((_ receivedSize: Int64, _ totalSize: Int64) -> Void)? = nil)
    {
        guard let _url = url, !_url.isEmpty else {
            CXLogger.log(level: .info, message: "The url is invalid.")
            return
        }
        #if canImport(Kingfisher)
        var modifier: AnyModifier? = nil
        if !headers.isEmpty {
            modifier = AnyModifier { request in
                var _request = request
                for key in headers.keys {
                    if let value = headers[key], !value.isEmpty {
                        // replace "key" with the field name you need, it's just an example.
                        _request.setValue(value, forHTTPHeaderField: key)
                    }
                }
                return _request
            }
        }
        
        if let _modifier = modifier {
            self.kf.setImage(
                with: URL.init(string: _url),
                for: state,
                placeholder: placeholder,
                options: [.requestModifier(_modifier)],
                progressBlock: progressBlock
            )
        } else {
            self.kf.setImage(
                with: URL.init(string: _url),
                for: state,
                placeholder: placeholder,
                progressBlock: progressBlock
            )
        }
        #else
        CXLogger.log(level: .warning, message: "Please import Kingfisher.")
        #endif
    }
    
    @objc public var cx_whiteIndicator: UIActivityIndicatorView {
        get {
            var indicator = objc_getAssociatedObject(self, &CXAssociatedKey.buttonWhiteIndicator) as? UIActivityIndicatorView
            if indicator == nil {
                if #available(iOS 13.0, tvOS 13.0, *) {
                    indicator = UIActivityIndicatorView(style: .medium)
                } else {
                    indicator = UIActivityIndicatorView(style: .white)
                }
                indicator!.center = CGPoint(x: self.bounds.width / 2,
                                            y: self.bounds.height / 2)
                addSubview(indicator!)
            }
            self.cx_whiteIndicator = indicator!
            // Reset its center.
            indicator!.center = CGPoint(x: self.bounds.width / 2,
                                        y: self.bounds.height / 2)
            return indicator!
        }
        set {
            objc_setAssociatedObject(self, &CXAssociatedKey.buttonWhiteIndicator, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

#endif
