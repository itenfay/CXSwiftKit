//
//  UIView+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if canImport(UIKit)
import UIKit
#if canImport(QuartzCore)
import QuartzCore
#endif

extension CXSwiftBase where T : UIView {
    
    /// The y-coordinate of the point that specifies the coordinates of the rectangle’s origin.
    public var top: CGFloat {
        get {
            return self.base.cx_top
        }
        set {
            self.base.cx_top = newValue
        }
    }
    
    /// The y-coordinate of the point that specifies the coordinates of the rectangle’s origin.
    public var y: CGFloat {
        get {
            return self.base.cx_y
        }
        set (ny) {
            self.base.cx_y = ny
        }
    }
    
    /// The x-coordinate of the point that specifies the coordinates of the rectangle’s origin.
    public var left: CGFloat {
        get {
            return self.base.cx_left
        }
        set {
            self.base.cx_left = newValue
        }
    }
    
    /// The x-coordinate of the point that specifies the coordinates of the rectangle’s origin.
    public var x: CGFloat {
        get {
            return self.base.cx_x
        }
        set {
            self.base.cx_x = newValue
        }
    }
    
    /// The bottom x-coordinate of the coordinates of the rectangle’s origin.
    public var bottom: CGFloat {
        get {
            return self.base.cx_bottom
        }
        set {
            self.base.cx_bottom = newValue
        }
    }
    
    /// The right x-coordinate of the coordinates of the rectangle’s origin.
    public var right: CGFloat {
        get {
            return self.base.cx_right
        }
        set {
            self.base.cx_right = newValue
        }
    }
    
    /// A value that specifies the width of the view's frame rectangle.
    public var width: CGFloat {
        get {
            return self.base.cx_width
        }
        set {
            self.base.cx_width = newValue
        }
    }
    
    /// A value that specifies the height of the view's frame rectangle.
    public var height: CGFloat {
        get {
            return self.base.cx_height
        }
        set {
            self.base.cx_height = newValue
        }
    }
    
    /// The x-coordinate of the center point of the view's frame rectangle.
    public var centerX: CGFloat {
        get {
            return self.base.cx_centerX
        }
        set {
            self.base.cx_centerX = newValue
        }
    }
    
    /// The y-coordinate of the center point of the view's frame rectangle.
    public var centerY: CGFloat {
        get {
            return self.base.cx_centerY
        }
        set {
            self.base.cx_centerY = newValue
        }
    }
    
    /// A point that specifies the coordinates of the rectangle’s origin.
    public var origin: CGPoint {
        get {
            return self.base.cx_origin
        }
        set {
            self.base.cx_origin = newValue
        }
    }
    
    /// A size that specifies the height and width of the rectangle.
    public var size: CGSize {
        get {
            return self.base.cx_size
        }
        set {
            self.base.cx_size = newValue
        }
    }
    
    /// The corner radius of the view, also inspectable from Storyboard or Xib.
    public var cornerRadius: CGFloat
    {
        get {
            return self.base.cx_cornerRadius
        }
        set {
            self.base.cx_cornerRadius = newValue
        }
    }
    
    /// Indicates whether sublayers are clipped to the layer’s bounds, also inspectable from Storyboard or Xib.
    public var masksToBounds: Bool
    {
        get {
            return self.base.cx_masksToBounds
        }
        set {
            self.base.cx_masksToBounds = newValue
        }
    }
    
    /// The border color of the view, also inspectable from Storyboard or Xib.
    public var borderColor: UIColor?
    {
        get {
            return self.base.cx_borderColor
        }
        set {
            self.base.cx_borderColor = newValue
        }
    }
    
    /// The border width of the view, also inspectable from Storyboard or Xib.
    public var borderWidth: CGFloat
    {
        get {
            return self.base.cx_borderWidth
        }
        set {
            self.base.cx_borderWidth = newValue
        }
    }
    
    /// Draws a straight line segment from the start point to the end point.
    ///
    /// - Parameters:
    ///   - startPoint: The point, in user space coordinates, at which to start a new subpath.
    ///   - endPoint: The location, in user space coordinates, for the end of the new line segment.
    ///   - color: The color used to draw line.
    ///   - lineWidth: The line width that specifies.
    ///   - lineCap: The line cap style that specifies.
    ///   - lineJoin: The line join style that specifies.
    ///   - lineDashPattern: The line dash pattern applied to draw line.
    public func drawLine(
        startPoint: CGPoint,
        endPoint: CGPoint,
        color: UIColor,
        lineWidth: CGFloat,
        lineCap: CAShapeLayerLineCap = .butt,
        lineJoin: CAShapeLayerLineJoin = .miter,
        lineDashPattern: [NSNumber]? = nil)
    {
        self.base.cx_drawLine(startPoint: startPoint, endPoint: endPoint, color: color, lineWidth: lineWidth, lineCap: lineCap, lineJoin: lineJoin, lineDashPattern: lineDashPattern)
    }
    
    /// Draws a color gradient over its background color, filling the shape of the layer (including rounded corners)
    ///
    /// - Parameters:
    ///   - colors: An array of color objects defining the color of each gradient stop.
    ///   - startPoint: The start point of the gradient when drawn in the layer’s coordinate space.
    ///   - endPoint: The end point of the gradient when drawn in the layer’s coordinate space.
    ///   - cornerRadius: The radius to use when drawing rounded corners for the layer’s background.
    public func addGradientLayer(
        withColors colors: [UIColor],
        startPoint: CGPoint = .init(x: 0.5, y: 0.5),
        endPoint: CGPoint = .init(x: 0.5, y: 1),
        cornerRadius: CGFloat = 0)
    {
        self.base.cx_addGradientLayer(withColors: colors, startPoint: startPoint, endPoint: endPoint, cornerRadius: cornerRadius)
    }
    
    /// Adds the shadow for the view.
    ///
    /// - Parameters:
    ///   - color: The color of the shadow.
    ///   - opacity: The opacity of the shadow.
    ///   - offset: he offset of the shadow.
    ///   - path: A new path object with the rectangular path.
    public func addShadow(withColor color: UIColor?, opacity: Float, offset: CGSize, path: UIBezierPath)
    {
        self.base.cx_addShadow(withColor: color, opacity: opacity, offset: offset, path: path)
    }
    
    /// Adds the shadow for the view.
    ///
    /// - Parameters:
    ///   - color: The color of the shadow.
    ///   - opacity: The opacity of the shadow.
    ///   - offset: The offset of the shadow.
    public func addShadow(withColor color: UIColor?, opacity: Float, offset: CGSize)
    {
        self.base.cx_addShadow(withColor: color, opacity: opacity, offset: offset)
    }
    
    /// Adds the shadow for the view.
    ///
    /// - Parameters:
    ///   - color: The color of the shadow.
    ///   - opacity: The opacity of the shadow.
    ///   - offset: The offset of the shadow.
    ///   - roundedCorners: The rounded corners of the shadow.
    ///   - cornerRadius: The radius of each corner oval.
    public func addShadow(
        withColor color: UIColor?,
        opacity: Float,
        offset: CGSize,
        roundedCorners: UIRectCorner = .allCorners,
        cornerRadius: CGFloat)
    {
        self.base.cx_addShadow(withColor: color, opacity: opacity, offset: offset, roundedCorners: roundedCorners, cornerRadius: cornerRadius)
    }
    
    /// Clips corners by the corner radius.
    ///
    /// - Parameter radius: The radius of each corner oval. Values larger than half the rectangle’s width or height are clamped appropriately to half the width or height.
    public func clipCorners(byRadius radius: CGFloat)
    {
        self.base.cx_clipCorners(byRadius: radius)
    }
    
    /// Clips corners by the corner radius and the specified corners that you want rounded.
    ///
    /// - Parameters:
    ///   - radius: The radius of each corner oval. Values larger than half the rectangle’s width or height are clamped appropriately to half the width or height.
    ///   - rectCorner: A bitmask value that identifies the corners that you want rounded.
    public func clipCorners(byRadius radius: CGFloat, roundedCorners: UIRectCorner)
    {
        self.base.cx_clipCorners(byRadius: radius, roundedCorners: roundedCorners)
    }
    
}

//MARK: - Layout

extension UIView {
    
    /// The y-coordinate of the point that specifies the coordinates of the rectangle’s origin.
    @objc public var cx_top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    /// The y-coordinate of the point that specifies the coordinates of the rectangle’s origin.
    @objc public var cx_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set (newY) {
            var frame = self.frame
            frame.origin.y = newY
            self.frame = frame
        }
    }
    
    /// The x-coordinate of the point that specifies the coordinates of the rectangle’s origin.
    @objc public var cx_left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    /// The x-coordinate of the point that specifies the coordinates of the rectangle’s origin.
    @objc public var cx_x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    /// The bottom x-coordinate of the coordinates of the rectangle’s origin.
    @objc public var cx_bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
    }
    
    /// The right x-coordinate of the coordinates of the rectangle’s origin.
    @objc public var cx_right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
    }
    
    /// A value that specifies the width of the view's frame rectangle.
    @objc public var cx_width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    /// A value that specifies the height of the view's frame rectangle.
    @objc public var cx_height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    /// The x-coordinate of the center point of the view's frame rectangle.
    @objc public var cx_centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint.init(x: newValue, y: self.center.y)
        }
    }
    
    /// The y-coordinate of the center point of the view's frame rectangle.
    @objc public var cx_centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint.init(x: self.center.x, y: newValue)
        }
    }
    
    /// A point that specifies the coordinates of the rectangle’s origin.
    @objc public var cx_origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    /// A size that specifies the height and width of the rectangle.
    @objc public var cx_size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
}

//MARK: - Layer

#if canImport(QuartzCore)

extension UIView {
    
    /// The corner radius of the view, also inspectable from Storyboard or Xib.
    @IBInspectable @objc public var cx_cornerRadius: CGFloat
    {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = abs(newValue)
        }
    }
    
    /// Indicates whether sublayers are clipped to the layer’s bounds, also inspectable from Storyboard or Xib.
    @IBInspectable @objc public var cx_masksToBounds: Bool
    {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    /// The border color of the view, also inspectable from Storyboard or Xib.
    @IBInspectable @objc public var cx_borderColor: UIColor?
    {
        get {
            guard let cgColor = layer.borderColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }
    
    /// The border width of the view, also inspectable from Storyboard or Xib.
    @IBInspectable @objc public var cx_borderWidth: CGFloat
    {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    /// Draws a straight line segment from the start point to the end point.
    ///
    /// - Parameters:
    ///   - startPoint: The point, in user space coordinates, at which to start a new subpath.
    ///   - endPoint: The location, in user space coordinates, for the end of the new line segment.
    ///   - color: The color used to draw line.
    ///   - lineWidth: The line width that specifies.
    ///   - lineCap: The line cap style that specifies.
    ///   - lineJoin: The line join style that specifies.
    ///   - lineDashPattern: The line dash pattern applied to draw line.
    @objc public func cx_drawLine(
        startPoint: CGPoint,
        endPoint: CGPoint,
        color: UIColor,
        lineWidth: CGFloat,
        lineCap: CAShapeLayerLineCap = .butt,
        lineJoin: CAShapeLayerLineJoin = .miter,
        lineDashPattern: [NSNumber]? = nil)
    {
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = lineCap
        shapeLayer.lineJoin = lineJoin
        shapeLayer.lineDashPattern = lineDashPattern
        
        let path = CGMutablePath.init()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        //path.addLines(between: [startPoint, endPoint])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    /// Draws a color gradient over its background color, filling the shape of the layer (including rounded corners)
    ///
    /// - Parameters:
    ///   - colors: An array of color objects defining the color of each gradient stop.
    ///   - startPoint: The start point of the gradient when drawn in the layer’s coordinate space.
    ///   - endPoint: The end point of the gradient when drawn in the layer’s coordinate space.
    ///   - cornerRadius: The radius to use when drawing rounded corners for the layer’s background.
    @objc public func cx_addGradientLayer(
        withColors colors: [UIColor],
        startPoint: CGPoint = .init(x: 0.5, y: 0.5),
        endPoint: CGPoint = .init(x: 0.5, y: 1),
        cornerRadius: CGFloat = 0)
    {
        setNeedsLayout()
        layoutIfNeeded()
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map{ $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        if cornerRadius > 0 {
            gradientLayer.cornerRadius = cornerRadius
        }
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// Adds the shadow for the view.
    ///
    /// - Parameters:
    ///   - color: The color of the shadow.
    ///   - opacity: The opacity of the shadow.
    ///   - offset: he offset of the shadow.
    ///   - path: A new path object with the rectangular path.
    @objc public func cx_addShadow(withColor color: UIColor?, opacity: Float, offset: CGSize, path: UIBezierPath)
    {
        guard let aColor = color else {
            return
        }
        layer.masksToBounds = false
        layer.shadowColor = aColor.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowPath = path.cgPath
    }
    
    /// Adds the shadow for the view.
    ///
    /// - Parameters:
    ///   - color: The color of the shadow.
    ///   - opacity: The opacity of the shadow.
    ///   - offset: The offset of the shadow.
    @objc public func cx_addShadow(withColor color: UIColor?, opacity: Float, offset: CGSize)
    {
        guard let aColor = color else {
            return
        }
        setNeedsLayout()
        layoutIfNeeded()
        let path = UIBezierPath(rect: self.bounds)
        cx_addShadow(withColor: aColor, opacity: opacity, offset: offset, path: path)
    }
    
    /// Adds the shadow for the view.
    ///
    /// - Parameters:
    ///   - color: The color of the shadow.
    ///   - opacity: The opacity of the shadow.
    ///   - offset: The offset of the shadow.
    ///   - roundedCorners: The rounded corners of the shadow.
    ///   - cornerRadius: The radius of each corner oval.
    @objc public func cx_addShadow(
        withColor color: UIColor?,
        opacity: Float,
        offset: CGSize,
        roundedCorners: UIRectCorner = .allCorners,
        cornerRadius: CGFloat)
    {
        guard let aColor = color else {
            return
        }
        setNeedsLayout()
        layoutIfNeeded()
        
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let path = UIBezierPath.init(
            roundedRect: self.bounds,
            byRoundingCorners: roundedCorners,
            cornerRadii: size)
        
        cx_addShadow(withColor: aColor, opacity: opacity, offset: offset, path: path)
    }
    
    /// Clips corners by the corner radius.
    ///
    /// - Parameter radius: The radius of each corner oval. Values larger than half the rectangle’s width or height are clamped appropriately to half the width or height.
    @objc public func cx_clipCorners(byRadius radius: CGFloat)
    {
        cx_clipCorners(byRadius: radius, roundedCorners: .allCorners)
    }
    
    /// Clips corners by the corner radius and the specified corners that you want rounded.
    ///
    /// - Parameters:
    ///   - radius: The radius of each corner oval. Values larger than half the rectangle’s width or height are clamped appropriately to half the width or height.
    ///   - rectCorner: A bitmask value that identifies the corners that you want rounded.
    @objc public func cx_clipCorners(byRadius radius: CGFloat, roundedCorners: UIRectCorner)
    {
        setNeedsLayout()
        layoutIfNeeded()
        
        let path = UIBezierPath.init(
            roundedRect: bounds,
            byRoundingCorners: roundedCorners,
            cornerRadii: CGSize.init(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = bounds
        maskLayer.path = path.cgPath
        
        layer.mask = maskLayer
    }
    
}

#endif

#endif
