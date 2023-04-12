//
//  AVAsset+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if canImport(AVFoundation)
import AVFoundation

extension CXSwiftBase where T : AVAsset {
    
    /// Loads the duration asynchronously and returns the value.
    public func loadDuration(completion: @escaping (Double) -> Void) {
        base.cx_loadDuration(completion: completion)
    }
    
}

extension AVAsset {
    
    /// Loads the duration asynchronously and returns the value.
    @objc public func cx_loadDuration(completion: @escaping (Double) -> Void) {
        if #available(macOS 12, iOS 15, tvOS 15, watchOS 8, *) {
            Task {
                do {
                    let time = try await load(.duration)
                    //let status = status(of: .duration)
                    //switch status {
                    //case .notYetLoaded: break;
                    //case .loading: break;
                    //case .loaded(let time): break
                    //case .failed(let error): break
                    //}
                    let duration = CMTimeGetSeconds(time)
                    if duration.isNaN || duration.isFinite {
                        completion(0)
                    } else {
                        completion(duration)
                    }
                } catch {
                    CXLogger.log(level: .error, message: "error=\(error)")
                    completion(0)
                }
            }
        } else {
            loadValuesAsynchronously(forKeys: ["duration"]) { [weak self] in
                guard let `self` = self else { return }
                let status = self.statusOfValue(forKey: "duration", error: nil)
                switch status {
                case .unknown:
                    CXLogger.log(level: .info, message: "AVKeyValueStatus.unknown")
                case .loading:
                    CXLogger.log(level: .info, message: "AVKeyValueStatus.loading")
                case .loaded: break
                case .failed:
                    CXLogger.log(level: .info, message: "AVKeyValueStatus.failed")
                case .cancelled:
                    CXLogger.log(level: .info, message: "AVKeyValueStatus.cancelled")
                default: break
                }
                if status == .loaded {
                    let duration = CMTimeGetSeconds(self.duration)
                    if duration.isNaN || duration.isInfinite {
                        completion(0)
                    } else {
                        completion(duration)
                    }
                } else {
                    completion(0)
                }
            }
        }
    }
    
}

#endif
