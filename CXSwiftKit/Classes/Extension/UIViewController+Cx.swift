//
//  UIViewController+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if os(iOS) || os(tvOS)
import UIKit

extension CXSwiftBase where T : UIViewController {
    
    /// Check whether the stack contains a class.
    public func hasClassInStack<T>(_ cls: T.Type) -> Bool where T : UIViewController {
        return self.base.cx_hasClassInStack(cls)
    }
    
    /// Remove a set of controllers from the stack, also include self.
    public func removeControllersFromStack(_ clses: [UIViewController.Type]) {
        self.base.cx_removeControllersFromStack(clses)
    }
    
    /// Query the nearest controller in the stack.
    public func queryControllerInStack<T>(_ cls: T.Type) -> T? where T : UIViewController {
        return self.base.cx_queryControllerInStack(cls) as? T
    }
    
    /// Query the number of a type controller in the stack.
    public func countOfControllerInStack<T>(_ cls: T.Type) -> Int where T : UIViewController {
        return self.base.cx_countOfControllerInStack(cls)
    }
    
    /// Return the number of controllers in the stack.
    public var countOfControllersStack: Int {
        self.base.cx_countOfControllersInStack
    }
    
    /// Return an array of children view controllers.
    /// This array does not include any presented view controllers.
    public var children: [UIViewController] {
        self.base.cx_children
    }
    
    /// Embed the specified child controller in the specified view.
    public func embedChild(controller: UIViewController, inView view: UIView? = nil) {
        self.base.cx_embedChild(controller: controller, inView: view)
    }
    
    /// Remove the specified child controller from the parent controller.
    public func removeChild(controller: UIViewController) {
        self.base.cx_removeChild(controller: controller)
    }
    
    /// Present the view controller.
    public func present(_ controller: UIViewController?, completion: (() -> Void)? = nil) {
        self.base.cx_present(controller, completion: completion)
    }
    
    /// Present the view controller, the overlay view is subview of the controller's view
    public func present(_ controller: UIViewController?, overlayView: UIView?, overlayRatio: CGFloat = 0.7, overlayDirection: CXOverlayDirection = .bottom, completion: (() -> Void)? = nil) {
        self.base.cx_present(controller, overlayView: overlayView, overlayRatio: overlayRatio, overlayDirection: overlayDirection, completion: completion)
    }
    
    /// Dismiss the view controller.
    public func dismiss(completion: (() -> Void)? = nil) {
        self.base.cx_dismiss(completion: completion)
    }
    
    /// Dismiss the view controller, the overlay view is subview of the controller's view
    public func dismiss(overlayView: UIView?, completion: (() -> Void)? = nil) {
        self.base.cx_dismiss(overlayView: overlayView, completion: completion)
    }
    
}

//MARK: -  UIViewController

extension UIViewController {
    
    /// Check whether the stack contains a class.
    @objc public func cx_hasClassInStack(_ cls: UIViewController.Type) -> Bool {
        guard let nc = self.navigationController else {
            return false
        }
        CXLogger.log(level: .info, message: "[Stack] vcs: \(nc.viewControllers)")
        for vc in nc.viewControllers {
            if vc.isKind(of: cls) {
                return true
            }
        }
        return false
    }
    
    /// Remove a set of controllers from the stack, also include self.
    @objc public func cx_removeControllersFromStack(_ clses: [UIViewController.Type]) {
        DispatchQueue.cx.mainAsyncAfter(0.2) {
            guard let nc = self.navigationController else {
                return
            }
            var vcs: [UIViewController] = []
            vcs.append(contentsOf: nc.viewControllers.reversed())
            vcs.removeAll { $0 == self }
            for cls in clses {
                vcs.removeAll { $0.isKind(of: cls) }
            }
            let reversedVcs = Array.init(vcs.reversed())
            nc.viewControllers = Array.init(reversedVcs)
            CXLogger.log(level: .info, message: "[Stack] vcs: \(reversedVcs)")
        }
    }
    
    /// Query the nearest controller in the stack.
    @objc public func cx_queryControllerInStack(_ cls: UIViewController.Type) -> UIViewController? {
        guard let nc = self.navigationController else {
            return nil
        }
        let reversedVcs = Array(nc.viewControllers.reversed())
        CXLogger.log(level: .info, message: "[Stack] vcs: \(reversedVcs)")
        return reversedVcs.first { $0.isKind(of: cls) }
    }
    
    /// Query the number of a type controller in the stack.
    @objc public func cx_countOfControllerInStack(_ cls: UIViewController.Type) -> Int {
        guard let nc = self.navigationController else {
            return 0
        }
        let vcs = nc.viewControllers.filter { $0.isKind(of: cls) }
        CXLogger.log(level: .info, message: "[Stack] vcs: \(vcs)")
        return vcs.count
    }
    
    /// Return the number of controllers in the stack.
    @objc public var cx_countOfControllersInStack: Int {
        guard let nc = self.navigationController else {
            return 0
        }
        let count = nc.viewControllers.count
        CXLogger.log(level: .info, message: "[Stack] vcs.count: \(count)")
        return count
    }
    
    /// Return an array of children view controllers.
    /// This array does not include any presented view controllers.
    @objc public var cx_children: [UIViewController]
    {
        return self.children
    }
    
}

extension UIViewController {
    
    /// Embed the specified child controller in the specified view.
    @objc public func cx_embedChild(controller: UIViewController) {
        cx_embedChild(controller: controller, inView: nil)
    }
    
    /// Embed the specified child controller in the specified view.
    @objc public func cx_embedChild(controller: UIViewController, inView view: UIView?) {
        self.addChild(controller)
        controller.view.cx.constrain(to: view ?? self.view)
        controller.didMove(toParent: self)
    }
    
    /// Remove the specified child controller from the parent controller.
    @objc public func cx_removeChild(controller: UIViewController) {
        controller.willMove(toParent: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParent()
    }
    
}

//MARK: - CXViewControllerWrapable

extension UIViewController: CXViewControllerWrapable {
    
    private var cx_overlayDirection: CXOverlayDirection? {
        get {
            return objc_getAssociatedObject(self, &CXAssociatedKey.presentOverlayDirection) as? CXOverlayDirection
        }
        set {
            objc_setAssociatedObject(self, &CXAssociatedKey.presentOverlayDirection, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// Present the view controller.
    public func cx_present(_ controller: UIViewController?, completion: (() -> Void)? = nil) {
        cx_present(controller, overlayView: nil, overlayRatio: 1.0, overlayDirection: .bottom, completion: completion)
    }
    
    /// Present the view controller, the overlay view is subview of the controller's view
    public func cx_present(_ controller: UIViewController?, overlayView: UIView?, overlayRatio: CGFloat = 0.7, overlayDirection: CXOverlayDirection = .bottom, completion: (() -> Void)? = nil) {
        guard let vc = controller else { return }
        addChild(vc)
        view.addSubview(vc.view)
        vc.cx_overlayDirection = overlayDirection
        var aView = overlayView ?? vc.view!
        let ratio: CGFloat = overlayView != nil ? overlayRatio : 1.0
        switch overlayDirection {
        case .top: aView.cx.y = -ratio * aView.cx.height
        case .left: aView.cx.x = -ratio * aView.cx.width
        case .bottom: aView.cx.y = CGFloat.cx.screenHeight
        case .right: aView.cx.x = CGFloat.cx.screenWidth
        }
        let animationOptions: UIView.AnimationOptions = [
            .curveEaseInOut,
            .allowUserInteraction,
            .beginFromCurrentState
        ]
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: animationOptions) {
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
    
    /// Dismiss the view controller.
    public func cx_dismiss(completion: (() -> Void)? = nil) {
        cx_dismiss(overlayView: nil, completion: completion)
    }
    
    /// Dismiss the view controller, the overlay view is subview of the controller's view
    public func cx_dismiss(overlayView: UIView?, completion: (() -> Void)? = nil) {
        guard let _ = parent, let overlayDirection = cx_overlayDirection else {
            return
        }
        let animationOptions: UIView.AnimationOptions = [
            .curveEaseInOut,
            .allowUserInteraction,
            .beginFromCurrentState
        ]
        var aView = overlayView ?? view!
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: animationOptions) {
            switch overlayDirection {
            case .top: aView.cx.y = -CGFloat.cx.screenHeight
            case .left: aView.cx.x = -CGFloat.cx.screenWidth
            case .bottom: aView.cx.y = CGFloat.cx.screenHeight
            case .right: aView.cx.x = CGFloat.cx.screenWidth
            }
        } completion: { _ in
            self.view.removeFromSuperview()
            self.removeFromParent()
                completion?()
        }
    }
    
}

#endif
