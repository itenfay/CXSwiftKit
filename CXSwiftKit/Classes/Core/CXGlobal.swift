//
//  CXGlobal.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

import UIKit
#if canImport(Kingfisher)
import Kingfisher
#endif
#if canImport(SDWebImage)
import SDWebImage
#endif

/// f
///
/// - Parameter dimension: 1
/// - Returns: s
public func cxFitScale(at dimension: CGFloat) -> CGFloat
{
    return (CGFloat.cx.screenWidth / 375) * dimension
}

/// xxx
///
/// - Returns: A boolean value.
public func cxIsIphoneXSeries() -> Bool
{
    var isX = false
    if #available(iOS 11.0, *) {
        isX = (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0) > CGFloat(0.0)
    }
    return isX
}

/// Allocates recursive pthread_mutex associated with ‘obj’ if needed.
public func cxSynchronize(_ obj: Any, closure: @escaping () -> Void)
{
    objc_sync_enter(obj)
    defer {
        objc_sync_exit(obj)
    }
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

// MARK: - OSS图片处理

/// OSS图片处理：等比缩放，按宽高缩放，如：图片缩放为高100 px：resize,h_100。缩放模式为lfit：m_lfit。
/// - Parameters:
///   - url: 图片地址
///   - height: 画布的高度
/// - Returns: 裁剪图片后新的地址
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
    return _url + "?x-oss-process=image/resize,h_\(Int(height)),m_lfit,limit_1"
}

/// OSS图片处理：等比缩放，按宽高缩放，如：图片缩放为宽100 px：resize,w_100。缩放模式为lfit：m_lfit。
/// limit_0：按指定参数进行缩放。,limit_1：表示不按指定参数进行缩放，直接返回原图。
/// - Parameters:
///   - url: 图片地址
///   - width: 画布的宽度
/// - Returns: 裁剪图片后新的地址
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
    return _url + "?x-oss-process=image/resize,w_\(Int(width)),m_lfit,limit_1"
}

/// OSS图片处理：按长边缩放，如：图片缩放为长边100 px，即resize,l_100。
/// limit_0：按指定参数进行缩放。,limit_1：表示不按指定参数进行缩放，直接返回原图。
/// - Parameters:
///   - url: 图片地址
///   - longSide: 长边宽度
/// - Returns: 裁剪图片后新的地址
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

/// OSS图片处理：固定宽高，自动裁剪，如：原图缩放成宽高100 px：resize,h_100,w_100，缩放模式fill：m_fill。
/// limit_0：按指定参数进行缩放。,limit_1：表示不按指定参数进行缩放，直接返回原图。
/// - Parameters:
///   - url: 图片地址
///   - width: 画布的宽度
///   - height: 画布的高度
/// - Returns: 裁剪图片后新的地址
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
    return _url + "?x-oss-process=image/resize,m_fill,h_\(Int(width)),w_\(Int(height)),limit_1"
}

/// OSSfast模式截取视频图片。
/// - Parameters:
///   - url: 视频地址
///   - t: 指定截图时间。
///   - width: 截图宽度，如果指定为0，则自动计算。
///   - height: 截图高度，如果指定为0，则自动计算；如果w和h都为0，则输出为原视频宽高。
/// - Returns: 截取视频后新的图片地址
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

#if canImport(Kingfisher)

// MARK: - Kingfisher

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

#if canImport(SDWebImage)

/// Sets up the referer of SDWebImage.
public func cxSetupSDWebImageReferer(_ referer: String)
{
    let sdDownloader = SDWebImageDownloader.shared
    sdDownloader.setValue(referer, forHTTPHeaderField: "Referer")
}

#endif
