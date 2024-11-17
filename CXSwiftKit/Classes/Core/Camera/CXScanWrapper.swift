//
//  CXScanWrapper.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2023/6/5.
//

import Foundation
#if os(iOS)
import AVFoundation

public class CXScanWrapper: NSObject, IScanWrapper {
    
    /// Configures capture behavior and coordinates the flow of data from input devices to capture outputs.
    private lazy var session = AVCaptureSession()
    /// The default device that captures the video type.
    private var device = AVCaptureDevice.default(for: AVMediaType.video)
    
    /// Provides media input from a capture device to a capture session.
    private var input: AVCaptureDeviceInput?
    /// Processes timed metadata produced by a capture session.
    private var output: AVCaptureMetadataOutput
    
    /// Displays video from a camera device.
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private lazy var photoOutput = AVCapturePhotoOutput()
    
    private lazy var objsCallbackQueue = DispatchQueue(label: "com.cx.objsCallbackQueue")
    
    @objc public var shouldCaptureImage: Bool = false
    @objc public var shouldNeedCXScanResult: Bool = true
    @objc public var supportContinuous: Bool = false
    
    private var _scanResults: [CXScanResult] = []
    
    public var scanResults: [CXScanResult] {
        return _scanResults
    }
    
    private weak var videoPreview: UIView?
    private var objTypes: [AVMetadataObject.ObjectType]
    private var cropRect: CGRect
    
    public required init(videoPreview: UIView, objTypes: [AVMetadataObject.ObjectType], cropRect: CGRect = .zero) {
        self.output = AVCaptureMetadataOutput()
        self.videoPreview = videoPreview
        self.objTypes = objTypes
        self.cropRect = cropRect
        super.init()
        self.configure()
    }
    
    private func configure() {
        guard let device = device else {
            CXLogger.log(level: .error, message: "Could not create video device!")
            return
        }
        do {
            input = try AVCaptureDeviceInput(device: device)
        } catch let error {
            CXLogger.log(level: .error, message: "Could not create video device input: \(error)")
        }
        guard let input = input else {
            return
        }
        if session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }
        session.sessionPreset = AVCaptureSession.Preset.high
        output.setMetadataObjectsDelegate(self, queue: objsCallbackQueue)
        objTypes.removeAll { [weak self] objType in
            guard let self = self else {
                return false
            }
            return self.output.availableMetadataObjectTypes.contains(objType) ? false : true
        }
        if objTypes.isEmpty {
            objTypes.append(contentsOf: [.qr, .code128, .ean13, .ean8])
        }
        output.metadataObjectTypes = objTypes
        if !cropRect.equalTo(.zero) {
            output.rectOfInterest = cropRect
        }
        guard let videoPreview = videoPreview else {
            CXLogger.log(level: .error, message: "No video preview")
            return
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = videoPreview.bounds
        videoPreview.layer.insertSublayer(previewLayer!, at: 0)
        if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.continuousAutoFocus) {
            do {
                try device.lockForConfiguration()
                device.focusMode = .continuousAutoFocus
                device.unlockForConfiguration()
            } catch let error {
                CXLogger.log(level: .error, message: "device.lockForConfiguration(): \(error)")
            }
        }
    }
    
    public func start() {
        if session.isRunning { return }
        shouldNeedCXScanResult = true
        session.startRunning()
    }
    
    public func stop() {
        if !session.isRunning { return }
        shouldNeedCXScanResult = false
        session.stopRunning()
    }
    
    private var resultHandler: (([CXScanResult]) -> Void)?
    
    @objc public func observeOutput(resultHandler: @escaping ([CXScanResult]) -> Void) {
        self.resultHandler = resultHandler
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput,
                       didOutput metadataObjects: [AVMetadataObject],
                       from connection: AVCaptureConnection) {
        guard shouldNeedCXScanResult else {
            // Processing the previous frame.
            return
        }
        shouldNeedCXScanResult = false
        _scanResults.removeAll()
        
        for object in metadataObjects {
            guard let readableCodeObject = object as? AVMetadataMachineReadableCodeObject else {
                continue
            }
            #if !targetEnvironment(simulator)
            _scanResults.append(CXScanResult(value: readableCodeObject.stringValue,
                                             image: UIImage(),
                                             codeType: object.type.rawValue,
                                             codeCorners: readableCodeObject.corners))
            #endif
        }
        if _scanResults.isEmpty || supportContinuous {
            shouldNeedCXScanResult = true
        }
        if !_scanResults.isEmpty {
            if supportContinuous {
                DispatchQueue.main.async {
                    self.resultHandler?(self.scanResults)
                }
            } else if shouldCaptureImage {
                capturePhoto()
            } else {
                stop()
                DispatchQueue.main.async {
                    self.resultHandler?(self.scanResults)
                }
            }
        }
    }
    
    public func capturePhoto() {
        if #available(iOS 11.0, *) {
            let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        } else {
            
        }
    }
    
    public func changeTorch() {
        let isOn = input?.device.torchMode == .off
        setTorch(isOn: isOn)
    }
    
    public func setTorch(isOn: Bool) {
        guard let input = input else {
            return
        }
        let torchMode = input.device.torchMode
        if !input.device.isTorchModeSupported(torchMode) { return }
        do {
            try input.device.lockForConfiguration()
            input.device.torchMode = torchMode
            input.device.unlockForConfiguration()
        } catch let error {
            CXLogger.log(level: .error, message: "device.lockForConfiguration(): \(error)")
        }
    }
    
    public func changeScanRect(_ rect: CGRect) {
        if #available(iOS 13.0, *) {
            output.rectOfInterest = rect
        } else {
            stop()
            output.rectOfInterest = rect
            start()
        }
    }
    
    public func changeScanTypes(_ objTypes: [AVMetadataObject.ObjectType]) {
        var newObjTypes = objTypes
        newObjTypes.removeAll { objType in
            return self.output.availableMetadataObjectTypes.contains(objType) ? false : true
        }
        if newObjTypes.isEmpty { return }
        stop()
        output.metadataObjectTypes = newObjTypes
        start()
    }
    
    public static func defaultMetaDataObjectTypes() -> [AVMetadataObject.ObjectType] {
        var types = [
            AVMetadataObject.ObjectType.qr,
            AVMetadataObject.ObjectType.upce,
            AVMetadataObject.ObjectType.code39,
            AVMetadataObject.ObjectType.code39Mod43,
            AVMetadataObject.ObjectType.ean13,
            AVMetadataObject.ObjectType.ean8,
            AVMetadataObject.ObjectType.code93,
            AVMetadataObject.ObjectType.code128,
            AVMetadataObject.ObjectType.pdf417,
            AVMetadataObject.ObjectType.aztec,
        ]
        
        types.append(AVMetadataObject.ObjectType.interleaved2of5)
        types.append(AVMetadataObject.ObjectType.itf14)
        types.append(AVMetadataObject.ObjectType.dataMatrix)
        
        return types
    }
    
}

extension CXScanWrapper: AVCapturePhotoCaptureDelegate {
    
    @available(iOS 11.0, *)
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let pixelBuffer = photo.pixelBuffer else {
            return
        }
        stop()
        let scannedImage = UIImage(ciImage: CIImage(cvPixelBuffer: pixelBuffer))
        for i in 0 ..< _scanResults.count {
            _scanResults[i].image = scannedImage
        }
        DispatchQueue.main.async {
            self.resultHandler?(self.scanResults)
        }
    }
    
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        guard let photoBuffer = photoSampleBuffer,
              let pixelBuffer = CMSampleBufferGetImageBuffer(photoBuffer)
        else {
            return
        }
        stop()
        let scannedImage = UIImage(ciImage: CIImage(cvPixelBuffer: pixelBuffer))
        for i in 0 ..< _scanResults.count {
            _scanResults[i].image = scannedImage
        }
        DispatchQueue.main.async {
            self.resultHandler?(self.scanResults)
        }
    }
    
}

extension CXScanWrapper: AVCaptureMetadataOutputObjectsDelegate {
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureOutput(output, didOutput: metadataObjects, from: connection)
    }
    
}

#endif
