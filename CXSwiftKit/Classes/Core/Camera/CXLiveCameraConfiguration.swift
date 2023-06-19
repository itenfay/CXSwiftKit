//
//  CXLiveCameraConfiguration.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/6/5.
//

import Foundation
#if os(iOS)
import AVFoundation

@objc public enum CXVideoPixelFormat: UInt8 {
    case _NV12, _32BGRA
}

/// The configuration for live camera.
public class CXLiveCameraConfiguration: NSObject {
    /// Represents the position of camera.
    @objc public var isFront: Bool
    /// Defines standard configurations for a capture session.
    @objc public var sessionPreset: AVCaptureSession.Preset
    /// Represents video orientation.
    @objc public var videoOrientation: AVCaptureVideoOrientation
    /// Displays video from a camera device.
    @objc public var videoPreView: UIView?
    /// Represents the pixel format of video.
    @objc public var pixelFormat: CXVideoPixelFormat = ._NV12
    
    @objc convenience public init(
        isFront: Bool,
        sessionPreset: AVCaptureSession.Preset,
        videoOrientation: AVCaptureVideoOrientation)
    {
        self.init(isFront: isFront,
                  sessionPreset: sessionPreset,
                  videoOrientation: videoOrientation,
                  videoPreView: nil)
    }
    
    @objc public init(
        isFront: Bool,
        sessionPreset: AVCaptureSession.Preset,
        videoOrientation: AVCaptureVideoOrientation,
        videoPreView: UIView?)
    {
        self.isFront = isFront
        self.sessionPreset = sessionPreset
        self.videoOrientation = videoOrientation
        self.videoPreView = videoPreView
    }
}

#endif
