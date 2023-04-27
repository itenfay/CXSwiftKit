//
//  NSObject+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if canImport(Foundation)
import Foundation
#if canImport(SVProgressHUD)
import SVProgressHUD
#endif
#if canImport(SwiftMessages)
import SwiftMessages
#endif
#if canImport(Toaster)
import Toaster
#endif

//MARK: - CXCommonWrapable

extension NSObject: CXCommonWrapable {
    
    #if canImport(SVProgressHUD)
    //Set up.
    //SVProgressHUD.setDefaultStyle(.dark)
    //SVProgressHUD.setDefaultMaskType(.custom)
    //SVProgressHUD.setDefaultAnimationType(.flat)
    
    /// Show progress HUD with the status.
    public func cx_showProgressHUD(withStatus status: String?)
    {
        cx_showProgressHUD(withStatus: status, delay: 0)
    }
    
    /// Show progress HUD with the status and delay.
    public func cx_showProgressHUD(withStatus status: String?, delay: TimeInterval)
    {
        if delay > 0 {
            DispatchQueue.cx.mainAsyncAfter(delay) {
                SVProgressHUD.show(withStatus: status)
            }
        } else {
            SVProgressHUD.show(withStatus: status)
        }
    }
    
    /// Dismiss progress HUD.
    public func cx_dismissProgressHUD()
    {
        cx_dismissProgressHUD(withDelay: 0.3)
    }
    
    /// Dismiss progress HUD with the delay.
    public func cx_dismissProgressHUD(withDelay delay: TimeInterval)
    {
        SVProgressHUD.dismiss(withDelay: delay)
    }
    #endif
    
    #if canImport(SwiftMessages)
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
        ? UIColor.cx.color(withHexString: "#000000", alpha: 0.8)
        : UIColor.cx.color(withHexString: "#FFFFFF")
        if title != nil {
            infoView.titleLabel?.textColor = style == .dark
            ? UIColor.cx.color(withHexString: "#FFFFFF", alpha: 0.9)
            : UIColor.cx.color(withHexString: "0x333333")
            infoView.titleLabel?.textAlignment = textAlignment
        }
        if body != nil {
            infoView.bodyLabel?.textColor = style == .dark
            ? UIColor.cx.color(withHexString: "#FFFFFF", alpha: 0.9)
            : UIColor.cx.color(withHexString: "0x333333")
            infoView.bodyLabel?.textAlignment = textAlignment
        }
        if buttonTitle != nil {
            infoView.button?.isHidden = false
            infoView.button?.backgroundColor = UIColor.cx.color(withHexString: "0xFFCD4D")
            infoView.button?.setTitleColor(style == .dark
                                           ? UIColor.cx.color(withHexString: "#FFFFFF", alpha: 0.9)
                                           : UIColor.cx.color(withHexString: "0x333333"), for: .normal)
        } else {
            infoView.button?.isHidden = true
        }
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: infoConfig, view: infoView)
    }
    
    public func cx_hideMessages()
    {
        SwiftMessages.hideAll()
    }
    #endif
    
    #if canImport(Toaster)
    //import Toast_Swift
    //
    //func setupToaster()
    //{
    //    ToastManager.shared.isTapToDismissEnabled = true
    //    ToastManager.shared.position = .top
    //    // 不启用队列
    //    ToastCenter.default.isQueueEnabled = false
    //    var style = ToastStyle()
    //    style.backgroundColor = UIColor.Material.red
    //    style.messageColor = UIColor.Material.white
    //    style.imageSize = CGSize(width: 20, height: 20)
    //    ToastManager.shared.style = style
    //    ToastView.appearance().bottomOffsetPortrait = cxScreenHeight/2 - 10
    //    let sizeScale: CGFloat = (CGFloat.cx.screenWidth < 375) ? 0.9 : 1.0
    //    ToastView.appearance().font = UIFont.systemFont(ofSize: sizeScale * 16)
    //}
    
    public func cx_resetToasterAppearance()
    {
        cx_setupToasterAppearance(withBottomOffsetPortrait: 0, maxWidthRatio: 0)
    }
    
    public func cx_setupToasterAppearance(withBottomOffsetPortrait bottomOffsetPortrait: CGFloat, maxWidthRatio: CGFloat)
    {
        let appearance = ToastView.appearance()
        appearance.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        appearance.textColor = .white
        let sizeScale: CGFloat = (CGFloat.cx.screenWidth < 375) ? 0.9 : 1.0
        appearance.font = .systemFont(ofSize: sizeScale * 16)
        appearance.textInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        if bottomOffsetPortrait > 0 {
            appearance.bottomOffsetPortrait = CGFloat.cx.tabBarHeight + bottomOffsetPortrait
        } else {
            appearance.bottomOffsetPortrait = CGFloat.cx.screenHeight/2 - 10
        }
        //appearance.cornerRadius = 10 // TODU: Ambiguous use of 'cornerRadius'
        if maxWidthRatio > 0 {
            appearance.maxWidthRatio = maxWidthRatio
        }
    }
    
    public func cx_toasterDuration(_ type: CXToasterDurationType, block: (() -> TimeInterval)?) -> TimeInterval
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
    #endif
    
}

#endif

extension NSObject: CXSwiftBaseCompatible {}

extension CXSwiftBase where T : NSObject {
    
    /// Adds an entry to the notification center to call the provided selector with the notification.
    public func addObserver(_ observer: Any, selector aSelector: Selector, name aName: Notification.Name?, object anObject: Any? = nil)
    {
        self.base.cx_addObserver(observer, selector: aSelector, name: aName, object: anObject)
    }
    
    /// Removes all entries specifying an observer from the notification center's dispatch table.
    public func removeObserver(_ observer: Any)
    {
        self.base.cx_removeObserver(observer)
    }
    
    /// Removes matching entries from the notification center's dispatch table.
    public func removeObserver(_ observer: Any, name aName: Notification.Name?, object anObject: Any? = nil)
    {
        self.base.cx_removeObserver(observer, name: aName, object: anObject)
    }
    
    /// Creates a notification with a given name and sender and posts it to the notification center.
    public func postNotification(withName name: Notification.Name, object anObject: Any? = nil)
    {
        self.base.cx_postNotification(withName: name)
    }
    
    /// Creates a notification with a given name, sender, and information and posts it to the notification center.
    public func postNotification(withName name: Notification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable: Any]? = nil)
    {
        self.base.cx_postNotification(withName: name, object: anObject, userInfo: aUserInfo)
    }
    
    #if canImport(SVProgressHUD)
    public func showProgressHUD(withStatus status: String? = nil, delay: TimeInterval = 0)
    {
        self.base.cx_showProgressHUD(withStatus: status, delay: delay)
    }
    
    public func dismissProgressHUD(withDelay delay: TimeInterval = 0.3)
    {
        self.base.cx_dismissProgressHUD(withDelay: delay)
    }
    #endif

    #if canImport(SwiftMessages)
    public func showMessages(
        withStyle style: CXMessagesBoxStyle,
        title: String? = nil,
        body: String?,
        textAlignment: NSTextAlignment = .center,
        iconImage: UIImage? = nil,
        iconText: String? = nil,
        buttonImage: UIImage? = nil,
        buttonTitle: String? = nil,
        buttonTapHandler: ((_ button: UIButton) -> Void)? = nil)
    {
        self.base.cx_showMessages(withStyle: style,
                                  title: title, body: body,
                                  textAlignment: textAlignment,
                                  iconImage: iconImage, iconText: iconText,
                                  buttonImage: buttonImage, buttonTitle: buttonTitle,
                                  buttonTapHandler: buttonTapHandler)
    }
    
    public func hideMessages()
    {
        self.base.cx_hideMessages()
    }
    #endif

    #if canImport(Toaster)
    public func resetToasterAppearance()
    {
        setupToasterAppearance()
    }
    
    public func setupToasterAppearance(withBottomOffsetPortrait bottomOffsetPortrait: CGFloat = 0, maxWidthRatio: CGFloat = 0)
    {
        self.base.cx_setupToasterAppearance(withBottomOffsetPortrait: bottomOffsetPortrait, maxWidthRatio: maxWidthRatio)
    }
    
    public func toasterDuration(_ type: CXToasterDurationType, block: (() -> TimeInterval)?) -> TimeInterval
    {
        return self.base.cx_toasterDuration(type, block: block)
    }
    
    public func makeToast(text: String, delay: TimeInterval = 0, duration: TimeInterval = Delay.short)
    {
        self.base.cx_makeToast(text: text, delay: delay, duration: duration)
    }
    
    public func makeToast(attributedString: NSAttributedString, delay: TimeInterval = 0, duration: TimeInterval = Delay.short)
    {
        self.base.cx_makeToast(attributedString: attributedString, delay: delay, duration: duration)
    }
    #endif
    
}

//MARK: - Notification

extension NSObject {
    
    /// Adds an entry to the notification center to call the provided selector with the notification.
    @objc public func cx_addObserver(_ observer: Any, selector aSelector: Selector, name aName: Notification.Name?, object anObject: Any? = nil)
    {
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: aName, object: anObject)
    }
    
    /// Removes all entries specifying an observer from the notification center's dispatch table.
    @objc public func cx_removeObserver(_ observer: Any)
    {
        NotificationCenter.default.removeObserver(observer)
    }
    
    /// Removes matching entries from the notification center's dispatch table.
    @objc public func cx_removeObserver(_ observer: Any, name aName: Notification.Name?, object anObject: Any? = nil)
    {
        guard let name = aName else {
            return
        }
        NotificationCenter.default.removeObserver(observer, name: name, object: anObject)
    }
    
    /// Creates a notification with a given name and sender and posts it to the notification center.
    @objc public func cx_postNotification(withName name: Notification.Name, object anObject: Any? = nil)
    {
        NotificationCenter.default.post(name: name, object: anObject)
    }
    
    /// Creates a notification with a given name, sender, and information and posts it to the notification center.
    @objc public func cx_postNotification(withName name: Notification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable: Any]? = nil)
    {
        NotificationCenter.default.post(name: name, object: anObject, userInfo: aUserInfo)
    }
    
}
