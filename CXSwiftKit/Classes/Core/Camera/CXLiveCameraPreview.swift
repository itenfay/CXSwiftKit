//
//  CXLiveCameraPreview.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/6/5.
//

import Foundation
#if os(iOS)
import UIKit
import AVFoundation

/// The preview for live camera.
public class CXLiveCameraPreview: UIView {
    
    /// Uses AVCaptureVideoPreviewLayer as the view's backing layer.
    public override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    @objc public var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
    
    /// Connects the layer to a capture session.
    @objc public var session: AVCaptureSession? {
        get { previewLayer.session }
        set { previewLayer.session = newValue }
    }
    
}

#endif
