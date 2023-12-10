//
//  OverlayView+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if os(iOS)
import UIKit
#if canImport(OverlayController)
import OverlayController

//MARK: - OverlayViewWrapable

public protocol OverlayViewWrapable: AnyObject {
    func cx_ovcPresent(_ view: UIView?, maskStyle: OverlayMaskStyle, position: OverlayLayoutPosition, positionOffset: CGFloat, style: OverlaySlideStyle, windowLevel: OverlayWindowLevel, isDismissOnMaskTouched: Bool, isPanGestureEnabled: Bool, panDismissPercent: CGFloat, duration: TimeInterval, completion: (() -> Void)?, didDismiss: @escaping () -> Void)
    func cx_ovcDismiss(duration: TimeInterval, completion: (() -> Void)?)
}

extension CXSwiftBase where T : UIView {
    
    public func ovcPresent(
        _ view: UIView?,
        maskStyle: OverlayMaskStyle = .black(opacity: 0.7),
        position: OverlayLayoutPosition = .bottom,
        positionOffset: CGFloat = 0,
        style: OverlaySlideStyle = .fromToBottom,
        windowLevel: OverlayWindowLevel = .low,
        isDismissOnMaskTouched: Bool = true,
        isPanGestureEnabled: Bool = true,
        panDismissPercent: CGFloat = 0.5,
        duration: TimeInterval = 0.3,
        completion: (() -> Void)? = nil,
        didDismiss: @escaping () -> Void)
    {
        base.cx_ovcPresent(view,
                           maskStyle: maskStyle,
                           position: position,
                           positionOffset: positionOffset,
                           style: style,
                           windowLevel: windowLevel,
                           isDismissOnMaskTouched: isDismissOnMaskTouched,
                           isPanGestureEnabled: isPanGestureEnabled,
                           panDismissPercent: panDismissPercent,
                           duration: duration,
                           completion: completion,
                           didDismiss: didDismiss)
    }
    
    public func ovcDismiss(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        base.cx_ovcDismiss(duration: duration, completion: completion)
    }
    
}

extension UIView: OverlayViewWrapable {
    
    private var cx_overlayController: OverlayController? {
        get {
            return objc_getAssociatedObject(self, &CXAssociatedKey.presentByOverlayController) as? OverlayController
        }
        set (ovc) {
            objc_setAssociatedObject(self, &CXAssociatedKey.presentByOverlayController, ovc, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func cx_ovcPresent(
        _ view: UIView?,
        maskStyle: OverlayMaskStyle = .black(opacity: 0.7),
        position: OverlayLayoutPosition = .bottom,
        positionOffset: CGFloat = 0,
        style: OverlaySlideStyle = .fromToBottom,
        windowLevel: OverlayWindowLevel = .low,
        isDismissOnMaskTouched: Bool = true,
        isPanGestureEnabled: Bool = true,
        panDismissPercent: CGFloat = 0.5,
        duration: TimeInterval = 0.3,
        completion: (() -> Void)? = nil,
        didDismiss: @escaping () -> Void)
    {
        guard let overlayView = view else { return }
        overlayView.cx_overlayController = OverlayController(view: overlayView)
        overlayView.cx_overlayController?.maskStyle = maskStyle
        overlayView.cx_overlayController?.layoutPosition = position
        overlayView.cx_overlayController?.offsetSpacing = positionOffset
        overlayView.cx_overlayController?.presentationStyle = style
        overlayView.cx_overlayController?.windowLevel = windowLevel
        overlayView.cx_overlayController?.isDismissOnMaskTouched = isDismissOnMaskTouched
        overlayView.cx_overlayController?.isPanGestureEnabled = isPanGestureEnabled
        overlayView.cx_overlayController?.panDismissRatio = panDismissPercent
        overlayView.cx_overlayController?.present(in: self, duration: duration, completion: completion)
        overlayView.cx_overlayController?.didDismissClosure = { [weak oView = overlayView] ovc in
            didDismiss()
            oView?.cx_overlayController = nil
        }
    }
    
    public func cx_ovcDismiss(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        assert(cx_overlayController != nil, "Please invoke ovcDismiss(::) method with the overlay view.")
        cx_overlayController?.dissmiss(duration: duration, completion: { [weak self] in
            completion?()
            self?.cx_overlayController = nil
        })
    }
    
}

#endif
#endif
