//
//  CXKingfisherReferer.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

import Foundation
#if canImport(Kingfisher)
import Kingfisher

public class CXKingfisherReferer: ImageDownloadRequestModifier {
    
    let headers: [String : String]
    
    public init(headers: [String : String]) {
        self.headers = headers
    }
    
    public func modified(for request: URLRequest) -> URLRequest? {
        var request = request
        for key in headers.keys {
            if let value = headers[key], !value.isEmpty {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }
    
}

/// Sets up the referer of Kingfisher.
public func cxSetupKingfisherReferer(_ referer: String)
{
    let referer = CXKingfisherReferer(headers: ["Referer": referer])
    KingfisherManager.shared.defaultOptions = [.requestModifier(referer)]
}

/// Gets an image from a given url string.
public func cxDownloadImage(withUrl url: String,
                            options: KingfisherOptionsInfo? = nil,
                            progressBlock: DownloadProgressBlock? = nil,
                            completionHandler: @escaping (CXImage?, Error?) -> Void)
{
    guard let aURL = URL.init(string: url) else {
        DispatchQueue.main.async { completionHandler(nil, nil) }
        return
    }
    KingfisherManager.shared.retrieveImage(with: aURL, options: options, progressBlock: progressBlock) { (result) in
        switch result {
        case .success(let imageResult):
            DispatchQueue.main.async {
                completionHandler(imageResult.image, nil)
            }
        case .failure(let error):
            CXLogger.log(level: .error, message: "error: \(error)")
            DispatchQueue.main.async { completionHandler(nil, error) }
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

#endif
