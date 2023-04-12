//
//  URL+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if canImport(Foundation)
import Foundation

extension URL: CXSwiftBaseCompatible {}

extension CXSwiftBase where T == URL {
    
    
}

#if canImport(AVFoundation)
import AVFoundation

extension URL {
    
    #if !os(watchOS)
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
    
}

#endif

#endif
