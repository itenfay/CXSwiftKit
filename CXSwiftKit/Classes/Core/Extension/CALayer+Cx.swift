//
//  CALayer+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if canImport(QuartzCore) && canImport(ObjectiveC)
import QuartzCore
import ObjectiveC.runtime

extension CXSwiftBase where T == CALayer {
    
    public func findAnimation(forKeyPath keyPath: String) -> CABasicAnimation? {
        return base.cx_findAnimation(forKeyPath: keyPath)
    }
    
    /// Start rotating animation.
    public func cx_startRotating() {
        base.cx_startRotating()
    }
    
    /// Stop rotating animation.
    public func pauseRotating() {
        base.cx_pauseRotating()
    }
    
    /// Resume rotating animation.
    public func resumeRotating() {
        base.cx_resumeRotating()
    }
    
    /// Remove rotating animation.
    public func removeRotating() {
        base.cx_removeRotating()
    }
    
    /// Remove the animation with the specified key.
    public func removeAnimation(forKey key: String) {
        base.cx_removeAnimation(forKey: key)
    }
    
    /// Return true if the animation matching the identifier, or false if no such animation exists.
    public func hasAnimation(forKey key: String) -> Bool {
        return base.cx_hasAnimation(forKey: key)
    }
    
}

extension CALayer {
    
    fileprivate var kAnimationRotating: String {
        return "cx.animation.rotation"
    }
    
    private var isRotating: Bool {
        get {
            return (objc_getAssociatedObject(self, &CXAssociatedKey.isAnimationRotating) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &CXAssociatedKey.isAnimationRotating, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    @objc public func cx_findAnimation(forKeyPath keyPath: String) -> CABasicAnimation? {
        return animationKeys()?
            .compactMap({ animation(forKey: $0) as? CABasicAnimation })
            .filter({ $0.keyPath == keyPath })
            .first
    }
    
    /// Start rotating animation.
    @objc public func cx_startRotating() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = .pi * 2.0
        rotationAnimation.repeatCount = MAXFLOAT
        rotationAnimation.duration = 20
        // Avoid clicking the Home button to return, and the animation will stop.
        rotationAnimation.isRemovedOnCompletion = false
        add(rotationAnimation, forKey: kAnimationRotating)
        isRotating = true
    }
    
    /// Pause rotating animation.
    @objc public func cx_pauseRotating() {
        if !isRotating { return }
        let pausedTime: CFTimeInterval = convertTime(CACurrentMediaTime(), from: nil)
        // Let CALayer's time stop walking.
        speed = 0.0
        // Let CALayer's time stay at the moment of paused time.
        timeOffset = pausedTime
        isRotating = false
    }
    
    /// Resume rotating animation.
    @objc public func cx_resumeRotating() {
        if isRotating { return }
        if timeOffset == 0 {
            cx_startRotating()
            return
        }
        let pausedTime = timeOffset
        // Let CALayer's time continue to walk.
        speed = 1.0
        // Cancel the last recorded stop time.
        timeOffset = 0.0
        // Cancel the last begin time.
        beginTime = 0.0
        let timeSincePause: CFTimeInterval = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        // Set the begin time.
        beginTime = timeSincePause
        isRotating = true
    }
    
    /// Remove rotating animation.
    @objc public func cx_removeRotating() {
        removeAnimation(forKey: kAnimationRotating)
        isRotating = false
    }
    
    /// Remove the animation with the specified key.
    @objc public func cx_removeAnimation(forKey key: String) {
        removeAnimation(forKey: key)
    }
    
    /// Return true if the animation matching the identifier, or false if no such animation exists.
    @objc public func cx_hasAnimation(forKey key: String) -> Bool {
        let anim = animation(forKey: key)
        return anim != nil ? true : false
    }
    
}

#endif
