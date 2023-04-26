//
//  CXAVToolbox.swift
//  CXSwiftKit
//
//  Created by chenxing on 2021/9/26.
//

#if canImport(AVFoundation)
import AVFoundation

public class CXAVToolbox: NSObject {
    
    @objc public func exportOutputPath(fileName: String? = nil, fileType: String) -> String {
        var prefixName = ""
        if let fn = fileName, fn.cx.isNotEmpty() {
            prefixName = fn
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            prefixName = formatter.string(from: Date())
        }
        let (success, fileURL) = CXAVExportConfig().exportFileURL(with: "cx.avresource.export", fileName: prefixName + "." + fileType)
        return success ? fileURL.cx.path : ""
    }
    
    /// Merge the audios.
    @objc class func mergeAudios(
        _ audioPaths: [String],
        presetVolume: Float = 0.5,
        completionHandler: @escaping (_ success: Bool, _ outputPath: String) -> Void)
    {
        let outputPath = CXAVToolbox().exportOutputPath(fileType: "m4a")
        if outputPath.isEmpty {
            CXLogger.log(level: .warning, message: "The output path is empty.")
            completionHandler(false, outputPath)
            return
        }
        DispatchQueue.global().async {
            let compostion = AVMutableComposition()
            var mixInputParameters: [AVAudioMixInputParameters] = []
            
            audioPaths.forEach {
                let _audioAsset = AVURLAsset(url: URL(fileURLWithPath: $0))
                if let _track = compostion.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) {
                    for originalTrack in _audioAsset.tracks(withMediaType: .audio) {
                        do {
                            try _track.insertTimeRange(CMTimeRange(start: .zero, duration: _audioAsset.duration), of: originalTrack, at: .zero)
                            let parameters = AVMutableAudioMixInputParameters(track: _track)
                            parameters.setVolume(presetVolume, at: .zero)
                            mixInputParameters.append(parameters)
                        } catch {
                            CXLogger.log(level: .error, message: "error=\(error)")
                        }
                    }
                }
            }
            
            let audioMix = AVMutableAudioMix()
            audioMix.inputParameters = mixInputParameters
            
            let session = AVAssetExportSession(asset: compostion, presetName: AVAssetExportPresetAppleM4A)
            session?.audioMix = audioMix
            session?.outputURL = URL(fileURLWithPath: outputPath)
            session?.outputFileType = .m4a
            session?.shouldOptimizeForNetworkUse = true
            session?.exportAsynchronously(completionHandler: {
                DispatchQueue.main.async(execute: {
                    switch session?.status {
                    case .exporting, .waiting:
                        break
                    case .completed:
                        completionHandler(true, outputPath)
                    default:
                        completionHandler(false, outputPath)
                    }
                })
            })
        }
    }
    
    /// Mix the audio to the specified video.
    @objc class func mixAudio(
        _ audioURL: URL?,
        audioVolume: Float,
        toVideo videoURL: URL?,
        videoVolume: Float,
        outputFileName fileName: String? = nil,
        completionHandler: @escaping (_ success: Bool, _ outputPath: String) -> Void)
    {
        guard let tVideoURL = videoURL, let tAudioURL = audioURL else {
            CXLogger.log(level: .warning, message: "The URL of video or audio is null.")
            completionHandler(false, "")
            return
        }
        // setup the output path.
        let outputPath = CXAVToolbox().exportOutputPath(fileName: fileName, fileType: "mp4")
        if outputPath.isEmpty {
            CXLogger.log(level: .warning, message: "The output path is empty.")
            completionHandler(false, outputPath)
            return
        }
        let videoAsset = AVURLAsset(url: tVideoURL)
        let audioAsset = AVURLAsset(url: tAudioURL)
        let compostion = AVMutableComposition()
        
        var tVideoVolume = videoVolume
        var tAudioVolume = audioVolume
        if tVideoVolume > 1.0 { tVideoVolume = 1.0 }
        if tVideoVolume < 0.0 { tVideoVolume = 0.0 }
        if tAudioVolume > 1.0 { tAudioVolume = 1.0 }
        if tAudioVolume < 0.0 { tAudioVolume = 0.0 }
        
        DispatchQueue.global(qos: .default).async {
            let videoTrack = compostion.addMutableTrack(withMediaType: .video, preferredTrackID: CMPersistentTrackID(0))
            do {
                if let track = videoAsset.tracks(withMediaType: .video).first {
                    try videoTrack?.insertTimeRange(CMTimeRangeMake(start: .zero, duration: videoAsset.duration), of: track, at: .zero)
                }
            } catch {
                CXLogger.log(level: .error, message: "error=\(error)")
            }
            
            let audioTrack = compostion.addMutableTrack(withMediaType: .audio, preferredTrackID: CMPersistentTrackID(0))
            do {
                if let track = videoAsset.tracks(withMediaType: .audio).first {
                    try audioTrack?.insertTimeRange(CMTimeRangeMake(start: .zero, duration: videoAsset.duration), of: track, at: .zero)
                }
            } catch {
                CXLogger.log(level: .error, message: "error=\(error)")
            }
            
            let bgAudioTrack = compostion.addMutableTrack(withMediaType: .audio, preferredTrackID: CMPersistentTrackID(0))
            do {
                if let track = audioAsset.tracks(withMediaType: .audio).first {
                    try bgAudioTrack?.insertTimeRange(CMTimeRangeMake(start: .zero, duration: audioAsset.duration), of: track, at: .zero)
                }
            } catch {
                CXLogger.log(level: .error, message: "error=\(error)")
            }
            
            let videoParameters = AVMutableAudioMixInputParameters(track: videoTrack)
            videoParameters.setVolume(tVideoVolume, at: .zero)
            
            let videoAudioParameters = AVMutableAudioMixInputParameters(track: audioTrack)
            videoAudioParameters.setVolume(tVideoVolume, at: .zero)
            
            let bgAudioParameters = AVMutableAudioMixInputParameters(track: bgAudioTrack)
            bgAudioParameters.setVolume(tAudioVolume, at: .zero)
            
            let audioMix = AVMutableAudioMix()
            audioMix.inputParameters = [videoParameters, videoAudioParameters, bgAudioParameters]
            
            // HD: AVAssetExportPreset1920x1080, D: AVAssetExportPreset1280x720
            let session = AVAssetExportSession(asset: compostion, presetName: AVAssetExportPreset1920x1080)
            session?.audioMix = audioMix
            session?.outputURL = URL(fileURLWithPath: outputPath)
            session?.outputFileType = .mp4
            session?.shouldOptimizeForNetworkUse = true
            session?.exportAsynchronously(completionHandler: {
                DispatchQueue.main.async(execute: {
                    switch session?.status {
                    case .failed:
                        if let error = session?.error {
                            CXLogger.log(level: .error, message: "error=\(error)")
                        }
                        completionHandler(false, outputPath)
                    case .cancelled:
                        completionHandler(false, outputPath)
                    case .completed:
                        completionHandler(true, outputPath)
                    default:
                        completionHandler(false, outputPath)
                    }
                })
            })
        }
    }
    
}

#endif
