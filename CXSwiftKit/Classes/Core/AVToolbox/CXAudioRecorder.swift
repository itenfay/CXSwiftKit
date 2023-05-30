//
//  CXAudioRecorder.swift
//  CXSwiftKit
//
//  Created by chenxing on 2021/9/26.
//

import Foundation
#if os(iOS) && canImport(AVFAudio)
import AVFAudio

@objc public enum CXRecordingOptionCategory: UInt8, CustomStringConvertible {
    case quiet, speaker, multiRoute, movie
    
    public var description: String {
        switch self {
        case .quiet:      return "Quiet"
        case .speaker:    return "Speaker"
        case .multiRoute: return "MultiRoute" //earphone
        case .movie:      return "movie"
        }
    }
}

public class CXAudioRecorder: NSObject {
    
    /// Audio recorder that records audio data to a file.
    private var recorder: AVAudioRecorder?
    
    /// The option category for the recording.
    private var category: CXRecordingOptionCategory = .speaker
    
    /// The path of a recorded audio file.
    @objc public private(set) var filePath: String = ""
    
    /// The closure for finishing recording.
    @objc public var onFinish: (() -> Void)?
    /// The closure for the error.
    @objc public var onError: ((String) -> Void)?
    
    /// A Boolean value that indicates whether the audio recorder is recording.
    @objc public var isRecording: Bool {
        return recorder?.isRecording ?? false
    }
    
    @objc public func exportFilePath(fileName: String? = nil) -> String {
        // PCM
        var prefixName = ""
        if let fn = fileName, fn.cx.isNotEmpty() {
            prefixName = fn
        } else {
            let random = Int(arc4random() % 10000) + 1
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            prefixName = formatter.string(from: Date()) + "\(random)"
        }
        let pathComponent = "cx.audio.recording" + "/" + prefixName
        let path = CXFileToolbox.documentDirectory.cx.addPathComponent(pathComponent)
        let success = CXFileToolbox.createDirectory(atPath: path)
        return success ? path : ""
    }
    
    private func defaultRecordingSettings() -> [String : Any] {
        // AVSampleRateKey: 8000/44100/96000 mp3: 11025
        // AVFormatIDKey: kAudioFormatLinearPCM
        // AVLinearPCMBitDepthKey: 8、16、24、32
        // AVNumberOfChannelsKey: 1 or 2
        // AVEncoderAudioQualityKey
        return [AVSampleRateKey: 44100,
                  AVFormatIDKey: kAudioFormatLinearPCM,
         AVLinearPCMBitDepthKey: 16,
          AVNumberOfChannelsKey: 2,
       AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue]
    }
    
    @objc public func prepareToRecord() {
        prepareToRecord("", category: .speaker)
    }
    
    @objc public func prepareToRecord(_ fileName: String, category: CXRecordingOptionCategory) {
        prepareToRecord(fileName, category: category, configuration: nil)
    }
    
    @objc public func prepareToRecord(_ fileName: String, category: CXRecordingOptionCategory, configuration: (() -> [String : Any])?) {
        prepareToRecord(fileName, category: category, configuration: configuration, toMP3: false)
    }
    
    @objc public func prepareToRecord(_ fileName: String, category: CXRecordingOptionCategory, configuration: (() -> [String : Any])?, toMP3: Bool) {
        self.category = category
        
        let session = AVAudioSession.sharedInstance()
        if category == .quiet {
            try? session.setCategory(.record, options: [])
            try? session.setActive(true, options: [])
        } else if category == .speaker {
            try? session.setCategory(.playAndRecord, options: .defaultToSpeaker)
        } else if category == .multiRoute {
            try? session.setCategory(.multiRoute, options: [.mixWithOthers, .allowBluetoothA2DP, .allowBluetooth])
        } else if category == .movie {
            try? session.setCategory(.multiRoute, mode: .moviePlayback, options: [.mixWithOthers, .allowBluetoothA2DP, .allowBluetooth])
        }
        
        var settings: [String : Any]
        if configuration != nil {
            settings = configuration!()
        } else {
            settings = defaultRecordingSettings()
        }
        if toMP3 {
            settings[AVSampleRateKey] = 11025
        }
        CXLogger.log(level: .info, message: "settings=\(settings)")
        
        filePath = exportFilePath(fileName: fileName)
        CXLogger.log(level: .info, message: "filePath=\(filePath)")
        if filePath.isEmpty {
            onError?("The file path is empty.")
            return
        }
        let url = URL(string: filePath)!
        do {
            recorder = try AVAudioRecorder(url: url, settings: settings)
        } catch let error {
            CXLogger.log(level: .error, message: "error=\(error)")
            onError?(error.localizedDescription)
            return
        }
        recorder?.delegate = self
        recorder?.isMeteringEnabled = true
        recorder?.prepareToRecord()
    }
    
    /// Starts or resumes audio recording.
    @discardableResult
    @objc public func record() -> Bool {
        return recorder?.record() ?? false
    }
    
    /// Pauses an audio recording.
    @objc public func pause() {
        recorder?.pause()
    }
    
    /// Stops recording and closes the audio file.
    @objc public func stop() {
        recorder?.stop()
        let session = AVAudioSession.sharedInstance()
        if category == .quiet {
            try? session.setActive(false, options: [])
        } else {
            try? session.setCategory(.playAndRecord, options: .defaultToSpeaker)
            try? session.setActive(true, options: [])
        }
    }
    
    /// Deletes a recorded audio file.
    @objc public func deleteRecording() {
        recorder?.stop()
        recorder?.deleteRecording()
    }
    
    /// Calculates the decibels of a recording voice.
    @objc public func calculateDecibels() -> Float {
        // Update the level meter data before calling.
        recorder?.updateMeters()
        // Average value
        var avg: Float = recorder?.averagePower(forChannel: 0) ?? 0
        // Peak value
        //let peak: Float = recorder?.peakPower(forChannel: 0) ?? 0
        let minValue: Float = -60
        let range: Float = 60
        let outRange: Float = 100
        if avg < minValue {
            avg = minValue
        }
        // decibels
        let decibels = (avg + range) / range * outRange
        return decibels
    }
    
}

//MARK: - AVAudioRecorderDelegate

extension CXAudioRecorder: AVAudioRecorderDelegate {
    
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag { onFinish?() }
    }
    
}

#endif
