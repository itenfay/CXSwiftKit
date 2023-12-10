//
//  CXOverlayViewWrapable.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

import Foundation

@objc public enum CXOverlayDirection: UInt8 {
    case top, left, bottom, right
}

#if os(iOS) || os(tvOS)
import UIKit

@objc public protocol CXOverlayViewWrapable: AnyObject {
    @objc func cx_present(_ view: UIView?, overlayRatio: CGFloat, overlayDirection: CXOverlayDirection, completion: (() -> Void)?)
    @objc func cx_dismiss(completion: (() -> Void)?)
}

#endif
