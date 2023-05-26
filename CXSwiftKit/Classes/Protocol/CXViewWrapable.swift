//
//  CXViewWrapable.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

#if os(iOS) || os(tvOS)
import UIKit

@objc public protocol CXViewWrapable: AnyObject {
    @objc func cx_present(_ view: UIView?, completion: (() -> Void)?)
    @objc func cx_present(_ view: UIView?, overlayView: UIView?, overlayRatio: CGFloat, overlayDirection: CXOverlayDirection, completion: (() -> Void)?)
    @objc func cx_dismiss(completion: (() -> Void)?)
    @objc func cx_dismiss(overlayView: UIView?, completion: (() -> Void)?)
}

#if canImport(OverlayController)
import OverlayController
#endif

public protocol CXSwiftViewWrapable: AnyObject {
    #if canImport(OverlayController)
    func cx_present(_ view: UIView?, maskStyle: OverlayMaskStyle, position: OverlayLayoutPosition, positionOffset: CGFloat, style: OverlaySlideStyle, windowLevel: OverlayWindowLevel, isDismissOnMaskTouched: Bool, isPanGestureEnabled: Bool, panDismissPercent: CGFloat, duration: TimeInterval, completion: (() -> Void)?)
    func cx_dismiss(duration: TimeInterval, completion: (() -> Void)?)
    #endif
}

#endif
