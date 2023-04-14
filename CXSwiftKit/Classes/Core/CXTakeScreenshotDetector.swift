//
//  CXTakeScreenshotDetector.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

#if canImport(UIKit) && canImport(Photos)
import UIKit

public class CXTakeScreenshotDetector: NSObject {
    
    @objc public override init() {
        super.init()
        self.setup()
    }
    
    private var takeScreenshotHandler: ((Bool, UIImage?) -> Void)?
    
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
            takeScreenshotHandler?(false, nil)
        }
    }
    
    private func fetchImage() {
        CXPermissionManager.shared.fetchLatestImage { [weak self] imageData in
            let image = imageData != nil ? UIImage(data: imageData!) : nil
            self?.takeScreenshotHandler?(true, image)
        }
    }
    
    @objc public func detect(handler: @escaping (_ authorized: Bool, _ image: UIImage?) -> Void) {
        takeScreenshotHandler = handler
    }
    
    deinit {
        self.cx.removeObserver(self, name: UIApplication.userDidTakeScreenshotNotification)
    }
    
}

#endif
