//
//  UIApplication+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if canImport(UIKit)
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
    public func cx_queryCurrentControllerBy(controller: UIViewController?) -> UIViewController?
    {
        return base.cx_queryCurrentControllerBy(controller: controller)
    }
    
    /// Triggers the medium impact feedback.
    @discardableResult
    public func makeImpactFeedback() -> UIImpactFeedbackGenerator
    {
        return base.cx_makeImpactFeedback()
    }
    
    /// Triggers impact feedback.
    @discardableResult
    public func makeImpactFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) -> UIImpactFeedbackGenerator
    {
        return base.cx_makeImpactFeedback(style)
    }
    
    /// Triggers selection feedback.
    @discardableResult
    public func makeSelectionFeedback() -> UISelectionFeedbackGenerator
    {
        return base.cx_makeSelectionFeedback()
    }
    
    /// Triggers notification feedback.
    @discardableResult
    public func makeNotificationFeedback(_ notificationType: UINotificationFeedbackGenerator.FeedbackType) -> UINotificationFeedbackGenerator
    {
        return base.cx_makeNotificationFeedback(notificationType)
    }
    
    public static func cx_loadView(
        _ viewType: UIView.Type,
        inBundle bundle: Bundle? = nil) -> UIView?
    {
        return UIApplication.cx_loadView(viewType, inBundle: bundle)
    }
    
    public static func cx_loadViewController(
        _ viewControllerType: UIViewController.Type,
        inBundle bundle: Bundle? = nil) -> UIViewController?
    {
        return UIApplication.cx_loadViewController(viewControllerType, inBundle: bundle)
    }
    
    public static func cx_loadViewControllerFromStoryboard(
        _ viewControllerType: UIViewController.Type,
        inBundle bundle: Bundle? = nil) -> UIViewController?
    {
        return UIApplication.cx_loadViewControllerFromStoryboard(viewControllerType, inBundle: bundle)
    }
    
}

extension UIApplication {
    
    /// Returns an array of windows which is active in the foreground.
    @objc public var cx_foregroundActiveWindows: [UIWindow]? {
        if #available(iOS 13.0, *) {
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
        if #available(iOS 13.0, *) {
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

//MARK: - Feedback

extension UIApplication {
    
    /// Triggers the medium impact feedback.
    @discardableResult
    @objc public func cx_makeImpactFeedback() -> UIImpactFeedbackGenerator
    {
        return cx_makeImpactFeedback(.medium)
    }
    
    /// Triggers impact feedback.
    @discardableResult
    @objc public func cx_makeImpactFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) -> UIImpactFeedbackGenerator
    {
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: style)
        impactFeedbackGenerator.prepare()
        impactFeedbackGenerator.impactOccurred()
        return impactFeedbackGenerator
    }
    
    /// Triggers selection feedback.
    @discardableResult
    @objc public func cx_makeSelectionFeedback() -> UISelectionFeedbackGenerator
    {
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()
        return selectionFeedbackGenerator
    }
    
    /// Triggers notification feedback.
    @discardableResult
    @objc public func cx_makeNotificationFeedback(_ notificationType: UINotificationFeedbackGenerator.FeedbackType) -> UINotificationFeedbackGenerator
    {
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(notificationType)
        return notificationFeedbackGenerator
    }
    
}

//MARK: - Xib & Storyboard

extension UIApplication {
    
    @objc public static func cx_loadView(
        _ viewType: UIView.Type,
        inBundle bundle: Bundle? = nil) -> UIView?
    {
        return cxLoadViewFromXib(viewType, bundle: bundle)
    }
    
    @objc public static func cx_loadViewController(
        _ viewControllerType: UIViewController.Type,
        inBundle bundle: Bundle? = nil) -> UIViewController?
    {
        return cxLoadViewControllerFromXib(viewControllerType, bundle: bundle)
    }
    
    @objc public static func cx_loadViewControllerFromStoryboard(
        _ viewControllerType: UIViewController.Type,
        inBundle bundle: Bundle? = nil) -> UIViewController?
    {
        return cxLoadViewControllerFromStoryboard(viewControllerType, bundle: bundle)
    }
    
}

#endif
