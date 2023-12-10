//
//  SDWebImageWrapper.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

import Foundation
#if canImport(UIKit)
import UIKit
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
    completion: @escaping (CXImage?, Data?, Error?) -> Void)
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
