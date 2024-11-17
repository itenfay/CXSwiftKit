//
//  CXLiveCameraFrameRenderer.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2023/6/5.
//

import Foundation
#if os(iOS)
import UIKit
import AVFoundation

public class CXLiveVideoFrame: NSObject {
    /// A reference to a video pixel buffer object.
    @objc public var pixelBuffer: CVPixelBuffer?
    /// Represents the video orientation.
    @objc public var videoOrientation: AVCaptureVideoOrientation = .portrait
    /// Represents the camera is front.
    @objc public var isFront: Bool = false
}

public class CXLiveCameraFrameRenderer: NSObject, ILiveCameraFrameRender {
    
    private lazy var userVideoViews: [String : UIImageView] = [:]
    private var localVideoView: UIImageView?
    private var hasSwitched: Bool = false
    
    @objc public override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleCamSwitch(_:)),
                                               name: CXLiveCameraSwitchNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleCamSwitch(_ noti: Notification) {
        hasSwitched = true
    }
    
    public func start(_ userId: String, videoView: UIImageView) {
        if userId.isEmpty {
            localVideoView = videoView
        } else {
            userVideoViews[userId] = videoView
        }
    }
    
    public func stop() {
        guard let localVideoView = localVideoView else {
            return
        }
        UIGraphicsBeginImageContext(localVideoView.bounds.size)
        let clearColor = UIColor.clear
        clearColor.setFill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        localVideoView.image = image
    }
    
    public func renderVideoFrame(_ frame: CXLiveVideoFrame, forUser userId: String) {
        guard let pixelBuffer = frame.pixelBuffer else {
            return
        }
        let image = UIImage(ciImage: CIImage(cvPixelBuffer: pixelBuffer))
        DispatchQueue.main.async {
            var newImage: UIImage?
            if frame.videoOrientation != .portrait &&
                frame.videoOrientation != .portraitUpsideDown {
                if self.hasSwitched {
                    newImage = image.ctx_rotate(by: frame.isFront ? .pi : 0)
                } else {
                    let isR = frame.videoOrientation == .landscapeRight
                    newImage = image.ctx_rotate(by: isR ? 0 : .pi)
                }
            } else {
                newImage = image
            }
            
            var videoView: UIImageView?
            if userId.isEmpty {
                videoView = self.localVideoView
            } else {
                videoView = self.userVideoViews[userId]
            }
            videoView?.image = newImage
            videoView?.contentMode = UIView.ContentMode.scaleAspectFill
        }
    }
    
}

extension UIImage {
    
    public func ctx_rotate(by angle: CGFloat) -> UIImage? {
        let destRect = CGRect(origin: .zero, size: self.size).applying(CGAffineTransform(rotationAngle: angle))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())
        
        UIGraphicsBeginImageContext(roundedDestRect.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        context.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        context.rotate(by: angle)
        
        self.draw(in: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}

#endif
