//
//  CXTakeScreenshotDetector.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

#if canImport(Photos) && canImport(UIKit)
import UIKit
import Photos

public class CXTakeScreenshotDetector: NSObject {
    
    @objc public override init() {
        super.init()
        self.setup()
    }
    
    private var takeScreenshotHandler: ((UIImage?) -> Void)?
    
    private func setup() {
        self.cx.addObserver(self, selector: #selector(userDidTakeScreenshot(_:)), name: UIApplication.userDidTakeScreenshotNotification)
    }
    
    @objc private func userDidTakeScreenshot(_ notification: Notification) {
        CXLogger.log(level: .info, message: "The user takes screenshot.")
        if CXPermissionManager.shared.photoLibraryAuthorized {
            DispatchQueue.cx.mainAsyncAfter(3.0) {
                self.fetchImage()
            }
        } else {
            CXLogger.log(level: .error, message: "The user didn't granted this app access to the photo library.")
        }
    }
    
    private func fetchImage() {
        CXPermissionManager.shared.fetchLatestImage { [weak self] imageData in
            self?.takeScreenshotHandler?(
                imageData != nil
                ? UIImage(data: imageData!)
                : nil)
        }
    }
    
    @objc public func detect(handler: @escaping (UIImage?) -> Void) {
        takeScreenshotHandler = handler
    }
    
    deinit {
        self.cx.removeObserver(self, name: UIApplication.userDidTakeScreenshotNotification)
    }
    
}

#endif
