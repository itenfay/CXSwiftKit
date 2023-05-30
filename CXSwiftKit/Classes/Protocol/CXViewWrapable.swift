//
//  CXViewWrapable.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

#if os(iOS) || os(tvOS)
import UIKit
#if canImport(Toast_Swift)
import Toast_Swift
#endif

@objc public protocol CXViewWrapable: AnyObject {
    @objc func cx_present(_ view: UIView?, completion: (() -> Void)?)
    @objc func cx_present(_ view: UIView?, overlayView: UIView?, overlayRatio: CGFloat, overlayDirection: CXOverlayDirection, completion: (() -> Void)?)
    @objc func cx_dismiss(completion: (() -> Void)?)
    @objc func cx_dismiss(overlayView: UIView?, completion: (() -> Void)?)
    
    // iOS, e.g.:
    // func setupToast()
    // {
    //    // toggle "tap to dismiss" functionality
    //    ToastManager.shared.isTapToDismissEnabled = true
    //    //toggle queueing behavior
    //    ToastManager.shared.isQueueEnabled = true
    //    ToastManager.shared.position = .bottom
    //    var style = ToastStyle()
    //    style.backgroundColor = UIColor.Material.red
    //    style.messageColor = UIColor.Material.white
    //    style.imageSize = CGSize(width: 20, height: 20)
    //    ToastManager.shared.style = style
    // }
    #if canImport(Toast_Swift)
    @objc func cx_showToast(_ message: String?, completion: ((_ didTap: Bool) -> Void)?)
    @objc func cx_showToast(_ message: String?, image: UIImage?, completion: ((_ didTap: Bool) -> Void)?)
    @objc func cx_showToast(_ message: String?, title: String?, image: UIImage?, completion: ((_ didTap: Bool) -> Void)?)
    @objc func cx_showToast(_ message: String?, duration: TimeInterval, position: ToastPosition, title: String?, image: UIImage?, style: ToastStyle, completion: ((_ didTap: Bool) -> Void)?)
    @objc func cx_showToast(_ message: String?, duration: TimeInterval, point: CGPoint, title: String?, image: UIImage?, style: ToastStyle, completion: ((_ didTap: Bool) -> Void)?)
    @objc func cx_hideAllToasts()
    @objc func cx_showToastActivity(_ position: ToastPosition)
    @objc func cx_hideToastActivity()
    #endif
}

#if os(iOS) && canImport(OverlayController)
import OverlayController
#endif

public protocol CXSwiftViewWrapable: AnyObject {
    #if os(iOS) && canImport(OverlayController)
    func cx_present(_ view: UIView?, maskStyle: OverlayMaskStyle, position: OverlayLayoutPosition, positionOffset: CGFloat, style: OverlaySlideStyle, windowLevel: OverlayWindowLevel, isDismissOnMaskTouched: Bool, isPanGestureEnabled: Bool, panDismissPercent: CGFloat, duration: TimeInterval, completion: (() -> Void)?)
    func cx_dismiss(duration: TimeInterval, completion: (() -> Void)?)
    #endif
}

#endif
