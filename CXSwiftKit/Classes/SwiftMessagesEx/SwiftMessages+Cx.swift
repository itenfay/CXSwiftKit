//
//  SwiftMessages+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/7/31.
//

import Foundation
#if os(iOS)
import UIKit
#if canImport(SwiftMessages)
import SwiftMessages

@objc public enum CXMessagesBoxStyle: UInt8, CustomStringConvertible {
    case light, dark
    
    public var description: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

//MARK: - SwiftMessagesWrapable

@objc public protocol SwiftMessagesWrapable {
    // iOS
    func cx_showMessages(withStyle style: CXMessagesBoxStyle, body: String?)
    func cx_showMessages(withStyle style: CXMessagesBoxStyle, title: String?, body: String?)
    func cx_showMessages(withStyle style: CXMessagesBoxStyle, title: String?, body: String?, textAlignment: NSTextAlignment)
    func cx_showMessages(withStyle style: CXMessagesBoxStyle, title: String?, body: String?, textAlignment: NSTextAlignment, iconImage: UIImage?, iconText: String?, buttonImage: UIImage?, buttonTitle: String?, buttonTapHandler: ((_ button: UIButton) -> Void)?)
    func cx_hideMessages()
}

//extension CXSwiftBase where T : NSObject {
//    
//    public func showMessages(withStyle style: CXMessagesBoxStyle, body: String?)
//    {
//        base.cx_showMessages(withStyle: style, body: body)
//    }
//    
//    public func showMessages(withStyle style: CXMessagesBoxStyle, title: String?, body: String?)
//    {
//        base.cx_showMessages(withStyle: style, title: title, body: body)
//    }
//    
//    public func showMessages(withStyle style: CXMessagesBoxStyle, title: String?, body: String?, textAlignment: NSTextAlignment)
//    {
//        base.cx_showMessages(withStyle: style, title: title, body: body, textAlignment: textAlignment)
//    }
//    
//    public func showMessages(
//        withStyle style: CXMessagesBoxStyle,
//        title: String?,
//        body: String?,
//        textAlignment: NSTextAlignment,
//        iconImage: UIImage?,
//        iconText: String?,
//        buttonImage: UIImage?,
//        buttonTitle: String?,
//        buttonTapHandler: ((_ button: UIButton) -> Void)?)
//    {
//        base.cx_showMessages(withStyle: style,
//                             title: title,
//                             body: body,
//                             textAlignment: textAlignment,
//                             iconImage: iconImage,
//                             iconText: iconText,
//                             buttonImage: buttonImage,
//                             buttonTitle: buttonTitle,
//                             buttonTapHandler: buttonTapHandler)
//    }
//    
//    public func hideMessages()
//    {
//        base.cx_hideMessages()
//    }
//    
//}

extension NSObject: SwiftMessagesWrapable {
    
    public func cx_showMessages(withStyle style: CXMessagesBoxStyle, body: String?)
    {
        cx_showMessages(withStyle: style, title: nil, body: body)
    }
    
    public func cx_showMessages(withStyle style: CXMessagesBoxStyle, title: String?, body: String?)
    {
        cx_showMessages(withStyle: style, title: title, body: body, textAlignment: .center)
    }
    
    public func cx_showMessages(withStyle style: CXMessagesBoxStyle, title: String?, body: String?, textAlignment: NSTextAlignment)
    {
        cx_showMessages(withStyle: style,
                        title: title, body: body,
                        textAlignment: textAlignment,
                        iconImage: nil,iconText: nil,
                        buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
    }
    
    public func cx_showMessages(
        withStyle style: CXMessagesBoxStyle,
        title: String?,
        body: String?,
        textAlignment: NSTextAlignment,
        iconImage: UIImage?,
        iconText: String?,
        buttonImage: UIImage?,
        buttonTitle: String?,
        buttonTapHandler: ((_ button: UIButton) -> Void)?)
    {
        let infoView = MessageView.viewFromNib(layout: .cardView)
        infoView.configureTheme(.info)
        infoView.configureDropShadow()
        infoView.configureContent(title: title, body: body, iconImage: iconImage, iconText: iconText, buttonImage: buttonImage, buttonTitle: buttonTitle, buttonTapHandler: buttonTapHandler)
        infoView.backgroundView.backgroundColor = style == .dark
        ? UIColor.cx_color(withHexString: "#000000", alpha: 0.6)
        : UIColor.cx_color(withHexString: "#FFFFFF")
        if title != nil {
            infoView.titleLabel?.textColor = style == .dark
            ? UIColor.cx_color(withHexString: "#FFFFFF", alpha: 1.0)
            : UIColor.cx_color(withHexString: "0x333333")
            infoView.titleLabel?.textAlignment = textAlignment
        }
        if body != nil {
            infoView.bodyLabel?.textColor = style == .dark
            ? UIColor.cx_color(withHexString: "#FFFFFF", alpha: 1.0)
            : UIColor.cx_color(withHexString: "0x333333")
            infoView.bodyLabel?.textAlignment = textAlignment
        }
        if buttonTitle != nil {
            infoView.button?.isHidden = false
            infoView.button?.backgroundColor = UIColor.cx_color(withHexString: "0xFFCD4D")
            infoView.button?.setTitleColor(style == .dark
                                           ? UIColor.cx_color(withHexString: "#FFFFFF", alpha: 1.0)
                                           : UIColor.cx_color(withHexString: "0x333333"), for: .normal)
        } else {
            infoView.button?.isHidden = buttonImage != nil ? false : true
        }
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: infoConfig, view: infoView)
    }
    
    public func cx_hideMessages()
    {
        SwiftMessages.hideAll()
    }
    
}

#endif
#endif
