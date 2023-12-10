//
//  Toaster+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/7/31.
//

import Foundation
#if os(iOS) || os(tvOS)
import UIKit
#if canImport(Toaster)
import Toaster

@objc public enum CXToasterDurationType: UInt8, CustomStringConvertible {
    case short, long, longer
    
    public var description: String {
        switch self {
        case .short: return "Short"
        case .long: return "Long"
        case .longer: return "Longer"
        }
    }
}

//MARK: - ToasterWrapable

@objc public protocol ToasterWrapable {
    // iOS, e.g.:
    // func setupToaster()
    // {
    //    ToastCenter.default.isQueueEnabled = false
    //    ToastView.appearance().bottomOffsetPortrait = cxScreenHeight/2 - 10
    //    let sizeScale: CGFloat = (CGFloat.cx.screenWidth < 375) ? 0.9 : 1.0
    //    ToastView.appearance().font = UIFont.systemFont(ofSize: sizeScale * 16)
    // }
    func cx_restoreToastAppearance()
    func cx_updateToastAppearance(with bottomOffsetPortrait: CGFloat, maxWidthRatio: CGFloat)
    func cx_getToastDuration(type: CXToasterDurationType, block: (() -> TimeInterval)?) -> TimeInterval
    func cx_makeToast(text: String)
    func cx_makeToast(text: String, delay: TimeInterval, duration: TimeInterval)
    func cx_makeToast(attributedString: NSAttributedString)
    func cx_makeToast(attributedString: NSAttributedString, delay: TimeInterval, duration: TimeInterval)
}

extension CXSwiftBase where T : NSObject {
    
    public func restoreToastAppearance()
    {
        base.cx_restoreToastAppearance()
    }
    
    public func updateToastAppearance(with bottomOffsetPortrait: CGFloat, maxWidthRatio: CGFloat)
    {
        base.cx_updateToastAppearance(with: bottomOffsetPortrait, maxWidthRatio: maxWidthRatio)
    }
    
    public func getToastDuration(type: CXToasterDurationType, block: (() -> TimeInterval)?) -> TimeInterval
    {
        return base.cx_getToastDuration(type: type, block: block)
    }
    
    public func makeToast(text: String)
    {
        base.cx_makeToast(text: text)
    }
    
    public func makeToast(text: String, delay: TimeInterval, duration: TimeInterval)
    {
        base.cx_makeToast(text: text, delay: delay, duration: duration)
    }
    
    public func makeToast(attributedString: NSAttributedString)
    {
        base.cx_makeToast(attributedString: attributedString)
    }
    
    public func makeToast(attributedString: NSAttributedString, delay: TimeInterval, duration: TimeInterval)
    {
        base.cx_makeToast(attributedString: attributedString, delay: delay, duration: duration)
    }
    
}

extension NSObject: ToasterWrapable {
    
    public func cx_restoreToastAppearance()
    {
        cx_updateToastAppearance(with: 0, maxWidthRatio: 0)
    }
    
    public func cx_updateToastAppearance(with bottomOffsetPortrait: CGFloat, maxWidthRatio: CGFloat)
    {
        let scrBounds = UIScreen.main.bounds
        let appearance = ToastView.appearance()
        appearance.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        appearance.textColor = .white
        let sizeScale: CGFloat = (scrBounds.width < 375) ? 0.9 : 1.0
        appearance.font = .systemFont(ofSize: sizeScale * 16)
        appearance.textInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        if bottomOffsetPortrait > 0 {
            appearance.bottomOffsetPortrait = bottomOffsetPortrait
        } else {
            appearance.bottomOffsetPortrait = scrBounds.height/2 - 10
        }
        // TODU: Ambiguous use of 'cornerRadius'
        //appearance.cornerRadius = 10
        if maxWidthRatio > 0 {
            appearance.maxWidthRatio = maxWidthRatio
        }
    }
    
    public func cx_getToastDuration(type: CXToasterDurationType, block: (() -> TimeInterval)?) -> TimeInterval
    {
        switch type {
        case .short: return Delay.short
        case .long: return Delay.long
        case .longer: return (block != nil) ? block!() : Delay.long
        }
    }
    
    public func cx_makeToast(text: String)
    {
        cx_makeToast(text: text, delay: 0, duration: Delay.short)
    }
    
    public func cx_makeToast(text: String, delay: TimeInterval, duration: TimeInterval)
    {
        Toast(text: text, delay: delay, duration: duration).show()
    }
    
    public func cx_makeToast(attributedString: NSAttributedString)
    {
        cx_makeToast(attributedString: attributedString, delay: 0, duration: Delay.short)
    }
    
    public func cx_makeToast(attributedString: NSAttributedString, delay: TimeInterval, duration: TimeInterval)
    {
        Toast(attributedText: attributedString, delay: delay, duration: duration).show()
    }
    
}

#endif
#endif
