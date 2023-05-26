//
//  CXAudioToolbox.swift
//  CXSwiftKit
//
//  Created by chenxing on 2021/9/2.
//

#if !os(watchOS) && canImport(AVFoundation)
import AVFoundation
import Foundation

public class CXAudioToolbox: NSObject {
    
    /// Creates an asset that models the media resource found at URL.
    @objc public func makeURLAsset(_ url: URL, options: [String : Any]? = nil) -> AVURLAsset {
        return AVURLAsset(url: url, options: options)
    }
    
    /// Creates an export session with a preset configuration.
    @objc public func makeAssetExportSession(_ asset: AVAsset, presetName: String) -> AVAssetExportSession? {
        return AVAssetExportSession(asset: asset, presetName: presetName)
    }
    
    /// Creates an object to read media data from an asset.
    @objc public func makeAssetReader(_ asset: AVAsset) -> AVAssetReader? {
        do {
            let assetReader = try AVAssetReader(asset: asset)
            return assetReader
        } catch {
            CXLogger.log(level: .error, message: "error=\(error)")
        }
        return nil
    }
    
    /// Creates an object that writes media data to a container file at the output URL.
    @objc public func makeAssetWriter(_ outputURL: URL, fileType: AVFileType = .mp3) -> AVAssetWriter? {
        do {
            let assetWriter = try AVAssetWriter(outputURL: outputURL, fileType: fileType)
            return assetWriter
        } catch {
            CXLogger.log(level: .error, message: "error=\(error)")
        }
        return nil
    }
    
    /// The default export directory.
    @objc public private(set) static var exportDirectory = "cx.audio.export"
    
    /// Modifies the export directory with the name.
    @objc public func modifyExportDirectory(_ name: String) {
        Self.exportDirectory = name
    }
    
    /// Convert the original audio to the `m4a` format audio.
    @objc public static func toM4A(_ originalURL: URL, completion: @escaping (_ success: Bool, _ outputURL: URL) -> Void) {
        DispatchQueue.global(qos: .default).async {
            let fileName = CXFileToolbox.fileName(withURL: originalURL) + ".m4a"
            let (success, outputURL) = CXAVExportConfig().exportFileURL(with: CXAudioToolbox.exportDirectory, fileName: fileName)
            guard success else {
                completion(false, outputURL)
                return
            }
            CXLogger.log(level: .info, message: "outputURL=\(outputURL)")
            
            let toolbox = CXAudioToolbox()
            let asset = toolbox.makeURLAsset(originalURL)
            guard let exportSession = toolbox.makeAssetExportSession(asset, presetName: AVAssetExportPresetAppleM4A)
            else {
                completion(false, outputURL)
                return
            }
            
            exportSession.outputFileType = .m4a
            exportSession.outputURL = outputURL
            exportSession.shouldOptimizeForNetworkUse = true
            exportSession.exportAsynchronously {
                DispatchQueue.main.async {
                    switch exportSession.status {
                    case .failed, .cancelled, .unknown:
                        if let error = exportSession.error {
                            CXLogger.log(level: .error, message: "error=\(error)")
                        }
                        completion(false, outputURL)
                        break
                    case .waiting:
                        CXLogger.log(level: .info, message: "AVAssetExportSessionStatusWaiting")
                        break
                    case .exporting:
                        CXLogger.log(level: .info, message: "AVAssetExportSessionStatusExporting")
                        break
                    case .completed:
                        completion(true, outputURL)
                        break
                    default: break
                    }
                }
            }
        }
    }
    
    /// Convert the original audio to the `wav` format audio.
    @objc public static func toWAV(_ originalURL: URL, configuration: (() -> [String : Any])? = nil, completion: @escaping (_ outputURL: URL?) -> Void) {
        let toolbox = CXAudioToolbox()
        let asset = toolbox.makeURLAsset(originalURL)
        guard let assetReader = toolbox.makeAssetReader(asset) else {
            completion(nil)
            return
        }
        let assetReaderOutput = AVAssetReaderAudioMixOutput(audioTracks: asset.tracks, audioSettings: nil)
        if !assetReader.canAdd(assetReaderOutput) {
            CXLogger.log(level: .error, message: "AssetReader can't add reader mix output... die!")
            completion(nil)
            return
        }
        assetReader.add(assetReaderOutput)
        
        let fileName = CXFileToolbox.fileName(withURL: originalURL) + ".wav"
        let (success, outputURL) = CXAVExportConfig().exportFileURL(with: CXAudioToolbox.exportDirectory, fileName: fileName)
        guard success else {
            completion(nil)
            return
        }
        CXLogger.log(level: .info, message: "outputURL=\(outputURL)")
        
        guard let assetWriter = toolbox.makeAssetWriter(outputURL, fileType: .wav) else {
            completion(nil)
            return
        }
        let outputSettings = configuration != nil ? configuration!() : toolbox.defaultAudioOutputSettings()
        if !assetWriter.canApply(outputSettings: outputSettings, forMediaType: .audio) {
            CXLogger.log(level: .error, message: "AssetWriter can't apply output settings... die!")
            completion(nil)
            return
        }
        let assetWriterInput = AVAssetWriterInput(mediaType: .audio, outputSettings: outputSettings)
        if !assetWriter.canAdd(assetWriterInput) {
            CXLogger.log(level: .error, message: "AssetWriter can't add asset writer input... die!")
            completion(nil)
            return
        }
        // Indicates whether the input tailors its processing for real-time sources.
        assetWriterInput.expectsMediaDataInRealTime = false
        assetWriter.add(assetWriterInput)
        
        // Start reading sample buffers from the asset.
        assetReader.startReading()
        assetWriter.startWriting()
        
        guard let track = asset.tracks.first else {
            CXLogger.log(level: .error, message: "Asset.tracks.first is nil... die!")
            completion(nil)
            return
        }
        
        let startTime = CMTimeMake(value: 0, timescale: track.naturalTimeScale)
        // Starts an asset-writing session.
        assetWriter.startSession(atSourceTime: startTime)
        var convertedByteCount: UInt64 = 0
        let mediaInputQueue = DispatchQueue(label: "mediaInputQueue")
        assetWriterInput.requestMediaDataWhenReady(on: mediaInputQueue) {
            while assetWriterInput.isReadyForMoreMediaData {
                if let nextBuffer = assetReaderOutput.copyNextSampleBuffer() {
                    // append buffer
                    assetWriterInput.append(nextBuffer)
                    convertedByteCount += UInt64(CMSampleBufferGetTotalSampleSize(nextBuffer))
                } else {
                    assetWriterInput.markAsFinished()
                    assetReader.cancelReading()
                    assetWriter.finishWriting {}
                    DispatchQueue.main.async {
                        completion(outputURL)
                    }
                    break
                }
            }
        }
    }
    
    public func defaultAudioOutputSettings() -> [String : Any] {
        // Audio Channel Layout
        var channelLayout = AudioChannelLayout()
        memset(&channelLayout, 0, MemoryLayout<AudioChannelLayout>.size)
        channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo
        let settings: [String : Any] = [
            AVFormatIDKey : kAudioFormatLinearPCM, // Audio Format LinearPCM
            AVSampleRateKey : 44100.0, // Sample Rate
            AVNumberOfChannelsKey : 2, // NumberOfChannels: 1 || 2
            AVChannelLayoutKey : Data(bytes: &channelLayout, count: MemoryLayout<AudioChannelLayout>.size),
            AVLinearPCMBitDepthKey : 16, // LinearPCM Bit
            AVLinearPCMIsNonInterleaved : false, // Is Not Interleaved
            AVLinearPCMIsFloatKey : false, // Is Float
            AVLinearPCMIsBigEndianKey : false // Is Big Endian
        ]
        return settings
    }
    
}

#endif
