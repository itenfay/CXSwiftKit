//
//  UIViewController+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

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
    public func countOfControllersStack() -> Int {
        self.base.cx_countOfControllersInStack()
    }
    
}

//MARK: -  UINavigationController

extension UIViewController {
    
    /// Check whether the stack contains a class.
    @objc public func cx_hasClassInStack(_ cls: UIViewController.Type) -> Bool {
        guard let nc = self.navigationController else {
            return false
        }
        CXLogger.log(level: .info, message: "[Stack] Info: \(nc.viewControllers)")
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
            CXLogger.log(level: .info, message: "[Stack] Info: \(reversedVcs)")
        }
    }
    
    /// Query the nearest controller in the stack.
    @objc public func cx_queryControllerInStack(_ cls: UIViewController.Type) -> UIViewController? {
        guard let nc = self.navigationController else {
            return nil
        }
        let reversedVcs = Array(nc.viewControllers.reversed())
        CXLogger.log(level: .info, message: "[Stack] Reversed Info: \(reversedVcs)")
        return reversedVcs.first { $0.isKind(of: cls) }
    }
    
    /// Query the number of a type controller in the stack.
    @objc public func cx_countOfControllerInStack(_ cls: UIViewController.Type) -> Int {
        guard let nc = self.navigationController else {
            return 0
        }
        let vcs = nc.viewControllers.filter { $0.isKind(of: cls) }
        CXLogger.log(level: .info, message: "[Stack] Found vcs: \(vcs)")
        return vcs.count
    }
    
    /// Return the number of controllers in the stack.
    @objc public func cx_countOfControllersInStack() -> Int {
        guard let nc = self.navigationController else {
            return 0
        }
        let count = nc.viewControllers.count
        CXLogger.log(level: .info, message: "[Stack] vcs.count: \(count)")
        return count
    }
    
}
