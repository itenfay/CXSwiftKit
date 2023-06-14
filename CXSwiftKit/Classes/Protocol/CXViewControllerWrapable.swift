//
//  CXViewControllerWrapable.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

#if os(iOS) || os(tvOS)
import UIKit

@objc public enum CXOverlayDirection: UInt8 {
    case top, left, bottom, right
}

@objc public protocol CXViewControllerWrapable: AnyObject {
    func cx_present(_ controller: UIViewController?, completion: (() -> Void)?)
    func cx_present(_ controller: UIViewController?, overlayView: UIView?, overlayRatio: CGFloat, overlayDirection: CXOverlayDirection, completion: (() -> Void)?)
    func cx_dismiss(completion: (() -> Void)?)
    func cx_dismiss(overlayView: UIView?, completion: (() -> Void)?)
}

#endif
