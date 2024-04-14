//
//  CXScanProtocol.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2023/6/5.
//

import Foundation
#if os(iOS)
import AVFoundation

@objc public protocol IScanWrapper: AnyObject {
    init(videoPreview: UIView, objTypes: [AVMetadataObject.ObjectType], cropRect: CGRect)
    var scanResults: [CXScanResult] { get }
    func start()
    func stop()
    func capturePhoto()
    func setTorch(isOn: Bool)
    func changeTorch()
    func changeScanRect(_ rect: CGRect)
    func changeScanTypes(_ objTypes: [AVMetadataObject.ObjectType])
}

#endif
