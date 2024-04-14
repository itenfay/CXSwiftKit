//
//  ScrollView+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if os(iOS) || os(tvOS)
import UIKit

extension CXSwiftBase where T : UIScrollView {
    
    #if os(iOS)
    /// The refresh control associated with the scroll view.
    ///
    /// - Parameters:
    ///   - target: The target object—that is, the object whose action method is called.
    ///   - action: A selector identifying the action method to be called.
    ///   - attributedTitle: The styled title text to display in the refresh control.
    ///   - tintColor: The tint color for the refresh control.
    public func setupRefreshControl(_ target: Any?, action: Selector, attributedTitle: NSAttributedString? = nil, tintColor: UIColor? = nil) {
        base.cx_setupRefreshControl(target, action: action, attributedTitle: attributedTitle, tintColor: tintColor)
    }
    #endif
    
    /// Takes a snapshot of an entire ScrollView
    public var entireSnapshot: UIImage? {
        return base.cx_entireSnapshot
    }
    
}

extension UIScrollView {
    
    #if os(iOS)
    /// The refresh control associated with the scroll view.
    ///
    /// - Parameters:
    ///   - target: The target object—that is, the object whose action method is called.
    ///   - action: A selector identifying the action method to be called.
    ///   - attributedTitle: The styled title text to display in the refresh control.
    ///   - tintColor: The tint color for the refresh control.
    @objc public func cx_setupRefreshControl(_ target: Any?, action: Selector, attributedTitle: NSAttributedString? = nil, tintColor: UIColor? = nil) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: action, for: .valueChanged)
        refreshControl.attributedTitle = attributedTitle
        if tintColor != nil {
            refreshControl.tintColor = tintColor!
        }
        self.refreshControl = refreshControl
    }
    #endif
    
    /// Takes a snapshot of an entire ScrollView
    @objc public var cx_entireSnapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(contentSize, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        let previousFrame = frame
        frame = CGRect(origin: frame.origin, size: contentSize)
        layer.render(in: context)
        frame = previousFrame
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}

#endif
