//
//  CXLiveCameraFrameCapturer.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/6/5.
//

import Foundation
#if os(iOS)
import AVFoundation

public let CXLiveCameraSwitchNotification = Notification.Name("CXLiveCameraSwitchNotification")

@objc public enum CXLiveCameraConfigResult: UInt8 {
    case success, failed
}

public class CXLiveCameraFrameCapturer: NSObject, ILiveCameraFrameCapture {
    
    @objc public weak var delegate: LiveCameraVideoDataOutputDelegate?
    
    /// Communicates with the session and other session objects on this queue.
    private lazy var sessionQueue = DispatchQueue(label: "com.cx.sessionQueue")
    private lazy var cameraDelegateQueue = DispatchQueue(label: "com.cx.cameraDelegateQueue")
    
    /// Configures capture behavior and coordinates the flow of data from input devices to capture outputs.
    @Atomic private var captureSession: AVCaptureSession?
    /// Represents a hardware or virtual capture device like a camera or microphone.
    //@Atomic private var inputCamera: AVCaptureDevice?
    /// Provides video input from a capture device to a capture session.
    @Atomic private var videoInput: AVCaptureDeviceInput?
    /// Records video and provides access to video frames for processing.
    @Atomic private var videoOutput: AVCaptureVideoDataOutput?
    /// Provides audio input from a capture device to a capture session.
    @Atomic private var audioInput: AVCaptureDeviceInput?
    /// Represents a connection from a capture input to a capture output.
    @Atomic private var videoConnection: AVCaptureConnection?
    /// Processing timed metadata produced by a capture session.
    ///@Atomic private var metaOutput: AVCaptureMetadataOutput?
    
    /// Indicates to execute animation when switching camera.
    public var toggleAnimation: Bool = false
    
    @objc public private(set) var camConfiguration: CXLiveCameraConfiguration?
    /// The result for capture session configuration.
    public private(set) var configResult: CXLiveCameraConfigResult = .failed
    
    /// Checks the app's permission.
    public func checkPermission(completionHandler handler: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            handler(true)
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { granted in
                handler(granted)
                self.sessionQueue.resume()
            }
        case .restricted, .denied:
            handler(false)
        @unknown default:
            handler(false)
        }
    }
    
    public var session: AVCaptureSession? {
        return captureSession
    }
    
    public func createSession(withConfiguration configuration: CXLiveCameraConfiguration) {
        camConfiguration = configuration
        captureSession = AVCaptureSession()
        sessionQueue.async { [weak self] in
            self?.configureSession()
        }
    }
    
    private func configureSession() {
        if configResult == .success {
            return
        }
        guard let session = captureSession, let config = camConfiguration else {
            return
        }
        session.beginConfiguration()
        // Add video input. Choose the dual camera if available, otherwise default to a wide angle camera.
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                        for: .video,
                                                        position: config.isFront ? .front : .back)
        else {
            configResult = .failed
            session.commitConfiguration()
            return
        }
        do {
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            guard session.canAddInput(videoDeviceInput) else {
                CXLogger.log(level: .error, message: "Could not add video device input to the session")
                configResult = .failed
                session.commitConfiguration()
                return
            }
            session.addInput(videoDeviceInput)
            videoInput = videoDeviceInput
            
            videoOutput = AVCaptureVideoDataOutput()
            videoOutput?.setSampleBufferDelegate(self, queue: cameraDelegateQueue)
            
            let captureSettings: [String : Any] = config.pixelFormat == ._NV12
            ? [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
            : [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA]
            videoOutput?.videoSettings = captureSettings
            
            videoOutput?.alwaysDiscardsLateVideoFrames = true
            if let output = videoOutput, session.canAddOutput(output) {
                session.addOutput(output)
            }
            
            // Add audio input.
            if let audioDevice = AVCaptureDevice.default(for: .audio) {
                do {
                    let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice)
                    if session.canAddInput(audioDeviceInput) {
                        session.addInput(audioDeviceInput)
                        audioInput = audioDeviceInput
                    } else {
                        CXLogger.log(level: .error, message: "Could not add audio device input to the session")
                    }
                } catch let error {
                    CXLogger.log(level: .error, message: "Could not create audio device input: \(error)")
                }
            } else {
                CXLogger.log(level: .error, message: "Could not create audio device")
            }
            //let audioOutput = AVCaptureAudioDataOutput()
            //audioOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "com.cx.audioQueue"))
            //session.addOutput(audioOutput)
            
            if session.canSetSessionPreset(config.sessionPreset) {
                session.sessionPreset = config.sessionPreset
            } else {
                session.sessionPreset = AVCaptureSession.Preset.photo
            }
            session.commitConfiguration()
            configResult = .success
            
            videoConnection = videoOutput?.connection(with: AVMediaType.video)
            if videoConnection?.isVideoOrientationSupported == true {
                videoConnection?.videoOrientation = config.videoOrientation
            }
            if config.isFront {
                onMirror(true)
            }
            
            DispatchQueue.main.async {
                self.displayVideoPreview(with: session)
            }
        } catch let error {
            CXLogger.log(level: .error, message: "Could not create video device input: \(error)")
            configResult = .failed
            session.commitConfiguration()
        }
    }
    
    private func displayVideoPreview(with session: AVCaptureSession) {
        guard let videoPreview = camConfiguration?.videoPreView else {
            return
        }
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer.frame = videoPreview.bounds
        videoPreview.layer.insertSublayer(videoPreviewLayer, at: 0)
    }
    
    public func switchCamera() {
        if configResult != .success {
            return
        }
        if toggleAnimation {
            DispatchQueue.main.async {
                self.execFlipAnimation()
            }
        }
        startSwitching()
    }
    
    private func execFlipAnimation() {
        if let videoPreView = camConfiguration?.videoPreView {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut]) {
                videoPreView.transform = CGAffineTransform(scaleX: -1, y: 1)
            } completion: { _ in
                videoPreView.transform = .identity
            }
        }
    }
    
    private func startSwitching() {
        guard let session = captureSession else { return }
        for input in session.inputs {
            guard let deviceInput = input as? AVCaptureDeviceInput else {
                continue
            }
            let device = deviceInput.device
            if device.hasMediaType(.video) {
                let position = device.position
                guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                                for: .video,
                                                                position: position == .front ? .back : .front)
                else { return }
                do {
                    let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                    session.beginConfiguration()
                    session.removeInput(deviceInput)
                    session.addInput(videoDeviceInput)
                    videoInput = videoDeviceInput
                    camConfiguration?.isFront = position == .front ? false : true
                    NotificationCenter.default.post(name: CXLiveCameraSwitchNotification, object: nil)
                    session.commitConfiguration()
                    onMirror(camConfiguration?.isFront == true)
                    return
                } catch {
                    CXLogger.log(level: .error, message: "Could not create video device input: \(error)")
                }
            }
        }
    }
    
    public func startCapturing() {
        if captureSession == nil {
            return
        }
        sessionQueue.async { [weak self] in
            guard let s = self else { return }
            if s.captureSession?.isRunning == true {
                return
            }
            s.captureSession?.startRunning()
        }
    }
    
    public func stopCapturing() {
        if captureSession == nil {
            return
        }
        sessionQueue.async { [weak self] in
            guard let s = self else { return }
            if s.captureSession?.isRunning == false {
                return
            }
            s.captureSession?.stopRunning()
        }
    }
    
    public func setTorch(isOn: Bool) {
        guard let input = videoInput else { return }
        let torchMode = input.device.torchMode
        if !input.device.isTorchModeSupported(torchMode) { return }
        do {
            try input.device.lockForConfiguration()
            input.device.torchMode = isOn ? AVCaptureDevice.TorchMode.on : .off
            input.device.unlockForConfiguration()
        } catch let error {
            CXLogger.log(level: .error, message: "device.lockForConfiguration(): \(error)")
        }
    }
    
    public func changeTorch() {
        let isOn = videoInput?.device.torchMode == .off
        setTorch(isOn: isOn)
    }
    
    public func autoFocus(continuous: Bool) {
        guard let input = videoInput else { return }
        if !input.device.isFocusPointOfInterestSupported { return }
        let focusMode: AVCaptureDevice.FocusMode = continuous ? .continuousAutoFocus : .autoFocus
        if !input.device.isFocusModeSupported(focusMode) { return }
        do {
            try input.device.lockForConfiguration()
            input.device.focusMode = focusMode
            input.device.unlockForConfiguration()
        } catch let error {
            CXLogger.log(level: .error, message: "device.lockForConfiguration(): \(error)")
        }
    }
    
    public func setFocus(_ focusMode: AVCaptureDevice.FocusMode) {
        guard let input = videoInput else { return }
        if !input.device.isFocusPointOfInterestSupported ||
            !input.device.isFocusModeSupported(focusMode) {
            return
        }
        do {
            try input.device.lockForConfiguration()
            input.device.focusMode = focusMode
            input.device.unlockForConfiguration()
        } catch let error {
            CXLogger.log(level: .error, message: "device.lockForConfiguration(): \(error)")
        }
    }
    
    public func onMirror(_ isOn: Bool) {
        guard let videoOutput = videoOutput else { return }
        videoOutput.connections.forEach { connection in
            for port in connection.inputPorts {
                if port.mediaType == .video {
                    if connection.isVideoMirroringSupported {
                        connection.isVideoMirrored = true
                    }
                    break
                }
            }
        }
    }
    
    public func updateVideoOrientation(_ orientation: AVCaptureVideoOrientation) {
        guard let videoOutput = videoOutput else { return }
        videoOutput.connections.forEach { connection in
            for port in connection.inputPorts {
                if port.mediaType == .video {
                    if connection.isVideoOrientationSupported {
                        connection.videoOrientation = orientation
                    }
                }
                break
            }
        }
    }
    
}

//MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CXLiveCameraFrameCapturer: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        delegate?.outputVideoSampleBuffer(sampleBuffer)
    }
    
    public func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        delegate?.dropVideoSampleBuffer(sampleBuffer)
    }
    
}

//MARK: - AVCaptureAudioDataOutputSampleBufferDelegate

//extension CXLiveCameraFrameCapturer: AVCaptureAudioDataOutputSampleBufferDelegate {}

#endif
