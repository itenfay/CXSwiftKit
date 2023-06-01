//
//  URL+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

import Foundation
#if os(macOS)
import AppKit
#endif

extension URL: CXSwiftBaseCompatible {}

extension CXSwiftBase where T == URL {
    
    #if !os(watchOS)
    #if os(macOS)
    /// Generate a thumbnail image from given url. Returns nil if no thumbnail could be created. This function may take some time to complete.
    ///
    /// - Parameters:
    ///   - time: Seconds into the video where the image should be generated.
    ///   - size: The size of the new image. Use zero to have the new image adopt the pixel dimensions of the source image.
    ///   - completionHandler: The UIImage result of the AVAssetImageGenerator
    public func takeThumbnail(fromTime time: Float64, size: NSSize, completionHandler: @escaping (NSImage?) -> Void) {
        base.cx_takeThumbnail(fromTime: time, size: size, completionHandler: completionHandler)
    }
    #else
    /// Generate a thumbnail image from given url. Returns nil if no thumbnail could be created. This function may take some time to complete.
    ///
    /// - Parameters:
    ///   - time: Seconds into the video where the image should be generated.
    ///   - completionHandler: The UIImage result of the AVAssetImageGenerator
    public func takeThumbnail(fromTime time: Float64, completionHandler: @escaping (UIImage?) -> Void) {
        base.cx_takeThumbnail(fromTime: time, completionHandler: completionHandler)
    }
    #endif
    #endif
    
    /// The dictionary of the URL's query parameters.
    public var queryParameters: [String : String]? {
        return base.cx_queryParameters
    }
    
    /// Append query parameters to URL.
    public func appendingQueryParameters(_ parameters: [String : String]) -> URL {
        return base.cx_appendingQueryParameters(parameters)
    }
    
    /// Get value of a query key.
    public func queryValue(forKey key: String) -> String? {
        return base.cx_queryValue(forKey: key)
    }
    
    /// The path extension of the URL, or an empty string if the path is an empty string.
    public var `extension`: String {
        return base.cx_extension
    }
    
    /// Remove all the path components from the URL.
    public func deletingAllPathComponents() -> URL {
        return base.cx_deletingAllPathComponents()
    }
    
    /// Return a string that does not have scheme.
    public func dropScheme() -> String {
        return base.cx_dropScheme()
    }
    
    /// Return the path, or an empty string if the URL has an empty path.
    public var path: String { base.cx_path }
    
    /// Return a Boolean value that indicates whether the resource is a directory.
    public var isDirectory: Bool! { base.cx_isDirectory }
    
    /// Returns a URL by appending the specified path component to self.
    public func appendingPathComponent(_ path: String) -> URL { base.cx_appendingPathComponent(path) }
    
}

#if canImport(AVFoundation)
import AVFoundation

extension URL {
    
    #if !os(watchOS)
    #if os(macOS)
    /// Generate a thumbnail image from given url. Returns nil if no thumbnail could be created. This function may take some time to complete.
    ///
    /// - Parameters:
    ///   - time: Seconds into the video where the image should be generated.
    ///   - size: The size of the new image. Use zero to have the new image adopt the pixel dimensions of the source image.
    ///   - completionHandler: The UIImage result of the AVAssetImageGenerator
    public func cx_takeThumbnail(fromTime time: Float64, size: NSSize, completionHandler: @escaping (NSImage?) -> Void) {
        let avAsset = AVURLAsset(url: self)
        let imageGenerator = AVAssetImageGenerator(asset: avAsset)
        let requestedTime = CMTimeMakeWithSeconds(time, preferredTimescale: 1)
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, *) {
            imageGenerator.generateCGImageAsynchronously(for: requestedTime) { cgImage, actualTime, error in
                if error != nil {
                    CXLogger.log(level: .error, message: "error=\(error!)")
                }
                completionHandler(cgImage != nil ? NSImage(cgImage: cgImage!, size: size) : nil)
            }
        } else {
            var actualTime = CMTimeMake(value: 0, timescale: 0)
            do {
                let cgImage = try imageGenerator.copyCGImage(at: requestedTime, actualTime: &actualTime)
                completionHandler(NSImage(cgImage: cgImage, size: size))
            } catch let error {
                CXLogger.log(level: .error, message: "error=\(error)")
                completionHandler(nil)
            }
        }
    }
    #else
    /// Generate a thumbnail image from given url. Returns nil if no thumbnail could be created. This function may take some time to complete.
    ///
    /// - Parameters:
    ///   - time: Seconds into the video where the image should be generated.
    ///   - completionHandler: The UIImage result of the AVAssetImageGenerator
    public func cx_takeThumbnail(fromTime time: Float64, completionHandler: @escaping (UIImage?) -> Void) {
        let avAsset = AVURLAsset(url: self)
        let imageGenerator = AVAssetImageGenerator(asset: avAsset)
        let requestedTime = CMTimeMakeWithSeconds(time, preferredTimescale: 1)
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, *) {
            imageGenerator.generateCGImageAsynchronously(for: requestedTime) { cgImage, actualTime, error in
                if error != nil {
                    CXLogger.log(level: .error, message: "error=\(error!)")
                }
                completionHandler(cgImage != nil ? UIImage(cgImage: cgImage!) : nil)
            }
        } else {
            var actualTime = CMTimeMake(value: 0, timescale: 0)
            do {
                let cgImage = try imageGenerator.copyCGImage(at: requestedTime, actualTime: &actualTime)
                completionHandler(UIImage(cgImage: cgImage))
            } catch let error {
                CXLogger.log(level: .error, message: "error=\(error)")
                completionHandler(nil)
            }
        }
    }
    #endif
    #endif
    
}

#endif

//@available(macOS 10.9, iOS 7.0, watchOS 2.0, tvOS 9.0, *)
extension URL {
    
    /// The dictionary of the URL's query parameters.
    public var cx_queryParameters: [String : String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems
        else { return nil }
        
        var items: [String: String] = [:]
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        
        return items
    }
    
    /// Append query parameters to URL.
    public func cx_appendingQueryParameters(_ parameters: [String : String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var items = urlComponents.queryItems ?? []
        items += parameters.map({ URLQueryItem(name: $0, value: $1) })
        urlComponents.queryItems = items
        return urlComponents.url!
    }
    
    /// Append query parameters to URL.
    public mutating func cx_appendingQueryParameters(_ parameters: [String : String]) {
        self = cx_appendingQueryParameters(parameters)
    }
    
    /// Get value of a query key.
    public func cx_queryValue(forKey key: String) -> String? {
        return URLComponents(string: absoluteString)?
            .queryItems?
            .first(where: { $0.name == key })?
            .value
    }
    
    /// The path extension of the URL, or an empty string if the path is an empty string.
    public var cx_extension: String {
        return pathExtension
    }
    
    /// Remove all the path components from the URL.
    public func cx_deletingAllPathComponents() -> URL {
        var url: URL = self
        for _ in 0..<pathComponents.count - 1 {
            url.deleteLastPathComponent()
        }
        return url
    }
    
    /// Remove all the path components from the URL.
    public mutating func cx_deletingAllPathComponents() {
        for _ in 0..<pathComponents.count - 1 {
            deleteLastPathComponent()
        }
    }
    
    /// Return a string that does not have scheme.
    public func cx_dropScheme() -> String {
        if let scheme = scheme {
            return String(absoluteString.dropFirst(scheme.count + 3))
        }
        
        guard host != nil else { return absoluteString }
        
        return String(absoluteString.dropFirst(2))
    }
    
    /// Return the path, or an empty string if the URL has an empty path.
    public var cx_path: String {
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            return path(percentEncoded: false)
        } else {
            return path
        }
    }
    
    /// Return a Boolean value that indicates whether the resource is a directory.
    public var cx_isDirectory: Bool! {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory
    }
    
    /// Returns a URL by appending the specified path component to self.
    public func cx_appendingPathComponent(_ path: String) -> URL {
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            return appending(path: path, directoryHint: .inferFromPath)
        } else {
            return appendingPathComponent(path)
        }
    }
    
    /// Creates a file URL that references the local file or directory at path.
    public init(localFilePath path: String) {
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            self.init(filePath: path, directoryHint: .inferFromPath, relativeTo: nil)
        } else {
            self.init(fileURLWithPath: path)
        }
    }
    
}
