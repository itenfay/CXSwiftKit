//
//  CXScreenRecorder.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

#if !os(watchOS)
#if canImport(ReplayKit)
import ReplayKit
#endif
#if canImport(Photos)
import Photos
#endif

public class CXScreenRecorder: NSObject {
    
    private var title: String = ""
    private weak var viewController: CXViewController?
    
    @objc public init(title: String, controller: CXViewController) {
        self.title = title
        self.viewController = controller
        super.init()
    }
    
    private var onFinish: (() -> Void)?
    private var onCancel: (() -> Void)?
    private var onError: ((String) -> Void)?
    
    /// Customizes replay video fileName.
    @objc public var replayVideoFileName: String = "cx_replayvideo_sr0426.mp4"
    @objc public var exportVideoHandler: ((String, Error?) -> Void)?
    
    @objc public func onObserve(finish: @escaping () -> Void, cancel: @escaping () -> Void, error: @escaping (String) -> Void) {
        onFinish = finish
        onCancel = cancel
        onError = error
    }
    
    /// Starts recording the app display.
    @available(macOS 11.0, *)
    @objc public func startRecording() {
        let screenRecorder = RPScreenRecorder.shared()
        screenRecorder.delegate = self
        screenRecorder.startRecording()
    }
    
    /// Stops the current recording.
    @objc public func stopRecording() {
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
    
    #if os(iOS) || os(tvOS)
    /// Exports the current recording.
    func exportVideo() {
        #if canImport(Photos)
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        for i in 0..<smartAlbums.count {
            let assetCollection = smartAlbums[i]
            let assetsFetchResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: assetCollection, options: nil)
            if assetCollection.localizedTitle == "视频" || assetCollection.localizedTitle?.lowercased().contains("video") == true {
                if assetsFetchResult.count > 0 {
                    let phAsset: PHAsset = assetsFetchResult.lastObject!
                    _ = PHVideoRequestOptions()
                    
                    let assetResources = PHAssetResource.assetResources(for: phAsset)
                    var resource: PHAssetResource?
                    
                    for assetRes in assetResources {
                        resource = assetRes
                    }
                    if resource == nil {
                        self.exportVideoHandler?("", nil)
                        return
                    }
                    let videoPath = NSTemporaryDirectory().appending(replayVideoFileName)
                    try? FileManager.default.removeItem(atPath: videoPath)
                    PHAssetResourceManager.default().writeData(for: resource!, toFile: URL(fileURLWithPath: videoPath), options: nil, completionHandler: { (error) in
                        if error != nil {
                            CXLogger.log(level: .error, message: "error=\(error!)")
                            self.exportVideoHandler?("", error)
                        } else {
                            self.exportVideoHandler?(videoPath, nil)
                        }
                    })
                }
            }
        }
        #else
        CXLogger.log(level: .error, message: "Can't import photos library... stop exporting!")
        #endif
    }
    #endif
    
}

//MARK: - RPScreenRecorderDelegate, RPPreviewViewControllerDelegate

extension CXScreenRecorder: RPScreenRecorderDelegate, RPPreviewViewControllerDelegate {
    
    @available(macOS 11.0, *)
    public func screenRecorderDidChangeAvailability(_ screenRecorder: RPScreenRecorder) {
        CXLogger.log(level: .info, message: "screenRecorder=\(screenRecorder)")
    }
    
    @available(macOS 11.0, *)
    public func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWith previewViewController: RPPreviewViewController?, error: Error?) {
        if error != nil {
            onError?(error!.localizedDescription)
        }
    }
    
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
            #if os(iOS) || os(tvOS)
            previewController.dismiss(animated: true, completion: nil)
            #endif
            onFinish?()
        } else {
            #if os(macOS)
            viewController?.dismiss(previewController)
            onFinish?()
            #endif
        }
    }
    
    @available(macOS 11.0, *)
    public func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        #if os(macOS)
        viewController?.dismiss(previewController)
        #else
        previewController.dismiss(animated: true, completion: nil)
        #endif
        onFinish?()
    }
    
}

#endif
