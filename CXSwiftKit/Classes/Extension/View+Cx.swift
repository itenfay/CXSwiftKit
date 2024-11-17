//
//  View+Cx.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2022/11/14.
//

#if os(iOS) || os(tvOS) || os(macOS)
#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

extension CXSwiftBase where T : CXView {
    
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
    
    #if !os(macOS)
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
    #endif
    
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
    public var borderColor: CXColor?
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
        startPoint: CXPoint,
        endPoint: CXPoint,
        color: CXColor,
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
        withColors colors: [CXColor],
        startPoint: CXPoint = .init(x: 0.5, y: 0.5),
        endPoint: CXPoint = .init(x: 0.5, y: 1),
        cornerRadius: CGFloat = 0)
    {
        self.base.cx_addGradientLayer(withColors: colors, startPoint: startPoint, endPoint: endPoint, cornerRadius: cornerRadius)
    }
    
    #if os(iOS) || os(tvOS)
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
    
    /// Return an optional snapshot image by the specified rectangle.
    public var screenshot: UIImage?
    {
        return base.cx_screenshot
    }
    
    /// Return a snapshot image by the specified rectangle.
    ///
    /// - Parameter rect: A rectangle specified in the local coordinate system (bounds) of the view.
    /// - Returns: An optional image.
    public func snapshot(byRect rect: CGRect) -> UIImage?
    {
        return self.base.cx_snapshot(byRect: rect)
    }
    
    /// Renders an image with the view.
    ///
    /// - Returns: An image.
    public func renderImage() -> UIImage
    {
        return self.base.cx_renderImage()
    }
    
    /// Represents whether is the identity transform.
    public var isIdentity: Bool
    {
        return self.base.cx_isIdentity
    }
    
    /// Keeps the original identity transform.
    ///
    /// - Parameters:
    ///   - duration: The total duration of the animations, measured in seconds.
    ///   If you specify a negative value or 0, the changes are made without animating them.
    ///   - delay: The amount of time (measured in seconds) to wait before beginning the animations.
    ///   Specify a value of 0 to begin the animations immediately.
    ///   - animated: The boolean value represents whether want to animate.
    ///   - completion: A block object to may be executed when the functions ends.
    public func keepIdentity(
        withDuration duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        animated: Bool = true,
        completion: (() -> Void)? = nil)
    {
        self.base.cx_keepIdentity(withDuration: duration, delay: delay, animated: animated, completion: completion)
    }
    
    /// Translates the view to the specified coordinate.
    ///
    /// - Parameters:
    ///   - tx: The value by which to move the x-axis of the coordinate system.
    ///   - ty: The value by which to move the y-axis of the coordinate system.
    ///   - duration: The total duration of the animations, measured in seconds.
    ///   If you specify a negative value or 0, the changes are made without animating them.
    ///   - delay: The amount of time (measured in seconds) to wait before beginning the animations.
    ///   Specify a value of 0 to begin the animations immediately.
    ///   - animated: The boolean value represents whether want to animate.
    ///   - completion: A block object to may be executed when the translation ends.
    public func translate(
        withTx tx: CGFloat,
        ty: CGFloat,
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        animated: Bool = true,
        completion: (() -> Void)? = nil)
    {
        self.base.cx_translate(withTx: tx, ty: ty, duration: duration, delay: delay, animated: animated, completion: completion)
    }
    
    /// Rotates the view to the affine transformation matrix.
    ///
    /// - Parameters:
    ///   - angle: The angle, in radians, by which this matrix rotates the coordinate system axes.
    ///   - duration: The total duration of the animations, measured in seconds.
    ///   - delay: The amount of time (measured in seconds) to wait before beginning the animations.
    ///   Specify a value of 0 to begin the animations immediately.
    ///   - animated: The boolean value represents whether want to animate.
    ///   - completion: A block object to may be executed when the rotation ends.
    public func rotate(
        withAngle angle: CGFloat = CGFloat.pi/2,
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        animated: Bool = true,
        completion: (() -> Void)? = nil)
    {
        self.base.cx_rotate(withAngle: angle, duration: duration, delay: delay, animated: animated, completion: completion)
    }
    
    /// Scales the view to the affine transformation matrix.
    ///
    /// - Parameters:
    ///   - sx: The factor by which to scale the x-axis of the coordinate system.
    ///   - sy: The factor by which to scale the y-axis of the coordinate system.
    ///   - duration: The total duration of the animations, measured in seconds.
    ///   - delay: The amount of time (measured in seconds) to wait before beginning the animations.
    ///   Specify a value of 0 to begin the animations immediately.
    ///   - animated: The boolean value represents whether want to animate.
    ///   - completion: A block object to may be executed when the rotation ends.
    public func scale(
        withSx sx: CGFloat,
        sy: CGFloat,
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        animated: Bool = true,
        completion: (() -> Void)? = nil)
    {
        self.base.cx_scale(withSx: sx, sy: sy, duration: duration, delay: delay, animated: animated, completion: completion)
    }
    
    /// Exchanges the subviews at the specified indices with the flip transition.
    public func flip(from fromView: UIView, to toView: UIView, duration: TimeInterval, repeatCount: Int = 1, completion: @escaping () -> Void)
    {
        self.base.cx_flip(from: fromView, to: toView, duration: duration, repeatCount: repeatCount, completion: completion)
    }
    
    /// Finds the first responder recursively.
    public var firstResponder: UIView?
    {
        return self.base.cx_firstResponder
    }
    
    /// Checks if view is in RTL format.
    public var isRightToLeft: Bool
    {
        return self.base.cx_isRightToLeft
    }
    
    /// Draws a quad curve for a view with the radian, radian and fill color.
    public func drawQuadCurve(withRadian radian: CGFloat, direction: CXViewRadianDirection = .bottom, fillColor: CXColor? = nil)
    {
        self.base.cx_drawQuadCurve(withRadian: radian, direction: direction, fillColor: fillColor)
    }
    
    /// Returns the smallest possible size of the view based on its current constraints.
    public var layoutSizeFittingSize: CGSize
    {
        return self.base.cx_layoutSizeFittingSize
    }
    
    /// Returns the optimal size of the view based on its current constraints.
    public func layoutSizeFitting(size targetSize: CGSize) -> CGSize
    {
        return self.base.cx_layoutSizeFitting(size: targetSize)
    }
    
    /// Returns the optimal size of the view based on its constraints and the specified fitting priorities.
    public func layoutSizeFitting(size targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize
    {
        return self.base.cx_layoutSizeFitting(size: targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
    
    /// Sets background image for view.
    public func setBackgroundImage(_ image: UIImage) {
        self.base.cx_setBackgroundImage(image)
    }
    
    /// Animates for updating constraints.
    ///
    /// - Parameter duration: The total duration of the animations, measured in seconds.
    public func animateForUpdatingConstraints(_ duration: TimeInterval = 0.3) {
        self.base.cx_animateForUpdatingConstraints(duration)
    }
    #endif
    
    /// Returns the receiver’s immediate subviews.
    public var children: [CXView]
    {
        return self.base.cx_children
    }
    
    /// Returns the receiver’s recursive subviews.
    public var recursiveSubviews: [CXView]
    {
        return self.base.cx_recursiveSubviews
    }
    
    /// Adds the subviews.
    public func add(subviews: CXView...) {
        subviews.forEach(self.base.addSubview)
    }
    
    /// Adds the subviews.
    public func addSubViews(_ views: [CXView]) {
        self.base.cx_addSubViews(views)
    }
    
    /// Constrains itself to view.
    public func constrain(to view: CXView) {
        self.base.cx_constrain(to: view)
    }
    
    /// Returns view's parent view controller.
    public var parentViewController: CXViewController? {
        return self.base.cx_parentViewController
    }
    
    #if !os(watchOS) && canImport(UIKit)
    public func makeConstraints(maker: @escaping (CXConstraintMaker) -> Void)
    {
        self.base.cx_makeConstraints(maker: maker)
    }
    
    public func remakeConstraints(maker: @escaping (CXConstraintMaker) -> Void)
    {
        base.cx_remakeConstraints(maker: maker)
    }
    
    public func removeConstraints()
    {
        base.cx_removeConstraints()
    }
    
    /// The insets that you use to determine the safe area for this view.
    public var safeAreaInsets: CXEdgeInsets
    {
        self.base.cx_safeAreaInsets // return
    }
    
    public var safeTopAnchor: NSLayoutYAxisAnchor
    {
        return self.base.cx_safeTopAnchor
    }
    
    public var safeLeadingAnchor: NSLayoutXAxisAnchor
    {
        return self.base.cx_safeLeadingAnchor
    }
    
    public var safeBottomAnchor: NSLayoutYAxisAnchor
    {
        return self.base.cx_safeBottomAnchor
    }
    
    public var safeTrailingAnchor: NSLayoutXAxisAnchor
    {
        return self.base.cx_safeTrailingAnchor
    }
    
    public var safeCenterXAnchor: NSLayoutXAxisAnchor
    {
        return self.base.cx_safeCenterXAnchor
    }
    
    public var safeCenterYAnchor: NSLayoutYAxisAnchor
    {
        return self.base.cx_safeCenterYAnchor
    }
    
    public var safeWidthAnchor: NSLayoutDimension
    {
        return self.base.cx_safeWidthAnchor
    }
    
    public var safeHeightAnchor: NSLayoutDimension
    {
        return self.base.cx_safeHeightAnchor
    }
    #endif
}

//MARK: - Layout

extension CXView {
    
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
    
    #if !os(macOS)
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
    #endif
    
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

extension CXView {
    
    fileprivate var mLayer: CALayer? {
        return layer
    }
    
    /// The corner radius of the view, also inspectable from Storyboard or Xib.
    @IBInspectable @objc public var cx_cornerRadius: CGFloat
    {
        get {
            return mLayer?.cornerRadius ?? 0
        }
        set {
            mLayer?.cornerRadius = abs(newValue)
        }
    }
    
    /// Indicates whether sublayers are clipped to the layer’s bounds, also inspectable from Storyboard or Xib.
    @IBInspectable @objc public var cx_masksToBounds: Bool
    {
        get {
            return mLayer?.masksToBounds ?? false
        }
        set {
            mLayer?.masksToBounds = newValue
        }
    }
    
    /// The border color of the view, also inspectable from Storyboard or Xib.
    @IBInspectable @objc public var cx_borderColor: CXColor?
    {
        get {
            guard let cgColor = mLayer?.borderColor else { return nil }
            return CXColor(cgColor: cgColor)
        }
        set {
            guard let color = newValue else {
                mLayer?.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            mLayer?.borderColor = color.cgColor
        }
    }
    
    /// The border width of the view, also inspectable from Storyboard or Xib.
    @IBInspectable @objc public var cx_borderWidth: CGFloat
    {
        get {
            return mLayer?.borderWidth ?? 0
        }
        set {
            mLayer?.borderWidth = newValue
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
        startPoint: CXPoint,
        endPoint: CXPoint,
        color: CXColor,
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
        mLayer?.addSublayer(shapeLayer)
    }
    
    /// Draws a color gradient over its background color, filling the shape of the layer (including rounded corners)
    ///
    /// - Parameters:
    ///   - colors: An array of color objects defining the color of each gradient stop.
    ///   - startPoint: The start point of the gradient when drawn in the layer’s coordinate space.
    ///   - endPoint: The end point of the gradient when drawn in the layer’s coordinate space.
    ///   - cornerRadius: The radius to use when drawing rounded corners for the layer’s background.
    @objc public func cx_addGradientLayer(
        withColors colors: [CXColor],
        startPoint: CXPoint = .init(x: 0.5, y: 0.5),
        endPoint: CXPoint = .init(x: 0.5, y: 1),
        cornerRadius: CGFloat = 0)
    {
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map{ $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        if cornerRadius > 0 {
            gradientLayer.cornerRadius = cornerRadius
        }
        
        mLayer?.insertSublayer(gradientLayer, at: 0)
    }
    
}

extension CXView {
    
    @objc public convenience init(parent: CXView) {
        self.init(frame: parent.bounds)
        parent.addSubview(self)
    }
    
}

#if os(iOS) || os(tvOS)
extension UIView {
    
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

extension UIView {
    
    /// Return an optional screenshot image by the specified rectangle.
    @objc public var cx_screenshot: UIImage?
    {
        return cx_snapshot(byRect: bounds)
    }
    
    /// Return a snapshot image by the specified rectangle.
    ///
    /// - Parameter rect: A rectangle specified in the local coordinate system (bounds) of the view.
    /// - Returns: An optional image.
    @objc public func cx_snapshot(byRect rect: CGRect) -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        
        //guard let ctx = UIGraphicsGetCurrentContext()
        //else { return nil }
        // Renders the layer and its sublayers into the specified context.
        //layer.render(in: ctx)
        
        // Renders a snapshot of the complete view hierarchy as visible onscreen into the current context.
        drawHierarchy(in: rect, afterScreenUpdates: true)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage
    }
    
    /// Renders an image with the view.
    ///
    /// - Returns: An image.
    @objc public func cx_renderImage() -> UIImage
    {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { ctx in
            self.layer.render(in: ctx.cgContext)
        }
    }
    
    /// Represents whether is the identity transform.
    @objc public var cx_isIdentity: Bool
    {
        return transform == .identity
    }
    
    /// Keeps the original identity transform.
    ///
    /// - Parameters:
    ///   - duration: The total duration of the animations, measured in seconds.
    ///   If you specify a negative value or 0, the changes are made without animating them.
    ///   - delay: The amount of time (measured in seconds) to wait before beginning the animations.
    ///   Specify a value of 0 to begin the animations immediately.
    ///   - animated: The boolean value represents whether want to animate.
    ///   - completion: A block object to may be executed when the functions ends.
    @objc public func cx_keepIdentity(
        withDuration duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        animated: Bool = true,
        completion: (() -> Void)? = nil)
    {
        if animated {
            UIView.animate(withDuration: duration, delay: delay, options: []) {
                self.transform = CGAffineTransform.identity
            } completion: { finished in
                if finished { completion?() }
            }
        } else {
            if delay > 0 {
                DispatchQueue.cx.mainAsyncAfter(delay) {
                    self.transform = CGAffineTransform.identity
                    completion?()
                }
            } else {
                transform = .identity
                completion?()
            }
        }
    }
    
    /// Translates the view to the specified coordinate.
    ///
    /// - Parameters:
    ///   - tx: The value by which to move the x-axis of the coordinate system.
    ///   - ty: The value by which to move the y-axis of the coordinate system.
    ///   - duration: The total duration of the animations, measured in seconds.
    ///   If you specify a negative value or 0, the changes are made without animating them.
    ///   - delay: The amount of time (measured in seconds) to wait before beginning the animations.
    ///   Specify a value of 0 to begin the animations immediately.
    ///   - animated: The boolean value represents whether want to animate.
    ///   - completion: A block object to may be executed when the translation ends.
    @objc public func cx_translate(
        withTx tx: CGFloat,
        ty: CGFloat,
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        animated: Bool = true,
        completion: (() -> Void)? = nil)
    {
        if animated {
            UIView.animate(withDuration: duration, delay: delay, options: []) {
                self.transform = CGAffineTransform(translationX: tx, y: ty)
            } completion: { finished in
                if finished { completion?() }
            }
        } else {
            if delay > 0 {
                DispatchQueue.cx.mainAsyncAfter(delay) {
                    self.transform = CGAffineTransform(translationX: tx, y: ty)
                    completion?()
                }
            } else {
                transform = CGAffineTransform(translationX: tx, y: ty)
                completion?()
            }
        }
    }
    
    /// Rotates the view to the affine transformation matrix.
    ///
    /// - Parameters:
    ///   - angle: The angle, in radians, by which this matrix rotates the coordinate system axes.
    ///   - duration: The total duration of the animations, measured in seconds.
    ///   - delay: The amount of time (measured in seconds) to wait before beginning the animations.
    ///   Specify a value of 0 to begin the animations immediately.
    ///   - animated: The boolean value represents whether want to animate.
    ///   - completion: A block object to may be executed when the rotation ends.
    @objc public func cx_rotate(
        withAngle angle: CGFloat = CGFloat.pi/2,
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        animated: Bool = true,
        completion: (() -> Void)? = nil)
    {
        if animated {
            UIView.animate(withDuration: duration, delay: delay, options: []) {
                self.transform = CGAffineTransform(rotationAngle: angle)
            } completion: { finished in
                if finished { completion?() }
            }
        } else {
            if delay > 0 {
                DispatchQueue.cx.mainAsyncAfter(delay) {
                    self.transform = CGAffineTransform(rotationAngle: angle)
                    completion?()
                }
            } else {
                transform = CGAffineTransform(rotationAngle: angle)
                completion?()
            }
        }
    }
    
    /// Scales the view to the affine transformation matrix.
    ///
    /// - Parameters:
    ///   - sx: The factor by which to scale the x-axis of the coordinate system.
    ///   - sy: The factor by which to scale the y-axis of the coordinate system.
    ///   - duration: The total duration of the animations, measured in seconds.
    ///   - delay: The amount of time (measured in seconds) to wait before beginning the animations.
    ///   Specify a value of 0 to begin the animations immediately.
    ///   - animated: The boolean value represents whether want to animate.
    ///   - completion: A block object to may be executed when the rotation ends.
    @objc public func cx_scale(
        withSx sx: CGFloat,
        sy: CGFloat,
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        animated: Bool = true,
        completion: (() -> Void)? = nil)
    {
        if animated {
            UIView.animate(withDuration: duration, delay: delay, options: []) {
                self.transform = CGAffineTransform(scaleX: sx, y: sy)
            } completion: { finished in
                if finished { completion?() }
            }
        } else {
            if delay > 0 {
                DispatchQueue.cx.mainAsyncAfter(delay) {
                    self.transform = CGAffineTransform(scaleX: sx, y: sy)
                    completion?()
                }
            } else {
                transform = CGAffineTransform(scaleX: sx, y: sy)
                completion?()
            }
        }
    }
    
    /// Exchanges the subviews at the specified indices with the flip transition.
    @objc public func cx_flip(from fromView: UIView, to toView: UIView, duration: TimeInterval, completion: @escaping () -> Void)
    {
        cx_flip(from: fromView, to: toView, duration: duration, repeatCount: 1, completion: completion)
    }
    
    /// Exchanges the subviews at the specified indices with the flip transition.
    @objc public func cx_flip(from fromView: UIView, to toView: UIView, duration: TimeInterval, repeatCount: Int, completion: @escaping () -> Void)
    {
        guard let superview = fromView.superview else { return }
        guard let fromIndex = superview.subviews.firstIndex(of: fromView),
              let toIndex = superview.subviews.firstIndex(of: toView)
        else {
            return
        }
        var animatedCount = repeatCount
        // Deprecated.
        //UIView.beginAnimations("TransitionFlipAnimation", context: nil)
        //UIView.setAnimationDuration(0.5)
        //UIView.setAnimationCurve(UIView.AnimationCurve.easeInOut)
        //UIView.setAnimationRepeatCount(Float(repeatCount))
        //UIView.setAnimationDelegate(delegate)
        //UIView.setAnimationDidStop(didStopSelector)
        //UIView.setAnimationTransition(.flipFromLeft, for: superview, cache: true)
        //superview.exchangeSubview(at: fromIndex, withSubviewAt: toIndex)
        //UIView.commitAnimations()
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut, .transitionFlipFromLeft]) {
            superview.exchangeSubview(at: fromIndex, withSubviewAt: toIndex)
        } completion: { _ in
            animatedCount -= 1
            if animatedCount > 0 {
                self.cx_flip(from: fromView, to: toView, duration: duration, repeatCount: animatedCount, completion: completion)
            } else {
                completion()
            }
        }
    }
    
    /// Finds the first responder recursively.
    @objc public var cx_firstResponder: UIView?
    {
        var views = [UIView](arrayLiteral: self)
        var index = 0
        repeat {
            let view = views[index]
            if view.isFirstResponder {
                return view
            }
            views.append(contentsOf: view.subviews)
            index += 1
        } while index < views.count
        return nil
    }
    
    /// Checks if view is in RTL format.
    @objc public var cx_isRightToLeft: Bool
    {
        if #available(iOS 10.0, *) {
            return effectiveUserInterfaceLayoutDirection == .rightToLeft
        }
        return false
    }
    
    /// Returns the smallest possible size of the view based on its constraints.
    @objc public var cx_layoutSizeFittingSize: CGSize
    {
        return cx_layoutSizeFitting(size: UIView.layoutFittingCompressedSize)
    }
    
    /// Returns the optimal size of the view based on its current constraints.
    @objc public func cx_layoutSizeFitting(size targetSize: CGSize) -> CGSize
    {
        return systemLayoutSizeFitting(targetSize)
    }
    
    /// Returns the optimal size of the view based on its constraints and the specified fitting priorities.
    @objc public func cx_layoutSizeFitting(size targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize
    {
        return systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: horizontalFittingPriority,
            verticalFittingPriority: verticalFittingPriority)
    }
    
    /// Sets background image for view.
    @objc public func cx_setBackgroundImage(_ image: UIImage) {
        UIGraphicsBeginImageContext(frame.size)
        image.draw(in: bounds)
        guard let bgImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return
        }
        UIGraphicsEndImageContext()
        backgroundColor = bgImage.cx.patternColor
    }
    
    /// Animates for updating constraints.
    ///
    /// - Parameter duration: The total duration of the animations, measured in seconds.
    @objc public func cx_animateForUpdatingConstraints(_ duration: TimeInterval = 0.3) {
        // Controls whether the view’s constraints need updating.
        setNeedsUpdateConstraints()
        // Updates the constraints for the receiving view and its subviews.
        updateConstraintsIfNeeded()
        // Animate changes to one or more views using the specified duration.
        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
    }
    
}
#endif

/// Defines the enum of radian direction.
@objc public enum CXViewRadianDirection: Int {
    case top, left, bottom, right
}

extension CXView {
    
    /// Draws a quad curve for a view with the radian, direction and fill color.
    @objc public func cx_drawQuadCurve(withRadian radian: CGFloat, direction: CXViewRadianDirection = .bottom, fillColor: CXColor? = nil) {
        // Don't deal with it if radian is 0.
        if radian == 0 { return }
        let tW = frame.width
        let tH = frame.height
        #if swift(>=4.2)
        let height = abs(radian)
        #else
        let height = fabs(radian)
        #endif
        
        let x: CGFloat = 0
        let y: CGFloat = 0
        
        var maxRadian: CGFloat = 0
        switch direction {
        case .top, .bottom:
            maxRadian = min(tH, tW/2)
            break
        case .left, .right:
            maxRadian = min(tH/2, tW)
            break
        }
        
        // The radius of the quad curve is too large.
        guard height <= maxRadian else {
            CXLogger.log(level: .error, message: "The radius of the quad curve is too large.")
            return
        }
        
        var radius: CGFloat = 0
        switch direction {
        case .top, .bottom:
            let c = sqrt(pow(tW/2, 2) + pow(height, 2))
            let sin_bc = height / c
            radius = c / (sin_bc * 2)
            break
        case .left, .right:
            let c = sqrt(pow(tH/2, 2) + pow(height, 2))
            let sin_bc = height / c
            radius = c / (sin_bc * 2)
            break
        }
        
        /// Draws arc.
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = fillColor?.cgColor ?? CXColor.white.cgColor
        let path = CGMutablePath.init()
        switch direction {
        case .top:
            if radian > 0 {
                path.move(to: CGPoint(x: tW, y: height))
                path.addArc(center: CGPoint(x: tW / 2, y: radius),
                            radius: radius,
                            startAngle: 2 * CGFloat.pi - asin((radius - height ) / radius),
                            endAngle: CGFloat.pi + asin((radius - height ) / radius),
                            clockwise: true)
            } else {
                path.move(to: CGPoint(x: tW, y: y))
                path.addArc(center: CGPoint(x: tW / 2, y: height - radius),
                            radius: radius,
                            startAngle: asin((radius - height ) / radius),
                            endAngle: CGFloat.pi - asin((radius - height ) / radius),
                            clockwise: false)
            }
            path.addLine(to: CGPoint(x: x, y: tH))
            path.addLine(to: CGPoint(x: tW, y: tH))
        case .bottom:
            if radian > 0 {
                path.move(to: CGPoint(x: tW, y: tH - height))
                path.addArc(center: CGPoint(x: tW / 2, y: tH - radius),
                            radius: radius,
                            startAngle: asin((radius - height) / radius),
                            endAngle: CGFloat.pi - asin((radius - height) / radius),
                            clockwise: false)
            } else {
                path.move(to: CGPoint(x: tW, y: tH))
                path.addArc(center: CGPoint(x: tW / 2, y: tH + radius - height),
                            radius: radius,
                            startAngle: 2 * CGFloat.pi - asin((radius - height ) / radius),
                            endAngle: CGFloat.pi + asin((radius - height ) / radius),
                            clockwise: true)
            }
            path.addLine(to: CGPoint(x: x, y: y))
            path.addLine(to: CGPoint(x: tW, y: y))
        case .left:
            if radian > 0 {
                path.move(to: CGPoint(x: height, y: y))
                path.addArc(center: CGPoint(x: radius, y: tH / 2),
                            radius: radius,
                            startAngle: CGFloat.pi + asin((radius - height ) / radius),
                            endAngle: CGFloat.pi - asin((radius - height ) / radius),
                            clockwise: true)
            } else {
                path.move(to: CGPoint(x: x, y: y))
                path.addArc(center: CGPoint(x: height - radius, y: tH / 2),
                            radius: radius,
                            startAngle: 2 * CGFloat.pi - asin((radius - height ) / radius),
                            endAngle: asin((radius - height ) / radius),
                            clockwise: false)
            }
            path.addLine(to: CGPoint(x: tW, y: tH))
            path.addLine(to: CGPoint(x: tW, y: y))
        case .right:
            if radian > 0 {
                path.move(to: CGPoint(x: tW - height, y: y))
                path.addArc(center: CGPoint(x: tW - radius, y: tH / 2),
                            radius: radius,
                            startAngle: 1.5 * CGFloat.pi + asin((radius - height) / radius),
                            endAngle: CGFloat.pi / 2 + asin((radius - height ) / radius),
                            clockwise: false)
            } else {
                path.move(to: CGPoint(x: tW, y: y))
                path.addArc(center: CGPoint(x: tW + radius - height, y: tH / 2),
                            radius: radius,
                            startAngle: CGFloat.pi + asin((radius - height) / radius),
                            endAngle: CGFloat.pi - asin((radius - height ) / radius),
                            clockwise: true)
            }
            path.addLine(to: CGPoint(x: x, y: tH))
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.closeSubpath()
        shapeLayer.path = path
        mLayer?.mask = shapeLayer
    }
    
}

extension CXView {
    
    /// Returns the receiver’s immediate subviews.
    @objc public var cx_children: [CXView]
    {
        return subviews
    }
    
    /// Returns the receiver’s recursive subviews.
    @objc public var cx_recursiveSubviews: [CXView]
    {
        return subviews.reduce(subviews) { $0 + $1.cx_recursiveSubviews }
    }
    
    /// Adds the subviews.
    public func cx_add(subviews: CXView...) {
        subviews.forEach(addSubview)
    }
    
    /// Adds the subviews.
    @objc public func cx_addSubViews(_ views: [CXView]) {
        views.forEach(addSubview)
    }
    
    /// Constrains itself to view.
    @objc public func cx_constrain(to view: CXView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.cx_add(subviews: self)
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    /// Returns view's parent view controller.
    @objc public var cx_parentViewController: CXViewController? {
        weak var responder: CXResponder? = self
        while responder != nil {
            #if os(macOS)
            responder = responder!.nextResponder
            #else
            responder = responder!.next
            #endif
            if let viewController = responder as? CXViewController {
                return viewController
            }
        }
        return nil
    }
    
}

//MARK: - Constraints

extension CXView {
    
    #if !os(watchOS) && canImport(UIKit)
    @objc public func cx_makeConstraints(maker: @escaping (CXConstraintMaker) -> Void) {
        assert(superview != nil, "The receiver’s superview is nil.")
        guard let spView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        let cMaker = CXConstraintMaker(top: CXConstraintYAxisItem(),
                                       leading: CXConstraintXAxisItem(),
                                       bottom: CXConstraintYAxisItem(),
                                       trailing: CXConstraintXAxisItem(),
                                       width: CXConstraintDimensionItem(),
                                       height: CXConstraintDimensionItem(),
                                       centerX: CXConstraintXAxisItem(),
                                       centerY: CXConstraintYAxisItem())
        maker(cMaker)
        
        if cMaker.top.hasConstraints {
            //let relation: NSLayoutConstraint.Relation = cMaker.top.isEqual ? .equal : cMaker.top.isGreaterThanOrEqual ? .greaterThanOrEqual : .lessThanOrEqual
            //let layoutConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: relation, toItem: view, attribute: .top, multiplier: 1.0, constant: cMaker.top.value)
            //layoutConstraint.isActive = true
            let anchor = cMaker.top.yAnchor ?? spView.topAnchor
            if cMaker.top.isEqual {
                topAnchor.constraint(equalTo: anchor, constant: cMaker.top.value).isActive = true
            } else if cMaker.top.isGreaterThanOrEqual {
                topAnchor.constraint(greaterThanOrEqualTo: anchor, constant: cMaker.top.value).isActive = true
            } else if cMaker.top.isLessThanOrEqual {
                topAnchor.constraint(lessThanOrEqualTo: anchor, constant: cMaker.top.value).isActive = true
            }
        }
        if cMaker.leading.hasConstraints {
            let anchor = cMaker.leading.xAnchor ?? spView.leadingAnchor
            if cMaker.leading.isEqual {
                leadingAnchor.constraint(equalTo: anchor, constant: cMaker.leading.value).isActive = true
            } else if cMaker.leading.isGreaterThanOrEqual {
                leadingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: cMaker.leading.value).isActive = true
            } else if cMaker.leading.isLessThanOrEqual {
                leadingAnchor.constraint(lessThanOrEqualTo: anchor, constant: cMaker.leading.value).isActive = true
            }
        }
        if cMaker.bottom.hasConstraints {
            let anchor = cMaker.bottom.yAnchor ?? spView.bottomAnchor
            if cMaker.bottom.isEqual {
                bottomAnchor.constraint(equalTo: anchor, constant: cMaker.bottom.value).isActive = true
            } else if cMaker.bottom.isGreaterThanOrEqual {
                bottomAnchor.constraint(greaterThanOrEqualTo: anchor, constant: cMaker.bottom.value).isActive = true
            } else if cMaker.bottom.isLessThanOrEqual {
                bottomAnchor.constraint(lessThanOrEqualTo: anchor, constant: cMaker.bottom.value).isActive = true
            }
        }
        if cMaker.trailing.hasConstraints {
            let anchor = cMaker.trailing.xAnchor ?? spView.trailingAnchor
            if cMaker.trailing.isEqual {
                trailingAnchor.constraint(equalTo: anchor, constant: cMaker.trailing.value).isActive = true
            } else if cMaker.trailing.isGreaterThanOrEqual {
                trailingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: cMaker.trailing.value).isActive = true
            } else if cMaker.trailing.isLessThanOrEqual {
                trailingAnchor.constraint(lessThanOrEqualTo: anchor, constant: cMaker.trailing.value).isActive = true
            }
        }
        if cMaker.centerX.hasConstraints {
            let anchor = cMaker.centerX.xAnchor ?? spView.centerXAnchor
            if cMaker.centerX.isEqual {
                centerXAnchor.constraint(equalTo: anchor, constant: cMaker.centerX.value).isActive = true
            } else if cMaker.centerX.isGreaterThanOrEqual {
                centerXAnchor.constraint(greaterThanOrEqualTo: anchor, constant: cMaker.centerX.value).isActive = true
            } else if cMaker.centerX.isLessThanOrEqual {
                centerXAnchor.constraint(lessThanOrEqualTo: anchor, constant: cMaker.centerX.value).isActive = true
            }
        }
        if cMaker.centerY.hasConstraints {
            let anchor = cMaker.centerY.yAnchor ?? spView.centerYAnchor
            if cMaker.centerY.isEqual {
                centerYAnchor.constraint(equalTo: anchor, constant: cMaker.centerY.value).isActive = true
            } else if cMaker.centerY.isGreaterThanOrEqual {
                centerYAnchor.constraint(greaterThanOrEqualTo: anchor, constant: cMaker.centerY.value).isActive = true
            } else if cMaker.centerY.isLessThanOrEqual {
                centerYAnchor.constraint(lessThanOrEqualTo: anchor, constant: cMaker.centerY.value).isActive = true
            }
        }
        
        if cMaker.width.hasConstraints {
            if let dimension = cMaker.width.dimens {
                if cMaker.width.isEqual {
                    widthAnchor.constraint(equalTo: dimension, constant: cMaker.width.value).isActive = true
                } else if cMaker.width.isGreaterThanOrEqual {
                    widthAnchor.constraint(greaterThanOrEqualTo: dimension, constant: cMaker.width.value).isActive = true
                } else if cMaker.width.isLessThanOrEqual {
                    widthAnchor.constraint(lessThanOrEqualTo: dimension, constant: cMaker.width.value).isActive = true
                }
            } else {
                if cMaker.width.isEqual {
                    widthAnchor.constraint(equalToConstant: cMaker.width.value).isActive = true
                } else if cMaker.width.isGreaterThanOrEqual {
                    widthAnchor.constraint(greaterThanOrEqualToConstant: cMaker.width.value).isActive = true
                } else if cMaker.width.isLessThanOrEqual {
                    widthAnchor.constraint(lessThanOrEqualToConstant: cMaker.width.value).isActive = true
                }
            }
        }
        if cMaker.height.hasConstraints {
            if let dimension = cMaker.height.dimens {
                if cMaker.height.isEqual {
                    heightAnchor.constraint(equalTo: dimension, constant: cMaker.height.value).isActive = true
                } else if cMaker.height.isGreaterThanOrEqual {
                    heightAnchor.constraint(greaterThanOrEqualTo: dimension, constant: cMaker.height.value).isActive = true
                } else if cMaker.height.isLessThanOrEqual {
                    heightAnchor.constraint(lessThanOrEqualTo: dimension, constant: cMaker.height.value).isActive = true
                }
            } else {
                if cMaker.height.isEqual {
                    heightAnchor.constraint(equalToConstant: cMaker.height.value).isActive = true
                } else if cMaker.height.isGreaterThanOrEqual {
                    heightAnchor.constraint(greaterThanOrEqualToConstant: cMaker.height.value).isActive = true
                } else if cMaker.height.isLessThanOrEqual {
                    heightAnchor.constraint(lessThanOrEqualToConstant: cMaker.height.value).isActive = true
                }
            }
        }
    }
    
    @objc public func cx_remakeConstraints(maker: @escaping (CXConstraintMaker) -> Void)
    {
        cx_removeConstraints()
        cx_makeConstraints(maker: maker)
    }
    
    @objc public func cx_removeConstraints()
    {
        guard constraints.count > 0 else { return }
        NSLayoutConstraint.deactivate(constraints)
        //constraints.forEach { $0.isActive = false }
    }
    
    /// The insets that you use to determine the safe area for this view.
    @objc public var cx_safeAreaInsets: CXEdgeInsets
    {
        if #available(iOS 11.0, tvOS 11.0, macOS 11.0, *) {
            return safeAreaInsets
        } else {
            #if os(macOS)
            return NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            #else
            return .zero
            #endif
        }
    }
    
    @objc public var cx_safeTopAnchor: NSLayoutYAxisAnchor
    {
        if #available(iOS 11.0, tvOS 11.0, macOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }
    
    @objc public var cx_safeLeadingAnchor: NSLayoutXAxisAnchor
    {
        if #available(iOS 11.0, tvOS 11.0, macOS 11.0, *) {
            return safeAreaLayoutGuide.leftAnchor
        }
        return leftAnchor
    }
    
    @objc public var cx_safeBottomAnchor: NSLayoutYAxisAnchor
    {
        if #available(iOS 11.0, tvOS 11.0, macOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        }
        return bottomAnchor
    }
    
    @objc public var cx_safeTrailingAnchor: NSLayoutXAxisAnchor
    {
        if #available(iOS 11.0, tvOS 11.0, macOS 11.0, *) {
            return safeAreaLayoutGuide.rightAnchor
        }
        return rightAnchor
    }
    
    @objc public var cx_safeCenterXAnchor: NSLayoutXAxisAnchor
    {
        if #available(iOS 11.0, tvOS 11.0, macOS 11.0, *) {
            return safeAreaLayoutGuide.centerXAnchor
        }
        return centerXAnchor
    }
    
    @objc public var cx_safeCenterYAnchor: NSLayoutYAxisAnchor
    {
        if #available(iOS 11.0, tvOS 11.0, macOS 11.0, *) {
            return safeAreaLayoutGuide.centerYAnchor
        }
        return centerYAnchor
    }
    
    @objc public var cx_safeWidthAnchor: NSLayoutDimension
    {
        if #available(iOS 11.0, tvOS 11.0, macOS 11.0, *) {
            return safeAreaLayoutGuide.widthAnchor
        }
        return widthAnchor
    }
    
    @objc public var cx_safeHeightAnchor: NSLayoutDimension
    {
        if #available(iOS 11.0, tvOS 11.0, macOS 11.0, *) {
            return safeAreaLayoutGuide.heightAnchor
        }
        return heightAnchor
    }
    #endif
}

#endif
