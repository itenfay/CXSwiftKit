//
//  UIImageView+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if os(iOS) || os(tvOS)
import UIKit
#if canImport(Kingfisher)
import Kingfisher
#endif

extension CXSwiftBase where T : UIImageView {
    
    /// Sets an image to the image view with a data provider.
    ///
    /// - Parameters:
    ///   - url: A given url string.
    ///   - placeholder: A placeholder to show while retrieving the image from the given url string.
    ///   - headers: Sets the HTTP header fields of the receiver to the given dictionary.
    ///   - progressBlock: Called when the image downloading progress gets updated.
    public func setImage(withUrl url: String?, placeholder: UIImage? = nil, headers: [String : String] = [:], progressBlock: ((_ receivedSize: Int64, _ totalSize: Int64) -> Void)? = nil)
    {
        self.base.cx_setImage(withUrl: url, placeholder: placeholder, headers: headers, progressBlock: progressBlock)
    }
    
    #if canImport(CoreImage)
    /// Sets an image of QRCode to display in the image view.
    ///
    /// - Parameter value: The value that represents the content of QRCode.
    public func setQRCode(withValue value: String)
    {
        base.cx_setQRCode(withValue: value)
    }
    
    /// Sets an image of QRCode to display in the image view.
    ///
    /// - Parameters:
    ///   - value: The value that represents the content of QRCode.
    ///   - centerImage: A center image to display.
    ///   - centerSize: The size of center image to display.
    public func setQRCode(withValue value: String, centerImage: UIImage?, centerSize: CGSize = .init(width: 90, height: 90))
    {
        base.cx_setQRCode(withValue: value, centerImage: centerImage, centerSize: centerSize)
    }
    
    /// Sets an image of QRCode to display in the image view.
    ///
    /// - Parameters:
    ///   - value: The value that represents the content of QRCode.
    ///   - backgroudColor: A background color to display.
    ///   - foregroudColor: A foreground color to display.
    public func setQRCode(withValue value: String, backgroudColor: UIColor, foregroudColor: UIColor)
    {
        base.cx_setQRCode(withValue: value, backgroudColor: backgroudColor, foregroudColor: foregroudColor)
    }
    
    /// Sets an image of QRCode to display in the image view.
    ///
    /// - Parameters:
    ///   - value: The value that represents the content of QRCode.
    ///   - backgroudColor: A background color to display.
    ///   - foregroudColor: A foreground color to display.
    ///   - centerImage: A center image to display.
    ///   - centerSize: The size of center image to display.
    public func setQRCode(withValue value: String, backgroudColor: UIColor, foregroudColor: UIColor, centerImage: UIImage?, centerSize: CGSize = .init(width: 90, height: 90))
    {
        base.cx_setQRCode(withValue: value, backgroudColor: backgroudColor, foregroudColor: foregroudColor, centerImage: centerImage, centerSize: centerSize)
    }
    #endif
    
}

//MARK: - Kingfisher

extension UIImageView {
    
    /// Sets an image to the image view with a data provider.
    ///
    /// - Parameters:
    ///   - url: A given url string.
    ///   - placeholder: A placeholder to show while retrieving the image from the given url string.
    ///   - headers: Sets the HTTP header fields of the receiver to the given dictionary.
    ///   - progressBlock: Called when the image downloading progress gets updated.
    @objc public func cx_setImage(withUrl url: String?, placeholder: UIImage? = nil, headers: [String : String] = [:], progressBlock: ((_ receivedSize: Int64, _ totalSize: Int64) -> Void)? = nil)
    {
        guard let _url = url, !_url.isEmpty else {
            CXLogger.log(level: .info, message: "Invalid url string.")
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
                placeholder: placeholder,
                options: [.requestModifier(_modifier)],
                progressBlock:progressBlock
            )
        } else {
            self.kf.setImage(
                with: URL.init(string: _url),
                placeholder: placeholder,
                progressBlock:progressBlock
            )
        }
        #else
        CXLogger.log(level: .warning, message: "Please import Kingfisher.")
        #endif
    }
    
}

//MARK: - QRCode

extension UIImageView {
    
    #if canImport(CoreImage)
    /// Sets an image of QRCode to display in the image view.
    ///
    /// - Parameter value: The value that represents the content of QRCode.
    @objc public func cx_setQRCode(withValue value: String)
    {
        self.image = value.cx.generateQRCode()
    }
    
    /// Sets an image of QRCode to display in the image view.
    ///
    /// - Parameters:
    ///   - value: The value that represents the content of QRCode.
    ///   - centerImage: A center image to display.
    ///   - centerSize: The size of center image to display.
    @objc public func cx_setQRCode(withValue value: String, centerImage: UIImage?, centerSize: CGSize = .init(width: 90, height: 90))
    {
        self.image = value.cx.generateQRCode(withCenterImage: centerImage, centerSize: centerSize)
    }
    
    /// Sets an image of QRCode to display in the image view.
    ///
    /// - Parameters:
    ///   - value: The value that represents the content of QRCode.
    ///   - backgroudColor: A background color to display.
    ///   - foregroudColor: A foreground color to display.
    @objc public func cx_setQRCode(withValue value: String, backgroudColor: UIColor, foregroudColor: UIColor)
    {
        self.image = value.cx.generateQRCode(withBackgroudColor: backgroudColor, foregroudColor: foregroudColor)
    }
    
    /// Sets an image of QRCode to display in the image view.
    ///
    /// - Parameters:
    ///   - value: The value that represents the content of QRCode.
    ///   - backgroudColor: A background color to display.
    ///   - foregroudColor: A foreground color to display.
    ///   - centerImage: A center image to display.
    ///   - centerSize: The size of center image to display.
    @objc public func cx_setQRCode(withValue value: String, backgroudColor: UIColor, foregroudColor: UIColor, centerImage: UIImage?, centerSize: CGSize = .init(width: 90, height: 90))
    {
        self.image = value.cx.generateQRCode(withBackgroudColor: backgroudColor, foregroudColor: foregroudColor, centerImage: centerImage, centerSize: centerSize)
    }
    #endif
    
}


#endif
