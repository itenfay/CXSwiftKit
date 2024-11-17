//
//  ImageView+Cx.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2022/11/14.
//

#if os(iOS) || os(tvOS)
import UIKit

extension CXSwiftBase where T : UIImageView {
    
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
    
    /// Makes image view blurry.
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    public func blur(withStyle style: UIBlurEffect.Style = .light)
    {
        base.cx_blur(withStyle: style)
    }
    
    /// Blurred version of an image view.
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    /// - Returns: blurred version of self.
    public func blurred(withStyle style: UIBlurEffect.Style = .light) -> UIImageView
    {
        return base.cx_blurred(withStyle: style)
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
    
    /// Makes image view blurry.
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    @objc public func cx_blur(withStyle style: UIBlurEffect.Style = .light)
    {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        addSubview(blurEffectView)
        clipsToBounds = true
    }
    
    /// Blurred version of an image view.
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    /// - Returns: blurred version of self.
    @objc public func cx_blurred(withStyle style: UIBlurEffect.Style = .light) -> UIImageView
    {
        let imgView = self
        imgView.cx_blur(withStyle: style)
        return imgView
    }
    
}

#endif
