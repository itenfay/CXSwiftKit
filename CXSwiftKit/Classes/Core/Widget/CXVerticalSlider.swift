//
//  CXVerticalSlider.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/6/8.
//

#if canImport(UIKit)
import UIKit

public class CXVerticalSlider: UIView {
    
    /// The image that appears to bottom of control, default is nil.
    @objc public var minimumImage: UIImage? {
        didSet {
            minImageView.image = minimumImage
            minImageView.sizeToFit()
        }
    }
    
    /// The image that appears to top of control, default is nil.
    @objc public var maximumImage: UIImage? {
        didSet {
            maxImageView.image = maximumImage
            maxImageView.sizeToFit()
        }
    }
    
    /// The thumb image for the slider, default is nil.
    @objc public var thumbImage: UIImage? {
        didSet {
            thumbImageView.image = thumbImage
            thumbImageView.sizeToFit()
            masLayoutSubviews()
        }
    }
    
    /// This value will be pinned to min/max, default 0.0.
    @objc public private(set) var value: Float = 0.0
    /// The current value may change if outside new min value, default 0.0.
    @objc public var minimumValue: Float = 0.0 {
        didSet {
            if value == 0 {
                value = minimumValue
            }
        }
    }
    /// The current value may change if outside new max value, default 1.0
    @objc public var maximumValue: Float = 1.0
    
    private lazy var minImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var maxImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    /// Represents the mask layer.
    private lazy var maskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    
    /// The callback invoked when the value changed.
    @objc public var onValueChanged: ((_ value: Float, _ ended: Bool) -> Void)?
    private var awakedFromNib: Bool = false
    
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @objc public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        awakedFromNib = true
    }
    
    private func setup() {
        backgroundColor = .clear
        addSubviews()
        masLayoutSubviews()
        addPanGesture()
        configMask()
    }
    
    @objc public func setMinImageContentMode(_ mode: UIView.ContentMode) {
        minImageView.contentMode = mode
    }
    
    @objc public func setMaxImageContentMode(_ mode: UIView.ContentMode) {
        maxImageView.contentMode = mode
    }
    
    @objc public func setThumbImageContentMode(_ mode: UIView.ContentMode) {
        thumbImageView.contentMode = mode
    }
    
    //MARK: - UI
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if awakedFromNib {
            setup()
        }
    }
    
    private func configMask() {
        let path = UIBezierPath(rect: bounds)
        maskLayer.path = path.cgPath
        minImageView.layer.mask = maskLayer
    }
    
    private func addSubviews() {
        addSubview(maxImageView)
        addSubview(minImageView)
        addSubview(thumbImageView)
    }
    
    private func masLayoutSubviews() {
        let w = frame.width
        let h = frame.height
        
        minImageView.frame = CGRectMake(0, 0, w, h)
        maxImageView.frame = CGRectMake(0, 0, w, h)
        var thumbRect: CGRect
        if let thumbImage = thumbImage {
            thumbRect = CGRectMake(0, 0, thumbImage.size.width, thumbImage.size.height)
        } else {
            thumbRect = CGRectMake(0, 0, w, w)
        }
        thumbImageView.frame = thumbRect
        
        let py = -CGFloat(minimumValue)*(h - thumbImageView.frame.height) - h + thumbImageView.frame.height/2
        let center = CGPoint(x: w/2, y: -py)
        thumbImageView.center = center
        
        minImageView.center = CGPoint(x: w/2, y: h/2)
        maxImageView.center = CGPoint(x: w/2, y: h/2)
    }
    
    @objc public func setValue(_ v: Float, animated: Bool) {
        if v < minimumValue {
            return
        }
        value = v
        if animated {
            UIView.animate(withDuration: 0.1) {
                self.updateThumbCenterByValue(v)
            }
            let animation = CABasicAnimation(keyPath: "position.y")
            var rect = bounds
            rect.size.height = frame.height - CGFloat((v - minimumValue)/(maximumValue - minimumValue))
            animation.toValue = -rect.height
            animation.delegate = self
            animation.isRemovedOnCompletion = false
            animation.duration = 0.1
            minImageView.layer.mask?.add(animation, forKey: "aniY")
        } else {
            fillPathByValue(value)
            updateThumbCenterByValue(v)
        }
    }
    
    private func updateThumbCenterByValue(_ v: Float) {
        let py = CGFloat(v - minimumValue)*(frame.height - thumbImageView.frame.height)/CGFloat(maximumValue - minimumValue) - frame.height + thumbImageView.frame.height/2
        let center = CGPointMake(thumbImageView.center.x, -py)
        thumbImageView.center = center
    }
    
    private func updateValue(_ v: Float) {
        var _value = v
        if _value < minimumValue {
            _value = minimumValue
        }
        value = _value
        setValue(_value, animated: false)
        layoutIfNeeded()
    }
    
    private func fillPathByValue(_ v: Float) {
        if v < minimumValue {
            return
        }
        value = v
        var rect = bounds
        rect.size.height = frame.height * CGFloat(1 - (v - minimumValue)/(maximumValue - minimumValue))
        let path = UIBezierPath(rect: rect)
        maskLayer.path = path.cgPath
    }
    
    public override func sizeToFit() {
        super.sizeToFit()
        thumbImageView.sizeToFit()
        maxImageView.sizeToFit()
        minImageView.sizeToFit()
    }
    
    private func addPanGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(moveSlider(_:)))
        thumbImageView.addGestureRecognizer(pan)
    }
    
    @objc private func moveSlider(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .changed {
            if (thumbImageView.frame.minY + thumbImageView.frame.height) < frame.height && thumbImageView.frame.minY >= 0 {
                var translation = recognizer.translation(in: self)
                translation = CGPointApplyAffineTransform(translation, thumbImageView.transform)
                var moveY = thumbImageView.center.y + translation.y
                if (thumbImageView.center.y + translation.y) > (frame.height - thumbImageView.frame.height/2) {
                    moveY = frame.height - thumbImageView.frame.height/2
                } else if (thumbImageView.center.y + translation.y) < thumbImageView.frame.height/2 {
                    moveY = thumbImageView.frame.height/2
                } else if thumbImageView.frame.minY < 0 {
                    moveY = thumbImageView.frame.height/2
                }
                thumbImageView.center = CGPointMake(thumbImageView.center.x, moveY)
                /// Reset the current translation.
                recognizer.setTranslation(.zero, in: self)
                
                let value = (frame.height - thumbImageView.center.y - thumbImageView.frame.height/2)/(frame.height - thumbImageView.frame.height)*CGFloat(maximumValue - minimumValue) + CGFloat(minimumValue)
                fillPathByValue(Float(value))
                onValueChanged?(Float(value), false)
            }
        } else {
            onValueChanged?(value, true)
        }
    }
    
    //MARK: - Touch Event
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = NSSet(set: touches).anyObject() as? UITouch {
            let coordinate = touch.location(in: self)
            handleTouchEventByPoint(coordinate)
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = NSSet(set: touches).anyObject() as? UITouch {
            let coordinate = touch.location(in: self)
            handleTouchEventByPoint(coordinate)
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = NSSet(set: touches).anyObject() as? UITouch {
            let coordinate = touch.location(in: self)
            handleTouchEventByPoint(coordinate)
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // do nothing
    }
    
    private func handleTouchEventByPoint(_ point: CGPoint) {
        let h = frame.size.height;
        var ratio: CGFloat = 1 - (point.y/h)
        if ratio < 0 { ratio = 0 }
        if ratio > 1 { ratio = 1 }
        let value = Float(ratio) * maximumValue
        setValue(value, animated: false)
        onValueChanged?(value, true)
    }
    
}

extension CXVerticalSlider: CAAnimationDelegate {
    
    public func animationDidStart(_ anim: CAAnimation) {
        CXLogger.log(level: .info, message: "anim=\(anim)")
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag, let _anim = maskLayer.animation(forKey: "aniY"), _anim == anim {
            fillPathByValue(value)
            maskLayer.removeAnimation(forKey: "aniY")
        }
    }
    
}

#endif
