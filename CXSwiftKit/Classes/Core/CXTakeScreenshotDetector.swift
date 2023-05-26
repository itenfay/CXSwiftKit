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
    
    private var takeScreenshotHandler: ((Bool, UIImage?) -> Void)?
    
    private lazy var photosPermission: CXPhotosPermission = {
        let photosPermission = CXPhotosPermission()
        return photosPermission
    }()
    
    private func setup() {
        self.cx.addObserver(self, selector: #selector(userDidTakeScreenshot(_:)), name: UIApplication.userDidTakeScreenshotNotification)
    }
    
    @objc private func userDidTakeScreenshot(_ notification: Notification) {
        CXLogger.log(level: .info, message: "The user takes screenshot.")
        if photosPermission.authorized {
            DispatchQueue.cx.mainAsyncAfter(3.0) {
                self.fetchImage()
            }
        } else {
            CXLogger.log(level: .error, message: "The user didn't granted this app access to the photo library.")
            takeScreenshotHandler?(false, nil)
        }
    }
    
    private func fetchImage() {
        photosPermission.fetchLatestImage { [weak self] imageData in
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
#endif
