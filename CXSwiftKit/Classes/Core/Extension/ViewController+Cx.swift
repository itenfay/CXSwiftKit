//
//  ViewController+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if os(iOS) || os(tvOS)
import UIKit

extension CXSwiftBase where T : UIViewController {
    
    /// Check whether the stack contains a class.
    public func hasClassInStack<C>(_ cls: C.Type) -> Bool where C : UIViewController {
        return self.base.cx_hasClassInStack(cls)
    }
    
    /// Remove a set of controllers from the stack, also include self.
    public func removeControllersFromStack(_ clses: [UIViewController.Type]) {
        self.base.cx_removeControllersFromStack(clses)
    }
    
    /// Query the nearest controller in the stack.
    public func queryControllerInStack<C>(_ cls: C.Type) -> C? where C : UIViewController {
        return self.base.cx_queryControllerInStack(cls) as? C
    }
    
    /// Query the number of a type controller in the stack.
    public func countOfControllerInStack<C>(_ cls: C.Type) -> Int where C : UIViewController {
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
    
    #if !os(tvOS)
    /// Add the keyboard observer.
    public func addKeyboardObserver() {
        self.base.cx_addKeyboardObserver()
    }
    
    /// Remove the keyboard observer.
    public func removeKeyboardObserver() {
        self.base.cx_removeKeyboardObserver()
    }
    #endif
    
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

//MARK: - Keyboard

#if !os(tvOS)
extension UIViewController {
    
    /// Add the keyboard observer.
    @objc public func cx_addKeyboardObserver() {
        cx.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIApplication.keyboardWillShowNotification)
        cx.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIApplication.keyboardWillHideNotification)
    }
    
    /// Remove the keyboard observer.
    @objc public func cx_removeKeyboardObserver() {
        cx.removeObserver(self, name: UIApplication.keyboardWillShowNotification)
        cx.removeObserver(self, name: UIApplication.keyboardWillHideNotification)
    }
    
    /// The keyboard will be shown.
    @objc private func keyboardWillShow(_ noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardBounds = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else {
            return
        }
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        let transform = CGAffineTransformIdentity
        UIView.animate(withDuration: animationDuration) {
            self.view.transform = CGAffineTransformTranslate(transform, 0, keyboardBounds.origin.y - self.view.frame.height)
        }
    }
    
    /// The keyboard will be hidden.
    @objc private func keyboardWillHide(_ noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        UIView.animate(withDuration: animationDuration) {
            self.view.transform = CGAffineTransformIdentity
        }
    }
    
}
#endif

#endif
