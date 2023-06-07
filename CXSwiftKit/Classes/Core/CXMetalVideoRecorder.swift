//
//  CXMetalVideoRecorder.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/8/12.
//

import Foundation
#if !os(watchOS) && canImport(AVFoundation)
import AVFoundation
#if canImport(Metal)
import Metal
#endif
#if canImport(Photos)
import Photos
#endif

public class CXMetalVideoRecorder: NSObject {
    
    @objc public let outputURL: URL
    @objc public var isRecording = false
    @objc public var recordingStartTime = TimeInterval(0)
    
    private var assetWriter: AVAssetWriter
    private var assetWriterVideoInput: AVAssetWriterInput
    private var assetWriterPixelBufferInput: AVAssetWriterInputPixelBufferAdaptor
    
    @available(iOS 11.0, tvOS 11.0, *)
    @objc public init?(outputURL url: URL, size: CGSize) {
        self.outputURL = url
        do {
            assetWriter = try AVAssetWriter(outputURL: url, fileType: AVFileType.mp4)
        } catch {
            CXLogger.log(level: .error, message: "\(error.localizedDescription)")
            return nil
        }
        
        // TODO: set bitrate sensibly
        // https://blog.testfairy.com/fine-tuned-video-compression-in-ios-swift-4-no-dependencies/
        
        // AVVideoCodecType.h264 larger file size
        let outputSettings: [String: Any] = [AVVideoCodecKey : AVVideoCodecType.hevc,
                                             AVVideoWidthKey : size.width/2,
                                            AVVideoHeightKey : size.height/2,
                             AVVideoCompressionPropertiesKey : [
                                AVVideoQualityKey : 1.0,
                                //AVVideoMaxKeyFrameIntervalKey : 5,
                                //AVVideoAverageBitRateKey : 25500000
                             ]
        ]
        
        assetWriterVideoInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: outputSettings)
        assetWriterVideoInput.expectsMediaDataInRealTime = true
        
        let sourcePixelBufferAttributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA,
            kCVPixelBufferWidthKey as String : size.width,
            kCVPixelBufferHeightKey as String : size.height]
        
        assetWriterPixelBufferInput = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterVideoInput,
                                                                           sourcePixelBufferAttributes: sourcePixelBufferAttributes)
        
        //CXLogger.log(level: .error, message: "Pixel input: \(assetWriterPixelBufferInput)")
        
        assetWriter.add(assetWriterVideoInput)
    }
    
    @objc public func startRecording() {
        if FileManager.default.fileExists(atPath: outputURL.cx.path) {
            try? FileManager.default.removeItem(at: outputURL)
        }
        
        assetWriter.startWriting()
        assetWriter.startSession(atSourceTime: CMTime.zero)
        
        recordingStartTime = CACurrentMediaTime()
        isRecording = true
    }
    
    @objc public func endRecording(_ completionHandler: @escaping () -> ()) {
        isRecording = false
        
        assetWriterVideoInput.markAsFinished()
        assetWriter.finishWriting(completionHandler: completionHandler)
    }
    
    #if canImport(Metal)
    @objc public func writeFrame(forTexture texture: MTLTexture) {
        if !isRecording {
            return
        }
        
        while !assetWriterVideoInput.isReadyForMoreMediaData {
            CXLogger.log(level: .error, message: "not ready")
            Thread.sleep(forTimeInterval: 0.0001)
        }
        
        guard let pixelBufferPool = assetWriterPixelBufferInput.pixelBufferPool else {
            CXLogger.log(level: .error, message: "Pixel buffer asset writer input did not have a pixel buffer pool available; cannot retrieve frame")
            return
        }
        
        var maybePixelBuffer: CVPixelBuffer? = nil
        
        let status = CVPixelBufferPoolCreatePixelBuffer(nil, pixelBufferPool, &maybePixelBuffer)
        if status != kCVReturnSuccess {
            CXLogger.log(level: .error, message: "Could not get pixel buffer from asset writer input; dropping frame...")
            return
        }
        
        guard let pixelBuffer = maybePixelBuffer else {
            return
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, [])
        let pixelBufferBytes = CVPixelBufferGetBaseAddress(pixelBuffer)!
        
        // Use the bytes per row value from the pixel buffer since its stride may be rounded up to be 16-byte aligned
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let region = MTLRegionMake2D(0, 0, texture.width, texture.height)
        
        texture.getBytes(pixelBufferBytes, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)
        
        let frameTime = CACurrentMediaTime() - recordingStartTime
        let presentationTime = CMTimeMakeWithSeconds(frameTime, preferredTimescale: 240)
        assetWriterPixelBufferInput.append(pixelBuffer, withPresentationTime: presentationTime)
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer, [])
    }
    #endif
    
    #if canImport(Photos)
    @objc public func exportRecordedVideo(completionHandler: @escaping (Bool, Error?) -> Void) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.outputURL)
        } completionHandler: { success, error in
            completionHandler(success, error)
        }
    }
    #endif
    
}

#endif
