//
//  CXOverlayViewControllerWrapable.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

#if os(iOS) || os(tvOS)
import UIKit

@objc public protocol CXOverlayViewControllerWrapable: AnyObject {
    var cx_overlayMaskView: UIView? { get }
    func cx_present(_ controller: UIViewController?, overlayRatio: CGFloat, overlayDirection: CXOverlayDirection, completion: (() -> Void)?)
    func cx_dismiss(completion: (() -> Void)?)
    func cx_presentFromCenter(_ controller: UIViewController?, completion: (() -> Void)?)
    func cx_dismissFromCenter(completion: (() -> Void)?)
}

#endif
