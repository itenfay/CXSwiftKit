//
//  CXGlobal.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// The width of a rectangle of the screen.
public let cxScreenWidth: CGFloat = CGFloat.cx.screenWidth
/// The height of a rectangle of the screen.
public let cxScreenHeight: CGFloat = CGFloat.cx.screenHeight

#if os(iOS)

/// The width ratio.
public let cxWidthRatio: CGFloat = cxScreenWidth / 375.0
/// The height ratio.
public let cxHeightRatio: CGFloat = cxScreenHeight / 667.0

/// Adapt dimension to scale.
public func cxAdapt(_ value: CGFloat) -> CGFloat
{
    return cxAdaptW(value)
}

/// Adapt dimension to width.
public func cxAdaptW(_ value: CGFloat) -> CGFloat
{
    return value * cxWidthRatio
}

/// Adapt dimension to height.
public func cxAdaptH(_ value: CGFloat) -> CGFloat
{
    return value * cxHeightRatio // ceil(value) * cxHeightRatio
}

/// Fit scale by the specified demension.
///
/// - Parameter dimension: The dimension to scale.
/// - Returns: A new fit dimension.
public func cxFitScaleBy(dimension: CGFloat) -> CGFloat
{
    return (cxScreenWidth / 375) * dimension
}

/// Represents the device whether is x series of iPhone.
///
/// - Returns: A boolean value represents the device whether is x series of iPhone.
public func cxIsIphoneXSeries() -> Bool
{
    var isX = false
    if #available(iOS 11.0, *) {
        let app = UIApplication.shared
        let window = app.delegate?.window ?? app.cx.keyWindow
        isX = (window?.safeAreaInsets.bottom ?? 0) > 0
    }
    return isX
}

public func cxSafeAreaInsets() -> UIEdgeInsets
{
    var insets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    if #available(iOS 11.0, *) {
        let app = UIApplication.shared
        let window = app.delegate?.window ?? app.cx.keyWindow
        insets = window?.safeAreaInsets ?? insets
    }
    return insets
}

public let cxSafeAreaTop: CGFloat = cxSafeAreaInsets().top == 0 ? 20 : cxSafeAreaInsets().top
public let cxSafeAreaBottom: CGFloat = cxSafeAreaInsets().bottom
/// The height of the status bar.
public let cxStatusBarH: CGFloat = cxSafeAreaTop
/// The height of the navigation bar.
public let cxNavBarH: CGFloat = 44 + cxStatusBarH
/// The height of the tab bar.
public let cxTabBarH: CGFloat = 49 + cxSafeAreaBottom

#endif

#if os(iOS) || os(tvOS)

/// Load image named xxx.
public func cxLoadImage(named: String) -> CXImage
{
    return CXImage(named: named) ?? CXImage()
}

public func cxShowAlert(in controller: UIViewController,
                        title: String?,
                        message: String?,
                        style: UIAlertController.Style = .alert,
                        sureTitle: String? = nil,
                        cancelTitle: String? = nil,
                        warningTitle: String? = nil,
                        sureHandler: ((UIAlertAction) -> Void)? = nil,
                        cancelHandler: ((UIAlertAction) -> Void)? = nil,
                        warningHandler: ((UIAlertAction) -> Void)? = nil)
{
    let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
    
    if sureTitle != nil {
        let sureAction = UIAlertAction(title: sureTitle, style: .default) { action in
            sureHandler?(action)
        }
        alertController.addAction(sureAction)
    }
    if cancelTitle != nil {
        let cancelAction = UIAlertAction(title: cancelTitle!, style: .cancel) { action in
            cancelHandler?(action)
        }
        alertController.addAction(cancelAction)
    }
    if warningTitle != nil {
        let warningAction = UIAlertAction(title: sureTitle, style: .destructive) { action in
            warningHandler?(action)
        }
        alertController.addAction(warningAction)
    }
    
    controller.present(alertController, animated: true)
}

#endif

/// Allocates recursive pthread_mutex associated with ‘obj’ if needed.
public func cxSynchronize(_ obj: Any, closure: @escaping () -> Void)
{
    objc_sync_enter(obj)
    defer { objc_sync_exit(obj) }
    closure()
}

/// Submits a work item to a dispatch queue for asynchronous execution after a specified time.
///
/// - Parameters:
///   - delay: he time interval after which the work item should be executed.
///   - work: The work item to be invoked on the queue.
public func cxDelayToDispatch(_ delay: TimeInterval, execute work: @escaping () -> Void)
{
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: work)
}

/// Unsafely converts an unmanaged class reference to a pointer.
public func cxToUnsafeMutableRawPointer(_ instance: AnyObject) -> UnsafeMutableRawPointer
{
    return Unmanaged.passUnretained(instance).toOpaque()
}

/// Return the type of the specified parameter.
public func cxType<E>(of e: E) -> E.Type
{
    return type(of: e)
}

/// Creates a notification with a given name and sender and posts it to the notification center.
public func cxNotify(name aName: Notification.Name,
                     object anObject: Any? = nil,
                     userInfo aUserInfo: [AnyHashable: Any]? = nil)
{
    NotificationCenter.default.post(name: aName, object: anObject, userInfo: aUserInfo)
}

/// For more, please view：
/// - [ObjC](https://github.com/chenxing640/DYFRuntimeProvider)
/// - [Swift](https://github.com/chenxing640/DYFSwiftRuntimeProvider)
@discardableResult
public func cxSwizzling(_ cls: AnyClass?, _ selector: Selector, withClass swizzledClass: AnyClass? = nil, withSelector swizzledSelector: Selector) -> Bool {
    let swizzledCls: AnyClass? = swizzledClass ?? cls
    guard let originalMethod = class_getInstanceMethod(cls, selector),
          let swizzledMethod = class_getInstanceMethod(swizzledCls, swizzledSelector)
    else {
        return false
    }
    method_exchangeImplementations(originalMethod, swizzledMethod)
    return true
}

#if canImport(AudioToolbox) && !os(watchOS)
import AudioToolbox

/// Makes the vibrate system sound.
public func cxMakeVibrate(completion: (() -> Void)? = nil) {
#if os(macOS)
    if #available(macOS 10.11, *) {
        AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, completion)
    } else {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
#else
    AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, completion)
#endif
}

#endif

// MARK: - OSS Image Handling

/// Resize image by the height. e.g.: height=100, px：resize,h_100, scale mode(lfit): m_lfit.
///
/// - Parameters:
///   - url: The url of the image.
///   - height: The height to scale.
/// - Returns: A new url after resizing.
public func cxImageResize(withUrl url: String?, height: CGFloat) -> String?
{
    guard let _url = url else {
        return nil
    }
    if height <= 0 ||
        !_url.contains("oss-cn-hangzhou.aliyuncs.com") ||
        _url.contains("?x-oss-process=image/resize") {
        return _url
    }
    
    // e.g.: http://image-demo.oss-cn-hangzhou.aliyuncs.com/example.jpg?x-oss-process=image/resize,h_100,m_lfit
    return _url + "?x-oss-process=image/resize,h_\(Int(height)),m_lfit"
}

/// Resize image by the width. e.g.: width=100, px：resize,w_100, scale mode(lfit)：m_lfit.
///
/// limit_0：scale by the specified parameters, limit_1：scale without the specified parameters, return the original image.
/// - Parameters:
///   - url: The url of the image.
///   - width: The width to scale.
/// - Returns: A new url after resizing.
public func cxImageResized(withUrl url: String?, width: CGFloat) -> String?
{
    guard let _url = url else {
        return nil
    }
    if width <= 0 ||
        !_url.contains("oss-cn-hangzhou.aliyuncs.com") ||
        _url.contains("?x-oss-process=image/resize") {
        return _url
    }
    // e.g.: http://image-demo.oss-cn-hangzhou.aliyuncs.com/example.jpg?x-oss-process=image/resize,w_100,m_lfit
    return _url + "?x-oss-process=image/resize,w_\(Int(width)),m_lfit,limit_0"
}

/// Resize image by the long edge. e.g.: width=100, px: resize,l_100.
///
/// - Parameters:
///   - url: The url of the image.
///   - longEdgeWidth: The long edge width to scale.
/// - Returns: A new url after resizing.
public func cxImageResize(withUrl url: String?, longEdgeWidth: CGFloat) -> String?
{
    guard let _url = url else {
        return nil
    }
    if longEdgeWidth <= 0 ||
        !_url.contains("oss-cn-hangzhou.aliyuncs.com") ||
        _url.contains("?x-oss-process=image/resize") {
        return _url
    }
    // e.g.: http://image-demo.oss-cn-hangzhou.aliyuncs.com/example.jpg?x-oss-process=image/resize,l_100
    return _url + "?x-oss-process=image/resize,l_\(Int(longEdgeWidth))"
}

/// Resize image by the specified width and height. e.g.: width=height=100, px：resize,h_100,w_100, scale model(fill)：m_fill.
///
/// - Parameters:
///   - url: The url of the image.
///   - width: The width to scale.
///   - height: The height to scale.
/// - Returns: A new url after resizing.
public func cxImageResize(withUrl url: String?, width: CGFloat, height: CGFloat) -> String?
{
    guard let _url = url else {
        return nil
    }
    if width <= 0 || height <= 0 ||
        !_url.contains("oss-cn-hangzhou.aliyuncs.com") ||
        _url.contains("?x-oss-process=image/resize") {
        return _url
    }
    // e.g.: http://image-demo.oss-cn-hangzhou.aliyuncs.com/example.jpg?x-oss-process=image/resize,m_fill,h_100,w_100
    return _url + "?x-oss-process=image/resize,m_fill,h_\(Int(width)),w_\(Int(height))"
}

/// Take snapshot of the video at the specified time with the `OSSfast` mode.
///
/// - Parameters:
///   - url: The url of the video.
///   - time: The specified time。
///   - width: The width to snapshot, if zero, auto-calculates its width.
///   - height: The height to snapshot, if zero, auto-calculates its height, if all is zero, return the size of the original video.
/// - Returns: A new url after taking snapshot.
public func cxVideoSnapshot(withUrl url: String?, time: Int, width: CGFloat = 0, height: CGFloat = 0) -> String?
{
    guard let _url = url else {
        return nil
    }
    if !_url.contains("oss-cn-hangzhou.aliyuncs.com") ||
        _url.contains("?x-oss-process=video/snapshot") {
        return _url + "?x-oss-process=video/snapshot,t_\(time),f_jpg,w_\(Int(width)),h_\(Int(height)),m_fast"
    }
    // e.g.: <OriginalURL>?x-oss-process=video/snapshot,t_7000,f_jpg,w_800,h_600,m_fast
    return _url + "?x-oss-process=video/snapshot,t_\(time),f_jpg,w_\(Int(width)),h_\(Int(height)),m_fast"
}

#if os(iOS) || os(tvOS)

/// A Boolean value that represents whether the idle timer is disabled for the app.
public func cxIsIdleTimerDisabled() -> Bool
{
    // return
    UIApplication.shared.isIdleTimerDisabled
}

/// Setting this property to true, disable the “idle timer” to avert system sleep.
public func cxSetIdleTimerDisabled(_ value: Bool)
{
    UIApplication.shared.isIdleTimerDisabled = value
}

// MARK: - Xib.

/// Instantiates a view from xib.
public func cxInstantiateXibView<C>(_ cls: C.Type?, bundle: Bundle? = nil) -> C? where C: UIView
{
    guard let `class` = cls else { return nil }
    guard let name = NSStringFromClass(`class`).components(separatedBy: ".").last else {
        return nil
    }
    let nib = UINib(nibName: name, bundle: bundle)
    let view = nib.instantiate(withOwner: nil, options: nil).first as? C
    return view
}

/// Instantiates a view controller from xib.
public func cxInstantiateXibViewController<C>(_ cls: C.Type?, bundle: Bundle? = nil) -> C? where C: UIViewController
{
    guard let `class` = cls else { return nil }
    let name = NSStringFromClass(`class`).components(separatedBy: ".").last
    return C.init(nibName: name, bundle: bundle)
}

// MARK: - Storyboard.

/// Instantiates a view controller from storyboard.
public func cxInstantiateSbViewController<C>(_ cls: C.Type?, bundle: Bundle? = nil, withIdentifier identifier: String? = nil) -> C? where C: UIViewController
{
    guard let `class` = cls else { return nil }
    guard let name = NSStringFromClass(`class`).components(separatedBy: ".").last else {
        return nil
    }
    let sb = UIStoryboard(name: name, bundle: bundle)
    var vc: C?
    if identifier != nil {
        vc = sb.instantiateViewController(withIdentifier: identifier!) as? C
    } else {
        vc = sb.instantiateInitialViewController() as? C
    }
    return vc
}

#endif
