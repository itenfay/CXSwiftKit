//
//  CXCommonWrapable.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

#if os(iOS) || os(tvOS)
import UIKit
#if canImport(SVProgressHUD)
import SVProgressHUD
#endif
#if canImport(SwiftMessages)
import SwiftMessages
#endif
#if canImport(Toaster)
import Toaster
#endif

@objc public enum CXMessagesBoxStyle: UInt8, CustomStringConvertible {
    case light, dark
    
    public var description: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

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

@objc public protocol CXCommonWrapable {
    #if canImport(SVProgressHUD)
    @objc func cx_showProgressHUD(withStatus status: String?)
    @objc func cx_showProgressHUD(withStatus status: String?, delay: TimeInterval)
    @objc func cx_dismissProgressHUD()
    @objc func cx_dismissProgressHUD(withDelay delay: TimeInterval)
    #endif
    
    #if canImport(SwiftMessages)
    @objc func cx_showMessages(withStyle style: CXMessagesBoxStyle, body: String?)
    @objc func cx_showMessages(withStyle style: CXMessagesBoxStyle, title: String?, body: String?)
    @objc func cx_showMessages(withStyle style: CXMessagesBoxStyle, title: String?, body: String?, textAlignment: NSTextAlignment)
    @objc func cx_showMessages(withStyle style: CXMessagesBoxStyle, title: String?, body: String?, textAlignment: NSTextAlignment, iconImage: UIImage?, iconText: String?, buttonImage: UIImage?, buttonTitle: String?, buttonTapHandler: ((_ button: UIButton) -> Void)?)
    @objc func cx_hideMessages()
    #endif
    
    #if canImport(Toaster)
    @objc func cx_resetToasterAppearance()
    @objc func cx_setupToasterAppearance(withBottomOffsetPortrait bottomOffsetPortrait: CGFloat, maxWidthRatio: CGFloat)
    @objc func cx_toasterDuration(_ type: CXToasterDurationType, block: (() -> TimeInterval)?) -> TimeInterval
    @objc func cx_makeToast(text: String)
    @objc func cx_makeToast(text: String, delay: TimeInterval, duration: TimeInterval)
    @objc func cx_makeToast(attributedString: NSAttributedString)
    @objc func cx_makeToast(attributedString: NSAttributedString, delay: TimeInterval, duration: TimeInterval)
    #endif
}

#endif
