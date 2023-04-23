//
//  CXViewControllerWrapable.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

#if canImport(UIKit)
import UIKit

@objc public enum CXOverlayDirection: UInt8 {
    case top, left, bottom, right
}

@objc public protocol CXViewControllerWrapable: AnyObject {
    @objc func cx_present(_ controller: UIViewController?, completion: (() -> Void)?)
    @objc func cx_present(_ controller: UIViewController?, overlayView: UIView?, overlayRatio: CGFloat, overlayDirection: CXOverlayDirection, completion: (() -> Void)?)
    @objc func cx_dismiss(completion: (() -> Void)?)
    @objc func cx_dismiss(overlayView: UIView?, completion: (() -> Void)?)
}

#endif
