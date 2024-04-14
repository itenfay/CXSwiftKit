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
    
    private var assetWriter: AVAssetWriter
    private var assetWriterVideoInput: AVAssetWriterInput
    private var assetWriterPixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor
    
    @objc public let outputURL: URL
    @objc public var isRecording = false
    @objc public var outPixelBuffer: CVPixelBuffer?
    
    @objc public var recordingStartTime = TimeInterval(0)
    @objc public var recordingElapsedTime = TimeInterval(0)
    
    @available(iOS 11.0, tvOS 11.0, *)
    @objc public init?(outputURL url: URL, size: CGSize) {
        self.outputURL = url
        do {
            assetWriter = try AVAssetWriter(outputURL: url, fileType: AVFileType.mp4)
        } catch {
            debugPrint("[E] " + "\(error.localizedDescription)")
            return nil
        }
        
        // AVVideoCodecType.h264 larger file size
        let outputSettings: [String: Any] = [AVVideoCodecKey : AVVideoCodecType.h264,
                                             AVVideoWidthKey : size.width,
                                            AVVideoHeightKey : size.height]
        assetWriterVideoInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: outputSettings)
        assetWriterVideoInput.expectsMediaDataInRealTime = true
        
        let sourcePixelBufferAttributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA
        ]
        assetWriterPixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterVideoInput,
                                                                             sourcePixelBufferAttributes: sourcePixelBufferAttributes)
        //debugPrint("[I] " + "PixelBuffer input: \(assetWriterPixelBufferAdaptor)")
        
        assetWriter.add(assetWriterVideoInput)
    }
    
    /// Deletes the output file.
    @objc public func deleteOutputFile() {
        do {
            try FileManager.default.removeItem(at: outputURL)
        } catch let error {
            debugPrint("[E] " + "\(error.localizedDescription)")
        }
    }
    
    /// Starts recording the video.
    @objc public func start() {
        debugPrint("[I] " + "Start recording")
        deleteOutputFile()
        
        assetWriter.startWriting()
        assetWriter.startSession(atSourceTime: CMTime.zero)
        
        recordingStartTime = CACurrentMediaTime()
        isRecording = true
    }
    
    /// Finishes recording the video.
    @objc public func finish(_ completionHandler: @escaping () -> ()) {
        isRecording = false
        
        assetWriterVideoInput.markAsFinished()
        assetWriter.finishWriting { [unowned self] in
            self.recordingElapsedTime = CACurrentMediaTime() - self.recordingStartTime
            CXLogger.log(level: .info, message: "Finish recording: elapsedTime=\(self.recordingElapsedTime)")
            completionHandler()
        }
    }
    
    /// Cancels recording the video.
    @objc public func cancel() {
        CXLogger.log(level: .info, message: "Cancel recording")
        isRecording = false
        
        assetWriterVideoInput.markAsFinished()
        assetWriter.cancelWriting()
    }
    
    #if canImport(Metal)
    @objc public func writeFrame(_ texture: MTLTexture) {
        if !isRecording {
            return
        }
        if !assetWriterVideoInput.isReadyForMoreMediaData {
            //debugPrint("[E]" + "Not ready for more media data")
            return
        }
        guard let pixelBufferPool = assetWriterPixelBufferAdaptor.pixelBufferPool else {
            //debugPrint("[E]" + "Pixel buffer asset writer input did not have a pixel buffer pool available; cannot retrieve frame")
            return
        }
        
        var maybePixelBuffer: CVPixelBuffer? = nil
        let status = CVPixelBufferPoolCreatePixelBuffer(nil, pixelBufferPool, &maybePixelBuffer)
        if status != kCVReturnSuccess {
            debugPrint("[E] " + "Could not get pixel buffer from asset writer input; dropping frame...")
            return
        }
        guard let pixelBuffer = maybePixelBuffer else {
            debugPrint("[E]" + "No pixelBuffer")
            return
        }
        CVPixelBufferLockBaseAddress(pixelBuffer, [])
        let pixelBufferBytes = CVPixelBufferGetBaseAddress(pixelBuffer)!
        
        // Use the bytes per row value from the pixel buffer since its stride may be rounded up to be 16-byte aligned
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let region = MTLRegionMake2D(0, 0, texture.width, texture.height)
        // Insert all the texture processing logic
        texture.getBytes(pixelBufferBytes, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)
        
        let frameTime = CACurrentMediaTime() - recordingStartTime
        let presentationTime = CMTimeMakeWithSeconds(frameTime, preferredTimescale: 240)
        assetWriterPixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
        outPixelBuffer = pixelBuffer
        
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
