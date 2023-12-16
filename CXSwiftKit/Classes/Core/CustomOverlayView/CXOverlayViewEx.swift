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
    public func present(_ view: UIView?, overlayRatio: CGFloat = 0.7, overlayDirection: CXOverlayDirection = .bottom, completion: (() -> Void)? = nil) {
        self.base.cx_present(view, overlayRatio: overlayRatio, overlayDirection: overlayDirection, completion: completion)
    }
    
    /// Dismiss the presenting view, the overlay view is subview of the view.
    public func dismiss(completion: (() -> Void)? = nil)
    {
        self.base.cx_dismiss(completion: completion)
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
    
    private var cx_overlayMaskView: UIView? {
        get {
            return objc_getAssociatedObject(self,&CXAssociatedKey.presentOverlayMask) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &CXAssociatedKey.presentOverlayMask, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Present the view, the overlay view is subview of the view.
    public func cx_present(_ view: UIView?, overlayRatio: CGFloat = 0.7, overlayDirection: CXOverlayDirection = .bottom, completion: (() -> Void)? = nil) {
        guard let _view = view else { return }
        _view.cx_overlayDirection = overlayDirection
        let maskView = UIView(frame: self.bounds)
        maskView.backgroundColor = UIColor.cx_color(withHexString: "#000000", alpha: 0.3)
        _view.cx_overlayMaskView = maskView
        addSubview(maskView)
        addSubview(_view)
        var aView = _view
        let ratio: CGFloat = overlayRatio
        switch overlayDirection {
        case .top:
            aView.cx.height = ratio * self.cx.height
            aView.cx.y = -ratio * aView.cx.height
        case .left:
            aView.cx.width = ratio * self.cx.width
            aView.cx.x = -ratio * aView.cx.width
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
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: animationOptions) {
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
        assert(cx_overlayDirection != nil, "Please invoke dismiss(::) method with the presenting view.")
        let overlayDirection = cx_overlayDirection!
        let maskView = cx_overlayMaskView
        let animationOptions: UIView.AnimationOptions = [
            .curveEaseInOut,
            .allowUserInteraction
        ]
        var aView = self
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: animationOptions) {
            switch overlayDirection {
            case .top: aView.cx.y = -CGFloat.cx.screenHeight
            case .left: aView.cx.x = -CGFloat.cx.screenWidth
            case .bottom: aView.cx.y = CGFloat.cx.screenHeight
            case .right: aView.cx.x = CGFloat.cx.screenWidth
            }
        } completion: { _ in
            maskView?.removeFromSuperview()
            self.removeFromSuperview()
            completion?()
        }
    }
    
}
#endif

extension CXSwiftBase where T : CXViewController {
    
    #if os(iOS) || os(tvOS)
    /// Present the view controller, the overlay view is subview of the controller's view
    public func present(_ controller: UIViewController?, overlayRatio: CGFloat = 0.7, overlayDirection: CXOverlayDirection = .bottom, completion: (() -> Void)? = nil) {
        self.base.cx_present(controller, overlayRatio: overlayRatio, overlayDirection: overlayDirection, completion: completion)
    }
    
    /// Dismiss the view controller.
    public func dismiss(completion: (() -> Void)? = nil) {
        self.base.cx_dismiss(completion: completion)
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
    
    private var cx_overlayMaskView: UIView? {
        get {
            return objc_getAssociatedObject(self, &CXAssociatedKey.presentOverlayMask) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &CXAssociatedKey.presentOverlayMask, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Present the view controller, the overlay view is subview of the controller's view
    public func cx_present(_ controller: UIViewController?, overlayRatio: CGFloat = 0.7, overlayDirection: CXOverlayDirection = .bottom, completion: (() -> Void)? = nil) {
        guard let vc = controller else { return }
        vc.cx_overlayDirection = overlayDirection
        let maskView = UIView(frame: view.bounds)
        maskView.backgroundColor = UIColor.cx_color(withHexString: "#000000", alpha: 0.3)
        vc.cx_overlayMaskView = maskView
        addChild(vc)
        view.addSubview(maskView)
        view.addSubview(vc.view)
        var aView = vc.view!
        let ratio: CGFloat = overlayRatio
        switch overlayDirection {
        case .top:
            aView.cx.height = ratio * view.cx.height
            aView.cx.y = -ratio * aView.cx.height
        case .left:
            aView.cx.width = ratio * view.cx.width
            aView.cx.x = -ratio * aView.cx.width
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
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: animationOptions) {
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
        assert(cx_overlayDirection != nil, "Please invoke dismiss(::) method with the presenting view controller.")
        let overlayDirection = cx_overlayDirection!
        let maskView = self.cx_overlayMaskView
        let animationOptions: UIView.AnimationOptions = [
            .curveEaseInOut,
            .allowUserInteraction
        ]
        var aView = view!
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: animationOptions) {
            switch overlayDirection {
            case .top: aView.cx.y = -CGFloat.cx.screenHeight
            case .left: aView.cx.x = -CGFloat.cx.screenWidth
            case .bottom: aView.cx.y = CGFloat.cx.screenHeight
            case .right: aView.cx.x = CGFloat.cx.screenWidth
            }
        } completion: { _ in
            maskView?.removeFromSuperview()
            self.view.removeFromSuperview()
            self.removeFromParent()
            completion?()
        }
    }
    
}

#endif

#endif
