//
//  CXOverlayViewWrapable.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2023/3/16.
//

import Foundation

@objc public enum CXOverlayDirection: UInt8 {
    case top, left, bottom, right
}

#if os(iOS) || os(tvOS)
import UIKit

@objc public protocol CXOverlayViewWrapable: AnyObject {
    var cx_overlayMaskView: UIView? { get }
    func cx_present(_ view: UIView?, overlayRatio: CGFloat, overlayDirection: CXOverlayDirection, completion: (() -> Void)?, dismiss: @escaping () -> Void)
    func cx_dismiss(completion: (() -> Void)?)
    func cx_presentFromCenter(_ view: UIView?, completion: (() -> Void)?, dismiss: @escaping () -> Void)
    func cx_dismissFromCenter(completion: (() -> Void)?)
}

#endif
