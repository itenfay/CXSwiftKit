//
//  Application+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if os(iOS) || os(tvOS)
import UIKit

extension CXSwiftBase where T : UIApplication {
    
    /// Returns an array of windows which is active in the foreground.
    public var foregroundActiveWindows: [UIWindow]? {
        return base.cx_foregroundActiveWindows
    }
    
    /// Returns an array of windows which is running in the background.
    public var backgroundWindows: [UIWindow]? {
        return base.cx_backgroundWindows
    }
    
    /// Returns the key window in the foreground.
    public var keyWindow: UIWindow? {
        return base.cx_keyWindow
    }
    
    /// Returns the key window in the background.
    public var backgroundKeyWindow: UIWindow? {
        return base.cx_backgroundKeyWindow
    }
    
    /// Returns the navigation controller of the current view controller.
    public var currentNavigationController: UINavigationController?
    {
        return base.cx_currentNavigationController
    }
    
    /// Returns the current visible view controller.
    public var currentController: UIViewController?
    {
        return base.cx_currentController
    }
    
    /// Returns the current visible view controller by the specified view controller.
    public func queryCurrentControllerBy(controller: UIViewController?) -> UIViewController?
    {
        return base.cx_queryCurrentControllerBy(controller: controller)
    }
    
    public static func instantiateView(
        _ viewType: UIView.Type,
        inBundle bundle: Bundle? = nil) -> UIView?
    {
        return UIApplication.cx_instantiateView(viewType, inBundle: bundle)
    }
    
    public static func instantiateViewController(
        _ viewControllerType: UIViewController.Type,
        inBundle bundle: Bundle? = nil) -> UIViewController?
    {
        return UIApplication.cx_instantiateViewController(viewControllerType, inBundle: bundle)
    }
    
    public static func instantiateSbViewController(
        _ viewControllerType: UIViewController.Type,
        inBundle bundle: Bundle? = nil,
        withIdentifier identifier: String? = nil) -> UIViewController?
    {
        return UIApplication.cx_instantiateSbViewController(viewControllerType, inBundle: bundle, withIdentifier: identifier)
    }
    
}

extension UIApplication {
    
    /// Returns an array of windows which is active in the foreground.
    @objc public var cx_foregroundActiveWindows: [UIWindow]? {
        if #available(iOS 13.0, tvOS 13.0, *) {
            return connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows
        }
        return UIApplication.shared.windows
    }
    
    /// Returns an array of windows which is running in the background.
    @objc public var cx_backgroundWindows: [UIWindow]? {
        if #available(iOS 13.0, tvOS 13.0, *) {
            return connectedScenes
                .filter({ $0.activationState == .background })
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows
        }
        return UIApplication.shared.windows
    }
    
    /// Returns the key window in the foreground.
    @objc public var cx_keyWindow: UIWindow? {
        return cx_foregroundActiveWindows?
            .filter({ $0.isKeyWindow }).first
    }
    
    /// Returns the key window in the background.
    @objc public var cx_backgroundKeyWindow: UIWindow? {
        return cx_backgroundWindows?
            .filter({ $0.isKeyWindow }).first
    }
    
    /// Returns the navigation controller of the current view controller.
    @objc public var cx_currentNavigationController: UINavigationController?
    {
        return cx_currentController?.navigationController
    }
    
    /// Returns the current visible view controller.
    @objc public var cx_currentController: UIViewController?
    {
        return cx_queryCurrentControllerBy(controller: cx_keyWindow?.rootViewController)
    }
    
    /// Returns the current visible view controller by the specified view controller.
    @objc public func cx_queryCurrentControllerBy(controller: UIViewController?) -> UIViewController?
    {
        if let tabBarController = controller as? UITabBarController {
            if let selectedVC = tabBarController.selectedViewController {
                return cx_queryCurrentControllerBy(controller: selectedVC)
            }
        }
        if let navigationController = controller as? UINavigationController {
            if let visibleVC = navigationController.visibleViewController {
                return cx_queryCurrentControllerBy(controller: visibleVC)
            }
        }
        if let presentedController = controller?.presentedViewController {
            return cx_queryCurrentControllerBy(controller: presentedController)
        }
        return controller
    }
    
}

//MARK: - Xib & Storyboard

extension UIApplication {
    
    @objc public static func cx_instantiateView(
        _ viewType: UIView.Type) -> UIView?
    {
        return cx_instantiateView(viewType, inBundle: nil)
    }
    
    @objc public static func cx_instantiateView(
        _ viewType: UIView.Type,
        inBundle bundle: Bundle?) -> UIView?
    {
        return cxInstantiateXibView(viewType, bundle: bundle)
    }
    
    @objc public static func cx_instantiateViewController(
        _ viewControllerType: UIViewController.Type) -> UIViewController?
    {
        return cx_instantiateViewController(viewControllerType, inBundle: nil)
    }
    
    @objc public static func cx_instantiateViewController(
        _ viewControllerType: UIViewController.Type,
        inBundle bundle: Bundle?) -> UIViewController?
    {
        return cxInstantiateXibViewController(viewControllerType, bundle: bundle)
    }
    
    @objc public static func cx_instantiateSbViewController(
        _ viewControllerType: UIViewController.Type) -> UIViewController?
    {
        return cx_instantiateSbViewController(viewControllerType, inBundle: nil)
    }
    
    @objc public static func cx_instantiateSbViewController(
        _ viewControllerType: UIViewController.Type,
        inBundle bundle: Bundle?) -> UIViewController?
    {
        return cx_instantiateSbViewController(viewControllerType, inBundle: bundle, withIdentifier: nil)
    }
    
    @objc public static func cx_instantiateSbViewController(
        _ viewControllerType: UIViewController.Type,
        inBundle bundle: Bundle?,
        withIdentifier identifier: String?) -> UIViewController?
    {
        return cxInstantiateSbViewController(viewControllerType, bundle: bundle, withIdentifier: identifier)
    }
    
}

#endif
