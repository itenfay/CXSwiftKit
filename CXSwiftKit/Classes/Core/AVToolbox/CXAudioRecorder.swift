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

@objc public protocol ISKAudioRecorder: AnyObject {
    var isRecording: Bool { get }
    var category: CXRecordingOptionCategory { get }
    var filePath: String { get }
    func makeFilePath(fileName: String) -> String
    var onFinish: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    func prepareToRecord()
    func prepareToRecord(_ fileName: String, category: CXRecordingOptionCategory)
    func prepareToRecord(_ fileName: String, category: CXRecordingOptionCategory, configuration: (() -> [String : Any])?)
    func prepareToRecord(_ fileName: String, category: CXRecordingOptionCategory, configuration: (() -> [String : Any])?, toMP3: Bool)
    func record() -> Bool
    func pause()
    func stop()
    func deleteRecording()
    func calcDecibels() -> Float
    var level: Float { get }
}

public class CXAudioRecorder: NSObject, ISKAudioRecorder {
    
    /// Audio recorder that records audio data to a file.
    private var recorder: AVAudioRecorder?
    
    /// The option category for the recording.
    public private(set) var category: CXRecordingOptionCategory = .speaker
    
    /// The path of a recorded audio file.
    public private(set) var filePath: String = ""
    
    /// The closure for finishing recording.
    public var onFinish: (() -> Void)?
    /// The closure for the error.
    public var onError: ((String) -> Void)?
    
    /// A Boolean value that indicates whether the audio recorder is recording.
    public var isRecording: Bool {
        return recorder?.isRecording ?? false
    }
    
    public func makeFilePath(fileName: String) -> String {
        // PCM
        var prefixName = ""
        if fileName.cx.isNotEmpty() {
            prefixName = fileName
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
    
    public func prepareToRecord() {
        prepareToRecord("", category: .speaker)
    }
    
    public func prepareToRecord(_ fileName: String, category: CXRecordingOptionCategory) {
        prepareToRecord(fileName, category: category, configuration: nil)
    }
    
    public func prepareToRecord(_ fileName: String, category: CXRecordingOptionCategory, configuration: (() -> [String : Any])?) {
        prepareToRecord(fileName, category: category, configuration: configuration, toMP3: false)
    }
    
    public func prepareToRecord(_ fileName: String, category: CXRecordingOptionCategory, configuration: (() -> [String : Any])?, toMP3: Bool) {
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
        
        filePath = makeFilePath(fileName: fileName)
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
    public func record() -> Bool {
        return recorder?.record() ?? false
    }
    
    /// Pauses an audio recording.
    public func pause() {
        recorder?.pause()
    }
    
    /// Stops recording and closes the audio file.
    public func stop() {
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
    public func deleteRecording() {
        recorder?.stop()
        recorder?.deleteRecording()
    }
    
    /// Calculates the decibels of a recording voice.
    public func calcDecibels() -> Float {
        // Update the level meter data before calling.
        recorder?.updateMeters()
        // Average value
        var avg: Float = recorder?.averagePower(forChannel: 0) ?? 0
        // Peak value
        //let peak: Float = recorder?.peakPower(forChannel: 0) ?? 0
        let minValue: Float = -60.0
        let range: Float = 60.0
        let outRange: Float = 100.0
        if avg < minValue {
            avg = minValue
        }
        // decibels
        let decibels = (avg + range) / range * outRange
        return decibels
    }
    
    /// Gets the level of a recording voice.
    /// http://stackoverflow.com/questions/9247255/am-i-doing-the-right-thing-to-convert-decibel-from-120-0-to-0-120/16192481#16192481
    public var level: Float {
        recorder?.updateMeters()
        var level: Float = 0.0 // The linear 0.0 .. 1.0 value we need.
        let minDecibels: Float = -80.0 // Or use -60dB, which I measured in a silent room.
        let decibels = recorder?.averagePower(forChannel: 0) ?? 0
        if decibels < minDecibels {
            level = 0.0
        } else if decibels >= 0.0 {
            level = 1.0
        } else {
            let root: Float = 2.0
            let minAmp: Float = powf(10.0, 0.05 * minDecibels)
            let inverseAmpRange: Float = 1.0 / (1.0 - minAmp)
            let amp: Float = powf(10.0, 0.05 * decibels)
            let adjAmp: Float = (amp - minAmp) * inverseAmpRange
            level = powf(adjAmp, 1.0 / root)
        }
        return level
    }
    
}

//MARK: - AVAudioRecorderDelegate

extension CXAudioRecorder: AVAudioRecorderDelegate {
    
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            onFinish?()
        }
    }
    
}

#endif
