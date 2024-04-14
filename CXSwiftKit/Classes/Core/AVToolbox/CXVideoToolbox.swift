//
//  CXVideoToolbox.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2021/9/26.
//

import Foundation
#if !os(watchOS) && canImport(AVFoundation)
import AVFoundation
#if canImport(Photos)
import Photos
#endif

/// Describes the export preset quality.
@objc public enum CXExportPresetQuality: UInt8 {
    case low
    case medium
    case highest
    case _640x480
    case _960x540
    case _1280x720  // 720p HD
    case _1920x1080 // 1080p HD
    case _3840x2160
}

public class CXVideoToolbox: NSObject {
    
    /// The default export directory.
    @objc public private(set) static var exportDirectory = "cx.video.export"
    
    /// Modifies the export directory with the name.
    @objc public func modifyExportDirectory(_ name: String) {
        Self.exportDirectory = name
    }
    
    /// Creates an export session with a preset configuration.
    @objc public func makeAssetExportSession(_ asset: AVAsset, presetName: String) -> AVAssetExportSession? {
        return AVAssetExportSession(asset: asset, presetName: presetName)
    }
    
    #if canImport(Photos)
    /// Convert the original video to `mp4` format video.
    @objc public static func toMP4(
        withAsset resourceAsset: PHAsset,
        quality: CXExportPresetQuality,
        completionHandler: @escaping (_ fileURL: URL?, _ data: Data?, _ error: NSError?) -> Void)
    {
        let toolbox = CXVideoToolbox()
        let videoInfo = toolbox.getVideoInfo(resourceAsset)
        CXLogger.log(level: .info, message: "videoInfo=\(videoInfo)")
        
        let options = PHVideoRequestOptions()
        options.version = .current
        options.deliveryMode = .automatic
        options.isNetworkAccessAllowed = true
        let manager = PHImageManager.default()
        manager.requestAVAsset(forVideo: resourceAsset, options: options) { asset, audioMix, info in
            if let avAsset = asset, avAsset.isKind(of: AVURLAsset.self),
               let avURLAsset = avAsset as? AVURLAsset {
                CXVideoToolbox.toMP4(withURLAsset: avURLAsset, quality: quality, completionHandler: completionHandler)
            } else {
                DispatchQueue.main.async {
                    let error = NSError(domain: "cx.exportvideo.domain", code: 10000, userInfo: [NSLocalizedDescriptionKey: "Resource type error"])
                    completionHandler(nil, nil, error)
                }
            }
        }
    }
    #endif
    
    /// Convert the original video to `mp4` format video.
    @objc public static func toMP4(
        withURLAsset asset: AVURLAsset,
        quality: CXExportPresetQuality,
        completionHandler: @escaping (_ fileURL: URL?, _ data: Data?, _ error: NSError?) -> Void)
    {
        let toolbox = CXVideoToolbox()
        if toolbox.isMP4(withURL: asset.url) {
            DispatchQueue.main.async {
                let data = try? Data(contentsOf: asset.url)
                completionHandler(asset.url, data, nil)
            }
            return
        }
        
        let formatter = DateFormatter()
        //formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyyMMddHHmmss"
        let dateString = formatter.string(from: Date())
        let fileName = CXFileToolbox.fileName(withURL: asset.url) + "_\(dateString).mp4"
        CXLogger.log(level: .info, message: "fileName=\(fileName)")
        let (success, fileURL) = cxAVExportedFileURL(with: CXVideoToolbox.exportDirectory, fileName: fileName)
        guard success else {
            let error = NSError(domain: "cx.exportvideo.domain", code: 10001, userInfo: [NSLocalizedDescriptionKey: "The output directory can't be created... die!"])
            completionHandler(nil, nil, error)
            return
        }
        
        DispatchQueue.global(qos: .default).async {
            let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: asset)
            let exportPreset = toolbox.getAVAssetCXExportPresetQuality(quality)
            if compatiblePresets.contains(exportPreset) {
                guard let exportSession = toolbox.makeAssetExportSession(asset, presetName: exportPreset) else {
                    let error = NSError(domain: "cx.exportvideo.domain", code: 10002, userInfo: [NSLocalizedDescriptionKey: "AVAsset export session is null!"])
                    completionHandler(nil, nil, error)
                    return
                }
                exportSession.outputURL = fileURL
                exportSession.outputFileType = AVFileType.mp4
                exportSession.shouldOptimizeForNetworkUse = true
                exportSession.exportAsynchronously {
                    DispatchQueue.main.async {
                        switch exportSession.status  {
                        case .unknown:
                            let error = NSError.init(domain: "cx.exportvideo.domain", code: 10004, userInfo: [NSLocalizedDescriptionKey: "AVAssetExportSessionStatusUnknown"])
                            completionHandler(nil, nil, error)
                            break
                        case .waiting:
                            CXLogger.log(level: .info, message: "AVAssetExportSessionStatusWaiting")
                            break
                        case .exporting:
                            CXLogger.log(level: .info, message: "AVAssetExportSessionStatusExporting")
                            break
                        case .completed:
                            var data: Data? = nil
                            if let outputURL = exportSession.outputURL, let tmpData = try? Data(contentsOf: outputURL) {
                                data = tmpData
                            }
                            completionHandler(exportSession.outputURL, data, nil)
                            break
                        case .failed:
                            let error = NSError.init(domain: "cx.exportvideo.domain", code: 10005, userInfo: [NSLocalizedDescriptionKey: "AVAssetExportSessionStatusFailed"])
                            completionHandler(nil, nil, error)
                            break
                        case .cancelled:
                            let error = NSError(domain: "cx.exportvideo.domain", code: 10006, userInfo: [NSLocalizedDescriptionKey: "AVAssetExportSessionStatusCancelled"])
                            completionHandler(nil, nil, error)
                            break
                        default: break
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let error = NSError(domain: "cx.exportvideo.domain", code: 10003, userInfo: [NSLocalizedDescriptionKey: "AVAssetExportSessionStatusNoPreset"])
                    completionHandler(nil, nil, error)
                }
            }
        }
    }
    
    /// Convert the original video to `mp4` format video.
    @objc public static func toMP4(
        withAssetURL assetURL: URL,
        quality: CXExportPresetQuality,
        completionHandler: @escaping (_ fileURL: URL?, _ data: Data?, _ error: NSError?) -> Void)
    {
        let avAsset = AVURLAsset(url: assetURL, options: nil)
        toMP4(withURLAsset: avAsset, quality: quality, completionHandler: completionHandler)
    }
    
    @objc public func isMP4(withURL url: URL) -> Bool {
        let ext = url.pathExtension
        CXLogger.log(level: .info, message: "Extension=\(ext)")
        if ext.lowercased().hasSuffix("mp4") {
            return true
        }
        return false
    }
    
    @objc public func getAVAssetCXExportPresetQuality(_ exportPreset: CXExportPresetQuality) -> String {
        switch exportPreset {
        case .low:
            return AVAssetExportPresetLowQuality // A preset to export a low-quality movie file.
        case .medium:
            return AVAssetExportPresetMediumQuality // A preset to export a medium-quality movie file.
        case .highest:
            return AVAssetExportPresetHighestQuality // A preset to export a high-quality movie file.
        case ._640x480:
            return AVAssetExportPreset640x480
        case ._960x540:
            return AVAssetExportPreset960x540
        case ._1280x720:
            return AVAssetExportPreset1280x720
        case ._1920x1080:
            return AVAssetExportPreset1920x1080
        case ._3840x2160:
            return AVAssetExportPreset3840x2160
        }
    }
    
    @objc public func getVideoInfo(_ asset: PHAsset) -> [String : Any] {
        // <PHAsset: 0x141d68b70> A99AA1C3-7D59-4E10-A8D3-BF4FAD7A1BC6/L0/001 mediaType=2/0, sourceType=1, (1080x1920),
        // creationDate=2018-06-04 09:32:53 +0000, location=1, hidden=0, favorite=0
        let res = PHAssetResource.assetResources(for: asset).first
        guard let resource = res else {
            return [:]
        }
        var resourceArray: [String] = []
        if #available(iOS 13.0, *) {
            let s1 = resource.description.replacingOccurrences(of: " - ", with: " ")
            let s2 = s1.replacingOccurrences(of: ": ", with: "")
            let s3 = s2.replacingOccurrences(of: "{", with: "")
            let s4 = s3.replacingOccurrences(of: "}", with: "")
            let s5 = s4.replacingOccurrences(of: ", ", with: " ")
            resourceArray.append(contentsOf: s5.components(separatedBy: " "))
        } else {
            let s1 = resource.description.replacingOccurrences(of: "{", with: "")
            let s2 = s1.replacingOccurrences(of: "}", with: "")
            let s3 = s2.replacingOccurrences(of: ", ", with: " ")
            resourceArray.append(contentsOf: s3.components(separatedBy: " "))
        }
        
        if resourceArray.count >= 2 {
            resourceArray.removeSubrange(0...1)
        }
        
        var videoInfo: [String: Any] = [:]
        for item in resourceArray {
            let arr = item.components(separatedBy: "=")
            if arr.count >= 2 {
                videoInfo[arr[0]] = arr[1]
            }
        }
        videoInfo["duration"] = asset.duration.description
        
        return videoInfo
    }
    
}

#endif
