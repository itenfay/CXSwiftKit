//
//  CXGlobal.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

#if canImport(Foundation)
import Foundation
#if canImport(UIKit)
import UIKit
#endif

//MARK: - CXAssociatedKey

internal struct CXAssociatedKey {
    /// The key for rotating animation of layer.
    static var isAnimationRotating = "cx.animation.isRotating"
    /// The key for the placeholder of text view.
    static var textViewPlaceholder = "cx.textView.placeholder"
    
    /// The keys for the rich text of label.
    static var labelRichTextClickEffectEnabled = "cx.label.richText.clickeffectEnabled"
    static var labelRichTextClickColor = "cx.label.richText.clickColor"
    static var labelRichTextAttributeStrings  = "cx.label.richText.attributeStrings"
    static var labelRichTextEffectDict = "cx.label.richText.effectDict"
    static var labelRichTextHasClickAction = "cx.label.richText.hasClickAction"
    static var labelRichTextClickAction = "cx.label.richText.clickAction"
    
    /// The key for the white indicator of button.
    static var buttonWhiteIndicator = "cx.button.whiteIndicator"
    static var buttonCurrentText = "cx.button.currentText"
    
    /// The key for saving image to photos album.
    static var imageSavedToPhotosAlbum = "cx.imageSavedTo.photosalbum"
    
    /// The key for presenting overlay direction.
    static var presentOverlayDirection = "cx.present.overlayDirection"
    
    /// The key for presenting view by overlay controller.
    static var presentByOverlayController = "cx.presentView.overlayController"
}

extension Optional {
    
    /// True if the Optional is .None. Useful to avoid if-let.
    public var cx_isNil: Bool {
        if case .none = self {
            return true
        }
        return false
    }
    
}

/// The width of a rectangle of the screen.
public let cxScreenWidth: CGFloat = CGFloat.cx.screenWidth
/// The height of a rectangle of the screen.
public let cxScreenHeight: CGFloat = CGFloat.cx.screenHeight

/// Fit scale by the specified demension.
///
/// - Parameter dimension: The dimension to scale.
/// - Returns: A new fit dimension.
public func cxFitScale(by dimension: CGFloat) -> CGFloat
{
    return (cxScreenWidth / 375) * dimension
}

#if os(iOS)
#if canImport(UIKit)

/// Represents the device whether is x series of iPhone.
///
/// - Returns: A boolean value represents the device whether is x series of iPhone.
public func cxIsIphoneXSeries() -> Bool
{
    var isX = false
    if #available(iOS 11.0, *) {
        isX = (UIApplication.shared.cx.keyWindow?.safeAreaInsets.bottom ?? 0) > 0
    }
    return isX
}

public func cxWindowSafeAreaInset() -> UIEdgeInsets
{
    var insets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    if #available(iOS 11.0, *) {
        insets = UIApplication.shared.cx.keyWindow?.safeAreaInsets ?? insets
    }
    return insets
}

public let cxSafeAreaTop: CGFloat = cxWindowSafeAreaInset().top == 0 ? 20 : cxWindowSafeAreaInset().top
public let cxSafeAreaBottom: CGFloat = cxWindowSafeAreaInset().bottom
/// The height of the status bar.
public let cxStatusBarHeight: CGFloat = cxSafeAreaTop
/// The height of the navigation bar.
public let cxNavigationBarHeight: CGFloat = 44 + cxStatusBarHeight
/// The height of the tab bar.
public let cxTabBarHeight: CGFloat = 49 + cxSafeAreaBottom

#else

public let cxSafeAreaTop: CGFloat = 20
public let cxSafeAreaBottom: CGFloat = 0
public let cxStatusBarHeight: CGFloat = cxSafeAreaTop
public let cxNavigationBarHeight: CGFloat = 44
public let cxTabBarHeight: CGFloat = 49

#endif
#endif

/// Allocates recursive pthread_mutex associated with ‘obj’ if needed.
public func cxSynchronize(_ obj: Any, closure: @escaping () -> Void)
{
    objc_sync_enter(obj)
    defer { objc_sync_exit(obj) }
    closure()
}

/// Submits a work item to a dispatch queue for asynchronous execution after a specified time.
/// - Parameters:
///   - delay: he time interval after which the work item should be executed.
///   - work: The work item to be invoked on the queue.
public func cxDelayToDispatch(_ delay: TimeInterval, execute work: @escaping () -> Void)
{
    DispatchQueue.cx.mainAsyncAfter(delay, execute: work)
}

// MARK: - OSS Image Handle

/// Resize image by the height. e.g.: height=100, px：resize,h_100, scale mode(lfit): m_lfit.
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

// MARK: - Kingfisher

#if canImport(Kingfisher)
import Kingfisher

/// Gets an image from a given url string.
public func cxDownloadImage(withUrl url: String,
                            options: KingfisherOptionsInfo? = nil,
                            progressBlock: DownloadProgressBlock? = nil,
                            completionHandler: (UIImage?) -> Void)
{
    guard let aURL = URL.init(string: url) else {
        DispatchQueue.cx.mainAsync {
            completionHandler?(nil)
        }
        return
    }
    KingfisherManager.shared.retrieveImage(with: aURL, options: options, progressBlock: progressBlock) { (result) in
        switch result {
        case .success(let imageResult):
            DispatchQueue.cx.mainAsync {
                completionHandler?(imageResult.image)
            }
        case .failure(let error):
            CXLogger.log(level: .error, message: "error: \(error)")
            DispatchQueue.cx.mainAsync {
                completionHandler?(nil)
            }
        }
    }
}

/// Calculates the size taken by the disk storage of Kingfisher.
public func cxCalculateKingfisherDiskStorageSize(completionHandler handler: @escaping (String?) -> Void)
{
    ImageCache.default.calculateDiskStorageSize { result in
        switch result {
        case .success(let size):
            let sizeString = ByteCountFormatter.string(
                fromByteCount: Int64(size),
                countStyle: .binary
            )
            handler(sizeString)
        case .failure(let error):
            CXLogger.log(level: .error, message: "error: \(error)")
            handler(nil)
        }
    }
}

/// Clears the memory & disk storage of Kingfisher's cache.
public func cxClearKingfisherCache(completionHandler handler: (() -> Void)? = nil)
{
    //ImageCache.default.clearMemoryCache()
    //ImageCache.default.clearDiskCache(completion: handler)
    ImageCache.default.clearCache(completion: handler)
}

/// Clears the expired images from memory & disk storage of Kingfisher's cache.
public func cxClearKingfisherExpiredCache(completionHandler handler: (() -> Void)? = nil)
{
    //ImageCache.default.cleanExpiredMemoryCache()
    //ImageCache.default.cleanExpiredDiskCache(completion: handler)
    ImageCache.default.cleanExpiredCache(completion: handler)
}

/// Sets up the referer of Kingfisher.
public func cxSetupKingfisherReferer(_ referer: String)
{
    let referer = CXKingfisherReferer(headers: ["Referer": referer])
    KingfisherManager.shared.defaultOptions = [.requestModifier(referer)]
}

#endif

//MARK: - SDWebImage

#if canImport(SDWebImage)
import SDWebImage

/// Sets up the referer of SDWebImage.
public func cxSetupSDWebImageReferer(_ referer: String)
{
    let sdDownloader = SDWebImageDownloader.shared
    sdDownloader.setValue(referer, forHTTPHeaderField: "Referer")
}

public func cxSDWebDownloadImage(
    with url: String,
    options: SDWebImageDownloaderOptions = [],
    progress: ((Int, Int, URL?) -> Void)? = nil,
    completion: @escaping (UIImage?, Data?, Error?) -> Void)
{
    let sdDownloader = SDWebImageDownloader.shared
    sdDownloader.downloadImage(with: URL(string: url), options: options) { (receivedSize, expectedSize, targetURL) in
        progress?(receivedSize, expectedSize, targetURL)
    } completed: { (image, data, error, finished) in
        completion(image, data, error)
    }
}

/// Synchronously Clear all memory cached images.
public func cxClearSDWebImageMemory()
{
    SDImageCache.shared.clearMemory()
}

/// Asynchronously clear all disk cached images.
public func cxClearSDWebImageDisk(completion: (() -> Void)? = nil)
{
    SDImageCache.shared.clearDisk {
        completion?()
    }
}

/// Asynchronously remove all expired cached image from disk.
public func cxClearSDWebImageExpiredFiles(completion: (() -> Void)? = nil) {
    SDImageCache.shared.deleteOldFiles {
        completion?()
    }
}

#endif

#if canImport(UIKit)

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

#endif
