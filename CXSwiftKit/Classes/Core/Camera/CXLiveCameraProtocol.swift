//
//  LiveCameraProtocol.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2023/6/5.
//

import Foundation
#if os(iOS)
import AVFoundation
import CoreMedia

@objc public protocol ILiveCameraFrameCapture: AnyObject {
    var configResult: CXLiveCameraConfigResult { get }
    var session: AVCaptureSession? { get }
    var toggleAnimation: Bool { set get }
    func checkPermission(completionHandler handler: @escaping (Bool) -> Void)
    func createSession(withConfiguration configuration: CXLiveCameraConfiguration)
    func startCapturing()
    func stopCapturing()
    func switchCamera()
    func setTorch(isOn: Bool)
    func changeTorch()
    func autoFocus(continuous: Bool)
    func setFocus(_ focusMode: AVCaptureDevice.FocusMode)
    func onMirror(_ isOn: Bool)
    func updateVideoOrientation(_ orientation: AVCaptureVideoOrientation)
}

@objc public protocol LiveCameraVideoDataOutputDelegate: AnyObject {
    func outputVideoSampleBuffer(_ sampleBuffer: CMSampleBuffer)
    func dropVideoSampleBuffer(_ sampleBuffer: CMSampleBuffer)
}

@objc public protocol ILiveCameraFrameRender: AnyObject {
    func start(_ userId: String, videoView: UIImageView)
    func stop()
    func renderVideoFrame(_ frame: CXLiveVideoFrame, forUser userId: String)
}

#endif
