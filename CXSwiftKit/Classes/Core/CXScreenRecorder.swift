//
//  CXScreenRecorder.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2023/3/16.
//

#if !os(watchOS)
#if canImport(ReplayKit)
import ReplayKit
#endif
#if canImport(Photos)
import Photos
#endif

@objc public protocol ISKScreenRecorder: AnyObject {
    var replayVideoFileName: String { get set }
    init(title: String, controller: CXViewController)
    func onObserve(finish: @escaping () -> Void, cancel: @escaping () -> Void, error: @escaping (String) -> Void)
    @available(macOS 11.0, *)
    func startRecording()
    func stopRecording()
}

public class CXScreenRecorder: NSObject, ISKScreenRecorder {
    
    private var title: String = ""
    private weak var viewController: CXViewController?
    
    public required init(title: String, controller: CXViewController) {
        self.title = title
        self.viewController = controller
        super.init()
    }
    
    private var onFinish: (() -> Void)?
    private var onCancel: (() -> Void)?
    private var onError: ((String) -> Void)?
    
    /// Customizes replay video fileName.
    public var replayVideoFileName: String = "cx_replayvideo_sr0426.mp4"
    
    public func onObserve(
        finish: @escaping () -> Void,
        cancel: @escaping () -> Void,
        error: @escaping (String) -> Void)
    {
        onFinish = finish
        onCancel = cancel
        onError = error
    }
    
    /// Starts recording the app display.
    @available(macOS 11.0, *)
    public func startRecording() {
        let screenRecorder = RPScreenRecorder.shared()
        screenRecorder.delegate = self
        screenRecorder.startRecording()
    }
    
    /// Stops the current recording.
    public func stopRecording() {
        let screenRecorder = RPScreenRecorder.shared()
        screenRecorder.stopRecording { vc, error in
            if error == nil {
                vc?.previewControllerDelegate = self
                vc?.title = self.title
                #if os(macOS)
                self.viewController?.presentAsSheet(vc!)
                #else
                self.viewController?.present(vc!, animated: true)
                #endif
            } else {
                CXLogger.log(level: .error, message: "error=\(error!)")
            }
        }
    }
    
}

//MARK: - RPScreenRecorderDelegate, RPPreviewViewControllerDelegate

extension CXScreenRecorder: RPScreenRecorderDelegate, RPPreviewViewControllerDelegate {
    
    @available(macOS 11.0, *)
    public func screenRecorderDidChangeAvailability(_ screenRecorder: RPScreenRecorder) {
        CXLogger.log(level: .info, message: "screenRecorder=\(screenRecorder)")
    }
    
    @available(iOS 11.0, tvOS 11.0, macOS 11.0, *)
    public func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWith previewViewController: RPPreviewViewController?, error: Error?) {
        if error != nil {
            onError?(error!.localizedDescription)
        }
    }
    
    #if !os(tvOS)
    @available(macOS 11.0, *)
    public func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        // Cancel.
        if activityTypes.count == 0 {
            #if os(macOS)
            viewController?.dismiss(previewController)
            #else
            previewController.dismiss(animated: true, completion: nil)
            #endif
            onCancel?()
            return
        }
        // Save to camera roll.
        if activityTypes.contains("com.apple.UIKit.activity.SaveToCameraRoll") {
            #if os(iOS)
            previewController.dismiss(animated: true, completion: nil)
            #endif
        } else {
            #if os(macOS)
            viewController?.dismiss(previewController)
            #endif
        }
        onFinish?()
    }
    #endif
    
    #if os(tvOS)
    public func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true, completion: nil)
        onFinish?()
    }
    #endif
    
}

#endif
