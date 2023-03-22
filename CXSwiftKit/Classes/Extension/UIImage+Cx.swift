//
//  UIImage+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if canImport(UIKit)
import UIKit
import CoreImage
import CoreGraphics

extension CXSwiftBase where T : UIImage {
    
    /// Returns a pattern color object using the specified image object.
    public var patternColor: UIColor
    {
        return base.cx_patternColor
    }
    
    /// Returns a string value of QRCode that detects from an image.
    ///
    /// - Returns: A string value of QRCode.
    public var stringValue: String?
    {
        return base.cx_stringValue
    }
    
    /// Extracts a color object from the specified rectangle.
    ///
    /// - Parameters:
    ///   - rect: The rectangle to extract.
    ///   - alpha: The opacity value of the color object.
    /// - Returns: A color object.
    public func extractColor(inRect rect: CGRect, alpha: CGFloat = 0) -> UIColor {
        return base.cx_extractColor(inRect: rect, alpha: alpha)
    }
    
    /// Draws an image with a given color and blend mode.
    ///
    /// - Parameters:
    ///   - color: A color object to draw.
    ///   - opaque: Indicates whether the bitmap is opaque.
    ///   - blendMode: Compositing operations for images.
    /// - Returns: A new image.
    public func drawImage(withColor color: UIColor, opaque: Bool = false, blendMode: CGBlendMode = .normal) -> UIImage
    {
        base.cx_drawImage(withColor: color, opaque: opaque, blendMode: blendMode)
    }
    
    /// Renders an image with a given color.
    ///
    /// - Parameter color: A color object to render.
    /// - Returns: A new image.
    public func renderImage(withColor color: UIColor) -> UIImage
    {
        return base.cx_renderImage(withColor: color)
    }
    
    /// Scales the image to the specified size.
    ///
    /// - Parameters:
    ///   - size: The size to specify.
    ///   - opaque: Flag indicating whether the bitmap is opaque.
    /// - Returns: An optional image.
    public func scale(toSize size: CGSize, opaque: Bool = false) -> UIImage?
    {
        return base.cx_scale(toSize: size, opaque: opaque)
    }
    
    /// Scales the image to height with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - height: The height to scale.
    ///   - opaque: Flag indicating whether the bitmap is opaque.
    /// - Returns: An optional image.
    public func scale(toHeight height: CGFloat, opaque: Bool = false) -> UIImage?
    {
        return base.cx_scale(toHeight: height, opaque: opaque)
    }
    
    /// Scales the image to width with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - width: The width to scale.
    ///   - opaque: Flag indicating whether the bitmap is opaque.
    /// - Returns: An optional image.
    public func scale(toWidth width: CGFloat, opaque: Bool = false) -> UIImage?
    {
        return base.cx_scale(toWidth: width, opaque: opaque)
    }
    
    /// Returns a new image object with the specified cap insets and tile resizing mode.
    ///
    /// - Parameter capInsets: The values to use for the cap insets.
    /// - Returns: A new image object with the specified cap insets and tile resizing mode.
    public func tile(withCapInsets capInsets: UIEdgeInsets) -> UIImage
    {
        return base.cx_tile(withCapInsets: capInsets)
    }
    
    /// Returns a new image object with the specified cap insets and stretch resizing mode.
    ///
    /// - Parameter capInsets: The values to use for the cap insets.
    /// - Returns: A new image object with the specified cap insets and stretch resizing mode.
    public func stretch(withCapInsets capInsets: UIEdgeInsets = .zero) -> UIImage
    {
        return base.cx_stretch(withCapInsets: capInsets)
    }
    
    /// Returns a compressed image from original image with a given quality value.
    ///
    /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality). default is 0.5.
    /// - Returns: An optional image.
    public func compress(withQuality quality: CGFloat = 0.5) -> UIImage?
    {
        return base.cx_compress(withQuality: quality)
    }
    
    /// Returns a compressed image data from original image with a given quality value.
    ///
    /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality). default is 0.5.
    /// - Returns: An optional data.
    public func compressedData(withQuality quality: CGFloat = 0.5) -> Data?
    {
        return base.cx_compressedData(withQuality: quality)
    }
    
    /// Crops an image to the specified rectangle.
    ///
    /// - Parameter rect: A rectangle specifying the portion of the image to keep.
    /// - Returns: A cropped image.
    public func cropping(toRect rect: CGRect) -> UIImage
    {
        return base.cx_cropping(toRect: rect)
    }
    
    /// Crops an image to the specified rectangle.
    ///
    /// - Parameters:
    ///   - cropRect: A rectangle specifying the portion of the image to keep.
    ///   - viewWidth: The width for the view.
    ///   - viewHeight: The height for the view.
    /// - Returns: A cropped image.
    public func crop(toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage
    {
        return base.cx_crop(toRect: cropRect, viewWidth: viewWidth, viewHeight: viewHeight)
    }
    
    /// Creates a copy of the receiver rotated by the given angle (in radians).
    ///   // Rotate the image by 180°
    ///   image.rotated(by: .pi)
    ///
    /// - Parameter angle: The angle, in radians, by which to rotate the image.
    /// - Returns: A new image rotated by the given angle.
    public func rotateBy(angle: CGFloat) -> UIImage?
    {
        return base.cx_rotateBy(angle: angle)
    }
    
    ///  Creates a copy of the receiver rotated by the given angle.
    ///   // Rotate the image by 180°
    ///   image.rotated(by: Measurement(value: 180, unit: .degrees))
    ///
    /// - Parameter unitAngle: The angle measurement by which to rotate the image.
    /// - Returns: A new image rotated by the given angle.
    @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    public func rotateBy(unitAngle: Measurement<UnitAngle>) -> UIImage?
    {
        return base.cx_rotateBy(unitAngle: unitAngle)
    }
    
    /// Returns an image with .alwaysOriginal rendering mode.
    public var original: UIImage
    {
        return base.cx_original
    }
    
    /// Returns an image with .alwaysTemplate rendering mode.
    public var template: UIImage
    {
        return base.cx_template
    }
    
    /// Returns the size in bytes of the image.
    public var bytesSize: Int
    {
        return base.cx_bytesSize
    }
    
    /// Returns the size in kilo bytes of the image.
    public var kilobytesSize: Int
    {
        return base.cx_kilobytesSize
    }
    
}


//MARK: -  UIImage

extension UIImage {
    
    /// Returns a pattern color object using the specified image object.
    @objc public var cx_patternColor: UIColor
    {
        return UIColor(patternImage: self)
    }
    
    /// Returns a string value of QRCode that detects from an image.
    ///
    /// - Returns: A string value of QRCode.
    @objc public var cx_stringValue: String?
    {
        guard let cgImage = self.cgImage else {
            return nil
        }
        let ciImage = CIImage(cgImage: cgImage, options: nil)
        let context = CIContext(options: [CIContextOption.useSoftwareRenderer : true])
        let detector = CIDetector(
            ofType: CIDetectorTypeQRCode,
            context: context,
            options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])!
        let features = detector.features(in: ciImage)
        for feature in features {
            let codeFeature = feature as! CIQRCodeFeature
            CXLogger.log(level: .info, message: "CodeFeature messageString: \(codeFeature.messageString ?? "")")
        }
        let codeFeature = features.first as! CIQRCodeFeature
        return codeFeature.messageString
    }
    
    /// Extracts a color object from the specified rectangle.
    ///
    /// - Parameters:
    ///   - rect: The rectangle to extract.
    ///   - alpha: The opacity value of the color object.
    /// - Returns: A color object.
    @objc public func cx_extractColor(inRect rect: CGRect, alpha: CGFloat = 0) -> UIColor {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var pixelData: [UInt8] = [0, 0, 0, 0]
        
        pixelData.withUnsafeMutableBytes { pointer in
            if let context = CGContext(data: pointer.baseAddress, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue), let cgImage = self.cgImage {
                context.draw(cgImage, in: rect)
            }
        }
        
        let red = CGFloat(pixelData[0]) / CGFloat(255.0)
        let green = CGFloat(pixelData[1]) / CGFloat(255.0)
        let blue = CGFloat(pixelData[2]) / CGFloat(255.0)
        let alpha_ = CGFloat(pixelData[3]) / CGFloat(255.0)
        
        let _alpha_ = (alpha <= 0 || alpha > 1) ? alpha_ : alpha
        if #available(iOS 10.0, *) {
            return UIColor(displayP3Red: red, green: green, blue: blue, alpha: _alpha_)
        } else {
            return UIColor(red: red, green: green, blue: blue, alpha: _alpha_)
        }
    }
    
    /// Draws an image with a given color and blend mode.
    ///
    /// - Parameters:
    ///   - color: A color object to draw.
    ///   - opaque: Indicates whether the bitmap is opaque.
    ///   - blendMode: Compositing operations for images.
    /// - Returns: A new image.
    @objc public func cx_drawImage(withColor color: UIColor, opaque: Bool = false, blendMode: CGBlendMode = .normal) -> UIImage
    {
        guard let cgImage = self.cgImage
        else {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, opaque, self.scale)
        guard let context = UIGraphicsGetCurrentContext()
        else {
            UIGraphicsEndImageContext()
            return self
        }
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(blendMode)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: cgImage)
        color.setFill()
        context.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
    
    /// Renders an image with a given color.
    ///
    /// - Parameter color: A color object to render.
    /// - Returns: A new image.
    @objc public func cx_renderImage(withColor color: UIColor) -> UIImage
    {
        if #available(iOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
            format.scale = self.scale
            let renderer = UIGraphicsImageRenderer(size: self.size, format: format)
            return renderer.image { context in
                color.setFill()
                context.fill(CGRect(origin: .zero, size: self.size))
            }
        }
        return self.cx_drawImage(withColor: color, opaque: false, blendMode: .normal)
    }
    
    /// Scales the image to the specified size.
    ///
    /// - Parameters:
    ///   - size: The size to specify.
    ///   - opaque: Flag indicating whether the bitmap is opaque.
    /// - Returns: An optional image.
    @objc public func cx_scale(toSize size: CGSize, opaque: Bool = false) -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(size, opaque, self.scale)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Scales the image to height with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - height: The height to scale.
    ///   - opaque: Flag indicating whether the bitmap is opaque.
    /// - Returns: An optional image.
    @objc public func cx_scale(toHeight height: CGFloat, opaque: Bool = false) -> UIImage?
    {
        let scale = height / size.height
        let width = size.width * scale
        let rect  = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(rect.size, opaque, self.scale)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Scales the image to width with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - width: The width to scale.
    ///   - opaque: Flag indicating whether the bitmap is opaque.
    /// - Returns: An optional image.
    @objc public func cx_scale(toWidth width: CGFloat, opaque: Bool = false) -> UIImage?
    {
        let scale  = width / size.width
        let height = size.height * scale
        let rect   = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(rect.size, opaque, self.scale)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Returns a new image object with the specified cap insets and tile resizing mode.
    ///
    /// - Parameter capInsets: The values to use for the cap insets.
    /// - Returns: A new image object with the specified cap insets and tile resizing mode.
    @objc public func cx_tile(withCapInsets capInsets: UIEdgeInsets) -> UIImage
    {
        return self.resizableImage(withCapInsets: capInsets, resizingMode: .tile)
    }
    
    /// Returns a new image object with the specified cap insets and stretch resizing mode.
    ///
    /// - Parameter capInsets: The values to use for the cap insets.
    /// - Returns: A new image object with the specified cap insets and stretch resizing mode.
    @objc public func cx_stretch(withCapInsets capInsets: UIEdgeInsets = .zero) -> UIImage
    {
        var _capInsets = capInsets
        if _capInsets == .zero {
            // 1x1 pixels.
            let top = self.size.height/2 - 0.5
            let left = self.size.width/2 - 0.5
            _capInsets = UIEdgeInsets.init(top: top , left: left, bottom: top, right: left)
        }
        return self.resizableImage(withCapInsets: _capInsets, resizingMode: .stretch)
    }
    
    /// Returns a compressed image from original image with a given quality value.
    ///
    /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality). default is 0.5.
    /// - Returns: An optional image.
    @objc public func cx_compress(withQuality quality: CGFloat = 0.5) -> UIImage?
    {
        guard let data = self.jpegData(compressionQuality: quality)
        else {
            return nil
        }
        return UIImage(data: data)
    }
    
    /// Returns a compressed image data from original image with a given quality value.
    ///
    /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality). default is 0.5.
    /// - Returns: An optional data.
    @objc public func cx_compressedData(withQuality quality: CGFloat = 0.5) -> Data?
    {
        return self.jpegData(compressionQuality: quality)
    }
    
    /// Crops an image to the specified rectangle.
    ///
    /// - Parameter rect: A rectangle specifying the portion of the image to keep.
    /// - Returns: A cropped image.
    @objc public func cx_cropping(toRect rect: CGRect) -> UIImage
    {
        guard rect.size.width <= self.size.width &&
              rect.size.height <= self.size.height
        else {
            return self
        }
        let scaledRect = rect.applying(CGAffineTransform(scaleX: self.scale, y: self.scale))
        guard let image = self.cgImage?.cropping(to: scaledRect)
        else {
            return self
        }
        return UIImage(cgImage: image, scale: self.scale, orientation: self.imageOrientation)
    }
    
    /// Crops an image to the specified rectangle.
    ///
    /// - Parameters:
    ///   - cropRect: A rectangle specifying the portion of the image to keep.
    ///   - viewWidth: The width for the view.
    ///   - viewHeight: The height for the view.
    /// - Returns: A cropped image.
    @objc public func cx_crop(toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage
    {
        let imageViewScale = max(self.size.width / viewWidth,
                                 self.size.height / viewHeight)
        
        // Scale cropRect to handle images larger than shown-on-screen size
        let cropZone = CGRect(x: cropRect.origin.x * imageViewScale,
                              y: cropRect.origin.y * imageViewScale,
                              width: cropRect.size.width * imageViewScale,
                              height: cropRect.size.height * imageViewScale)
        
        // Perform cropping in Core Graphics
        guard let cutImageRef = self.cgImage?.cropping(to: cropZone)
        else {
            return self
        }
        
        // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }
    
    /// Creates a copy of the receiver rotated by the given angle (in radians).
    ///   // Rotate the image by 180°
    ///   image.rotated(by: .pi)
    ///
    /// - Parameter angle: The angle, in radians, by which to rotate the image.
    /// - Returns: A new image rotated by the given angle.
    @objc public func cx_rotateBy(angle: CGFloat) -> UIImage?
    {
        let destRect = CGRect(origin: .zero, size: self.size)
            .applying(CGAffineTransform(rotationAngle: angle))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())
        
        UIGraphicsBeginImageContext(roundedDestRect.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        context.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        context.rotate(by: angle)
        
        self.draw(in: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    ///  Creates a copy of the receiver rotated by the given angle.
    ///   // Rotate the image by 180°
    ///   image.rotated(by: Measurement(value: 180, unit: .degrees))
    ///
    /// - Parameter unitAngle: The angle measurement by which to rotate the image.
    /// - Returns: A new image rotated by the given angle.
    @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    @objc public func cx_rotateBy(unitAngle: Measurement<UnitAngle>) -> UIImage?
    {
        let radians = CGFloat(unitAngle.converted(to: .radians).value)
        return self.cx_rotateBy(angle: radians)
    }
    
    /// Returns an image with .alwaysOriginal rendering mode.
    @objc public var cx_original: UIImage
    {
        return self.withRenderingMode(.alwaysOriginal)
    }
    
    /// Returns an image with .alwaysTemplate rendering mode.
    @objc public var cx_template: UIImage
    {
        return self.withRenderingMode(.alwaysTemplate)
    }
    
    /// Returns the size in bytes of the image.
    @objc public var cx_bytesSize: Int
    {
        return self.cx_compressedData(withQuality: 1)?.count ?? 0
    }
    
    /// Returns the size in kilo bytes of the image.
    @objc public var cx_kilobytesSize: Int
    {
        return self.cx_bytesSize / 1024
    }
    
}

#endif
