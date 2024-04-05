//
//  CXOverlayViewEx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

import Foundation
#if os(iOS) || os(tvOS)
import UIKit

extension CXSwiftBase where T : CXView {
    
    #if os(iOS) || os(tvOS)
    /// Present the view, the overlay view is subview of the view.
    public func present(_ view: UIView?, overlayRatio: CGFloat = 0.7, overlayDirection: CXOverlayDirection = .bottom, completion: (() -> Void)? = nil, dismiss: @escaping () -> Void) {
        self.base.cx_present(view, overlayRatio: overlayRatio, overlayDirection: overlayDirection, completion: completion, dismiss: dismiss)
    }
    
    /// Dismiss the presenting view, the overlay view is subview of the view.
    public func dismiss(completion: (() -> Void)? = nil)
    {
        self.base.cx_dismiss(completion: completion)
    }
    
    /// Present the view from center.
    public func presentFromCenter(_ view: UIView?, completion: (() -> Void)? = nil, dismiss: @escaping () -> Void) {
        self.base.cx_presentFromCenter(view, completion: completion, dismiss: dismiss)
    }
    
    /// Dismiss the presenting view from center.
    public func dismissFromCenter(completion: (() -> Void)? = nil) {
        self.base.cx_dismissFromCenter(completion: completion)
    }
    #endif
    
}

//MARK: - CXOverlayViewWrapable

#if os(iOS) || os(tvOS)

extension UIView: CXOverlayViewWrapable {
    
    private var cx_overlayDirection: CXOverlayDirection? {
        get {
            let obj = objc_getAssociatedObject(self, &CXAssociatedKey.presentOverlayDirection) as? NSNumber
            return CXOverlayDirection(rawValue: obj?.uint8Value ?? 0)
        }
        set {
            let obj = NSNumber(value: newValue?.rawValue ?? 0)
            objc_setAssociatedObject(self, &CXAssociatedKey.presentOverlayDirection, obj, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public var cx_overlayMaskView: UIView? {
        return fpOverlayMaskView
    }
    
    private var fpOverlayMaskView: UIView? {
        get {
            return objc_getAssociatedObject(self, &CXAssociatedKey.presentOverlayMask) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &CXAssociatedKey.presentOverlayMask, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var fpDismissHandler: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &CXAssociatedKey.dismissOverlayAction) as? (() -> Void)
        }
        set {
            objc_setAssociatedObject(self, &CXAssociatedKey.dismissOverlayAction, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var fpIsFromCenter: Bool {
        get {
            return (objc_getAssociatedObject(self, &CXAssociatedKey.overlayIsFromCenter) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &CXAssociatedKey.overlayIsFromCenter, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    @objc private func _onTapOverlayMaskView(_ gesture: UITapGestureRecognizer) {
        let tapView = gesture.view;
        if let view = tapView, let oView = self.fpOverlayMaskView, view == oView {
            self.fpIsFromCenter
            ? self.cx_dismissFromCenter()
            : self.cx_dismiss()
        }
    }
    
    /// Present the view, the overlay view is subview of the view.
    public func cx_present(_ view: UIView?, overlayRatio: CGFloat = 0.7, overlayDirection: CXOverlayDirection = .bottom, completion: (() -> Void)? = nil, dismiss: @escaping () -> Void) {
        guard let _view = view else { return }
        _view.cx_overlayDirection = overlayDirection
        _view.fpDismissHandler = dismiss
        let maskView = UIView(frame: self.bounds)
        maskView.backgroundColor = UIColor.cx_color(withHexString: "#000000", alpha: 0.3)
        maskView.isUserInteractionEnabled = true
        _view.fpOverlayMaskView = maskView
        let tapGesture = UITapGestureRecognizer(target: _view, action: #selector(_onTapOverlayMaskView(_:)))
        maskView.addGestureRecognizer(tapGesture)
        addSubview(maskView)
        addSubview(_view)
        var aView = _view
        let ratio: CGFloat = overlayRatio
        switch overlayDirection {
        case .top:
            aView.cx.height = ratio * self.cx.height
            aView.cx.y = -aView.cx.height
        case .left:
            aView.cx.width = ratio * self.cx.width
            aView.cx.x = -aView.cx.width
        case .bottom:
            aView.cx.height = ratio * self.cx.height
            aView.cx.y = CGFloat.cx.screenHeight
        case .right:
            aView.cx.width = ratio * self.cx.width
            aView.cx.x = CGFloat.cx.screenWidth
        }
        let animationOptions: UIView.AnimationOptions = [
            .curveEaseInOut,
            .allowUserInteraction,
            .beginFromCurrentState
        ]
        UIView.animate(withDuration: 0.35, delay: 0.1, options: animationOptions) {
        //UIView.animate(withDuration: 0.35, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: animationOptions) {
            switch overlayDirection {
            case .top: aView.cx.y = 0
            case .left: aView.cx.x = 0
            case .bottom: aView.cx.y = (1 - ratio) * CGFloat.cx.screenHeight
            case .right: aView.cx.x = (1 - ratio) * CGFloat.cx.screenWidth
            }
        } completion: { _ in
            completion?()
        }
    }
    
    /// Dismiss the presenting view, the overlay view is subview of the view.
    public func cx_dismiss(completion: (() -> Void)? = nil) {
        assert(cx_overlayMaskView != nil, "Please invoke dismiss(::) method with the presenting view.")
        let overlayDirection = cx_overlayDirection!
        let maskView = cx_overlayMaskView
        let animationOptions: UIView.AnimationOptions = [
            .curveEaseInOut,
            .allowUserInteraction
        ]
        var aView = self
        UIView.animate(withDuration: 0.35, delay: 0.1, options: animationOptions) {
        //UIView.animate(withDuration: 0.35, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: animationOptions) {
            switch overlayDirection {
            case .top: aView.cx.y = -CGFloat.cx.screenHeight
            case .left: aView.cx.x = -CGFloat.cx.screenWidth
            case .bottom: aView.cx.y = CGFloat.cx.screenHeight
            case .right: aView.cx.x = CGFloat.cx.screenWidth
            }
        } completion: { _ in
            maskView?.removeFromSuperview()
            aView.removeFromSuperview()
            completion?()
            aView.fpDismissHandler?()
        }
    }
    
    public func cx_presentFromCenter(_ view: UIView?, completion: (() -> Void)? = nil, dismiss: @escaping () -> Void) {
        guard let _view = view else { return }
        _view.fpDismissHandler = dismiss
        _view.fpIsFromCenter = true
        let maskView = UIView(frame: self.bounds)
        maskView.backgroundColor = UIColor.cx_color(withHexString: "#000000", alpha: 0.3)
        maskView.isUserInteractionEnabled = true
        _view.fpOverlayMaskView = maskView
        let tapGesture = UITapGestureRecognizer(target: _view, action: #selector(_onTapOverlayMaskView(_:)))
        maskView.addGestureRecognizer(tapGesture)
        addSubview(maskView)
        addSubview(_view)
        var aView = _view
        aView.cx.centerX = self.cx.centerX
        aView.cx.centerY = self.cx.centerY
        let animationOptions: UIView.AnimationOptions = [
            .curveEaseInOut,
            .allowUserInteraction,
            .beginFromCurrentState
        ]
        aView.alpha = 0.0
        UIView.animate(withDuration: 0.35, delay: 0.1, options: animationOptions) {
            //aView.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
            aView.alpha = 1.0
        } completion: { finished in
            //aView.transform = CGAffineTransformIdentity
            completion?()
        }
    }
    
    public func cx_dismissFromCenter(completion: (() -> Void)? = nil) {
        let maskView = cx_overlayMaskView
        let animationOptions: UIView.AnimationOptions = [
            .curveEaseInOut,
            .allowUserInteraction
        ]
        let aView = self
        aView.alpha = 1.0
        UIView.animate(withDuration: 0.35, delay: 0.1, options: animationOptions) {
            aView.alpha = 0.0
        } completion: { finished in
            maskView?.removeFromSuperview()
            aView.removeFromSuperview()
            completion?()
            aView.fpDismissHandler?()
        }
    }
    
}

#endif

extension CXSwiftBase where T : CXViewController {
    
    #if os(iOS) || os(tvOS)
    /// Present the view controller, the overlay view is subview of the controller's view
    public func present(_ controller: UIViewController?, overlayRatio: CGFloat = 0.7, overlayDirection: CXOverlayDirection = .bottom, completion: (() -> Void)? = nil, dismiss: @escaping () -> Void) {
        self.base.cx_present(controller, overlayRatio: overlayRatio, overlayDirection: overlayDirection, completion: completion, dismiss: dismiss)
    }
    
    /// Dismiss the view controller.
    public func dismiss(completion: (() -> Void)? = nil) {
        self.base.cx_dismiss(completion: completion)
    }
    
    /// Present the view controller from center.
    public func presentFromCenter(_ controller: UIViewController?, completion: (() -> Void)? = nil, dismiss: @escaping () -> Void) {
        self.base.cx_presentFromCenter(controller, completion: completion, dismiss: dismiss)
    }
    
    /// Dismiss the view controller from center.
    public func dismissFromCenter(completion: (() -> Void)? = nil) {
        self.base.cx_dismissFromCenter(completion: completion)
    }
    #endif
    
}

//MARK: - CXOverlayViewControllerWrapable

#if os(iOS) || os(tvOS)

extension UIViewController: CXOverlayViewControllerWrapable {
    
    private var cx_overlayDirection: CXOverlayDirection? {
        get {
            let obj = objc_getAssociatedObject(self, &CXAssociatedKey.presentOverlayDirection) as? NSNumber
            return CXOverlayDirection(rawValue: obj?.uint8Value ?? 0)
        }
        set {
            let obj = NSNumber(value: newValue?.rawValue ?? 0)
            objc_setAssociatedObject(self, &CXAssociatedKey.presentOverlayDirection, obj, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public var cx_overlayMaskView: UIView? {
        return fpOverlayMaskView
    }
    
    private var fpOverlayMaskView: UIView? {
        get {
            return objc_getAssociatedObject(self, &CXAssociatedKey.presentOverlayMask) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &CXAssociatedKey.presentOverlayMask, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var fpDismissHandler: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &CXAssociatedKey.dismissOverlayAction) as? (() -> Void)
        }
        set {
            objc_setAssociatedObject(self, &CXAssociatedKey.dismissOverlayAction, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var fpIsFromCenter: Bool {
        get {
            return (objc_getAssociatedObject(self, &CXAssociatedKey.overlayIsFromCenter) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &CXAssociatedKey.overlayIsFromCenter, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    @objc private func _onTapOverlayMaskView(_ gesture: UITapGestureRecognizer) {
        let tapView = gesture.view;
        if let view = tapView, let oView = self.fpOverlayMaskView, view == oView {
            self.fpIsFromCenter
            ? self.cx_dismissFromCenter()
            : self.cx_dismiss()
        }
    }
    
    /// Present the view controller, the overlay view is subview of the controller's view
    public func cx_present(_ controller: UIViewController?, overlayRatio: CGFloat, overlayDirection: CXOverlayDirection, completion: (() -> Void)? = nil, dismiss: @escaping () -> Void) {
        guard let vc = controller else { return }
        vc.cx_overlayDirection = overlayDirection
        vc.fpDismissHandler = dismiss
        let maskView = UIView(frame: view.bounds)
        maskView.backgroundColor = UIColor.cx_color(withHexString: "#000000", alpha: 0.3)
        maskView.isUserInteractionEnabled = true
        vc.fpOverlayMaskView = maskView
        let tapGesture = UITapGestureRecognizer(target: vc, action: #selector(_onTapOverlayMaskView(_:)))
        maskView.addGestureRecognizer(tapGesture)
        addChild(vc)
        view.addSubview(maskView)
        view.addSubview(vc.view)
        var aView = vc.view!
        let ratio: CGFloat = overlayRatio
        switch overlayDirection {
        case .top:
            aView.cx.height = ratio * view.cx.height
            aView.cx.y = -aView.cx.height
        case .left:
            aView.cx.width = ratio * view.cx.width
            aView.cx.x = -aView.cx.width
        case .bottom:
            aView.cx.height = ratio * view.cx.height
            aView.cx.y = CGFloat.cx.screenHeight
        case .right:
            aView.cx.width = ratio * view.cx.width
            aView.cx.x = CGFloat.cx.screenWidth
        }
        let animationOptions: UIView.AnimationOptions = [
            .curveEaseInOut,
            .allowUserInteraction,
            .beginFromCurrentState
        ]
        UIView.animate(withDuration: 0.35, delay: 0.1, options: animationOptions) {
        //UIView.animate(withDuration: 0.35, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: animationOptions) {
            switch overlayDirection {
            case .top: aView.cx.y = 0
            case .left: aView.cx.x = 0
            case .bottom: aView.cx.y = (1 - ratio) * CGFloat.cx.screenHeight
            case .right: aView.cx.x = (1 - ratio) * CGFloat.cx.screenWidth
            }
        } completion: { _ in
            completion?()
        }
    }
    
    /// Dismiss the view controller, the overlay view is subview of the controller's view
    public func cx_dismiss(completion: (() -> Void)? = nil) {
        guard let _ = parent else { return }
        assert(cx_overlayMaskView != nil, "Please invoke dismiss(:) method with the presenting view controller.")
        let overlayDirection = cx_overlayDirection!
        let maskView = self.cx_overlayMaskView
        let animationOptions: UIView.AnimationOptions = [
            .curveEaseInOut,
            .allowUserInteraction
        ]
        var aView = view!
        UIView.animate(withDuration: 0.35, delay: 0.1, options: animationOptions) {
        //UIView.animate(withDuration: 0.35, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: animationOptions) {
            switch overlayDirection {
            case .top: aView.cx.y = -CGFloat.cx.screenHeight
            case .left: aView.cx.x = -CGFloat.cx.screenWidth
            case .bottom: aView.cx.y = CGFloat.cx.screenHeight
            case .right: aView.cx.x = CGFloat.cx.screenWidth
            }
        } completion: { _ in
            maskView?.removeFromSuperview()
            aView.removeFromSuperview()
            self.removeFromParent()
            completion?()
            self.fpDismissHandler?()
        }
    }
    
    public func cx_presentFromCenter(_ controller: UIViewController?, completion: (() -> Void)? = nil, dismiss: @escaping () -> Void) {
        guard let vc = controller else { return }
        vc.fpDismissHandler = dismiss
        vc.fpIsFromCenter = true
        let maskView = UIView(frame: view.bounds)
        maskView.backgroundColor = UIColor.cx_color(withHexString: "#000000", alpha: 0.3)
        maskView.isUserInteractionEnabled = true
        vc.fpOverlayMaskView = maskView
        let tapGesture = UITapGestureRecognizer(target: vc, action: #selector(_onTapOverlayMaskView(_:)))
        maskView.addGestureRecognizer(tapGesture)
        addChild(vc)
        view.addSubview(maskView)
        view.addSubview(vc.view)
        var aView = vc.view!
        aView.cx.centerX = view.cx.centerX
        aView.cx.centerY = view.cx.centerY
        let animationOptions: UIView.AnimationOptions = [
            .curveEaseInOut,
            .allowUserInteraction,
            .beginFromCurrentState
        ]
        aView.alpha = 0.0
        UIView.animate(withDuration: 0.35, delay: 0.1, options: animationOptions) {
            //aView.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
            aView.alpha = 1.0
        } completion: { finished in
            //aView.transform = CGAffineTransformIdentity
            completion?()
        }
    }
    
    public func cx_dismissFromCenter(completion: (() -> Void)? = nil) {
        guard let _ = parent else { return }
        let maskView = self.cx_overlayMaskView
        let animationOptions: UIView.AnimationOptions = [
            .curveEaseInOut,
            .allowUserInteraction
        ]
        let aView = view!
        aView.alpha = 1.0
        UIView.animate(withDuration: 0.35, delay: 0.1, options: animationOptions) {
            aView.alpha = 0.0
        } completion: { finished in
            maskView?.removeFromSuperview()
            aView.removeFromSuperview()
            self.removeFromParent()
            completion?()
            self.fpDismissHandler?()
        }
    }
    
}

#endif
#endif
