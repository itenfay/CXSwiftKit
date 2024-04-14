//
//  CXTakeScreenshotDetector.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

#if os(iOS) || os(tvOS)
import UIKit
#if canImport(Photos)
import Photos

public class CXTakeScreenshotDetector: NSObject {
    
    @objc public override init() {
        super.init()
        self.setup()
    }
    
    private var takeScreenshotAction: (() -> Void)?
    private var takeScreenshotHandler: ((Bool, UIImage?) -> Void)?
    
    private lazy var photoLibraryOperator: CXPhotoLibraryOperator = CXPhotoLibraryOperator()
    
    private func setup() {
        self.cx.addObserver(self, selector: #selector(userDidTakeScreenshot(_:)), name: UIApplication.userDidTakeScreenshotNotification)
    }
    
    @objc private func userDidTakeScreenshot(_ notification: Notification) {
        CXLogger.log(level: .info, message: "The user takes screenshot.")
        takeScreenshotAction?()
        var status: PHAuthorizationStatus
        if #available(iOS 14, tvOS 14, macOS 11.0, *) {
            status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            status = PHPhotoLibrary.authorizationStatus()
        }
        if status == .authorized {
            DispatchQueue.cx.mainAsyncAfter(3.0) {
                self.fetchImage()
            }
        } else {
            CXLogger.log(level: .error, message: "The user didn't granted this app access to the photo library.")
            takeScreenshotHandler?(false, nil)
        }
    }
    
    private func fetchImage() {
        let latestAsset = photoLibraryOperator.fetchLatestAsset()
        photoLibraryOperator.fetchImageData(fromAsset: latestAsset) { [weak self] (data, dataUTI, info) in
            let image = data != nil ? UIImage(data: data!) : nil
            self?.takeScreenshotHandler?(true, image)
        }
    }
    
    /// Gets a screenshot of view directly by this method.
    @objc public func trigger(action: @escaping () -> Void) {
        takeScreenshotAction = action
    }
    
    @objc public func detect(handler: @escaping (_ authorized: Bool, _ image: UIImage?) -> Void) {
        takeScreenshotHandler = handler
    }
    
    deinit {
        self.cx.removeObserver(self, name: UIApplication.userDidTakeScreenshotNotification)
    }
    
}

#endif
#endif
