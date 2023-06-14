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
    // iOS || tvOS
    #if canImport(SVProgressHUD)
    func cx_showProgressHUD(withStatus status: String?)
    func cx_showProgressHUD(withStatus status: String?, delay: TimeInterval)
    func cx_dismissProgressHUD()
    func cx_dismissProgressHUD(withDelay delay: TimeInterval)
    #endif
    
    // iOS
    #if canImport(SwiftMessages)
    func cx_showMessages(withStyle style: CXMessagesBoxStyle, body: String?)
    func cx_showMessages(withStyle style: CXMessagesBoxStyle, title: String?, body: String?)
    func cx_showMessages(withStyle style: CXMessagesBoxStyle, title: String?, body: String?, textAlignment: NSTextAlignment)
    func cx_showMessages(withStyle style: CXMessagesBoxStyle, title: String?, body: String?, textAlignment: NSTextAlignment, iconImage: UIImage?, iconText: String?, buttonImage: UIImage?, buttonTitle: String?, buttonTapHandler: ((_ button: UIButton) -> Void)?)
    func cx_hideMessages()
    #endif
    
    // iOS, e.g.:
    // func setupToaster()
    // {
    //    ToastCenter.default.isQueueEnabled = false
    //    ToastView.appearance().bottomOffsetPortrait = cxScreenHeight/2 - 10
    //    let sizeScale: CGFloat = (CGFloat.cx.screenWidth < 375) ? 0.9 : 1.0
    //    ToastView.appearance().font = UIFont.systemFont(ofSize: sizeScale * 16)
    // }
    #if canImport(Toaster)
    func cx_restoreToasterAppearance()
    func cx_setupToasterAppearance(withBottomOffsetPortrait bottomOffsetPortrait: CGFloat, maxWidthRatio: CGFloat)
    func cx_toasterDuration(_ type: CXToasterDurationType, block: (() -> TimeInterval)?) -> TimeInterval
    func cx_makeToast(text: String)
    func cx_makeToast(text: String, delay: TimeInterval, duration: TimeInterval)
    func cx_makeToast(attributedString: NSAttributedString)
    func cx_makeToast(attributedString: NSAttributedString, delay: TimeInterval, duration: TimeInterval)
    #endif
    
}

#endif
