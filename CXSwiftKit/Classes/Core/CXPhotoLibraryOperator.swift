//
//  CXPhotoLibraryOperator.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/8/12.
//

import Foundation
#if os(iOS) || os(tvOS) || os(macOS)
import Photos
#if canImport(AVFoundation)
import AVFoundation
#endif

public class CXAlbumModel: NSObject {
    @objc public let name: String
    @objc public let identifier: String
    @objc public let count: Int
    @objc public let assetCollection: PHAssetCollection
    
    @objc public init(name: String, identifier: String, count: Int, assetCollection: PHAssetCollection) {
        self.name = name
        self.identifier = identifier
        self.count = count
        self.assetCollection = assetCollection
    }
}

public enum CXAssetCreationType: UInt8 {
    case image
    case imageByFileURL
    case videoByFileURL
}

public let CXPHLErrorDomain = "cx.errordomain.photolibrary.operation"

public class CXPhotoLibraryOperator: NSObject {
    
    private lazy var photosPermission = CXPhotosPermission()
    
    @objc public override init() {
        super.init()
    }
    
    public enum PHLError: Error {
        case unauthorized(String)
        case failed(String)
    }
    
    @objc public func getPhotosPermission() -> CXPhotosPermission {
        return photosPermission
    }
    
    /// Adds a photo to album.
    public func addPhoto(_ image: CXImage, toAlbum name: String, completionHandler: @escaping (Bool, PHLError?) -> Void) throws {
        try addAsset(image, type: .image, title: name, completionHandler: completionHandler)
    }
    
    /// Adds a photo to album.
    @objc public func _addPhoto(_ image: CXImage, toAlbum name: String, completionHandler: @escaping (Bool, NSError?) -> Void) {
        do {
            try addPhoto(image, toAlbum: name, completionHandler: { success, error in
                if success {
                    completionHandler(true, nil)
                } else {
                    completionHandler(false, NSError(domain: CXPHLErrorDomain, code: -5, userInfo: [NSLocalizedDescriptionKey : error?.localizedDescription ?? ""]))
                }
            })
        } catch let error {
            completionHandler(false, NSError(domain: CXPHLErrorDomain, code: -5, userInfo: [NSLocalizedDescriptionKey : error.localizedDescription]))
        }
    }
    
    /// Adds a photo to album by file url.
    public func addPhoto(_ fileURL: URL, toAlbum name: String, completionHandler: @escaping (Bool, PHLError?) -> Void) throws {
        try addAsset(fileURL, type: .imageByFileURL, title: name, completionHandler: completionHandler)
    }
    
    /// Adds a photo to album by file url.
    @objc public func _addPhotoByFileURL(_ fileURL: URL, toAlbum name: String, completionHandler: @escaping (Bool, NSError?) -> Void) {
        do {
            try addPhoto(fileURL, toAlbum: name) { success, error in
                if success {
                    completionHandler(true, nil)
                } else {
                    completionHandler(false, NSError(domain: CXPHLErrorDomain, code: -6, userInfo: [NSLocalizedDescriptionKey : error?.localizedDescription ?? ""]))
                }
            }
        } catch let error {
            completionHandler(false, NSError(domain: CXPHLErrorDomain, code: -6, userInfo: [NSLocalizedDescriptionKey : error.localizedDescription]))
        }
    }
    
    /// Adds a video to album by file url.
    public func addVideo(_ fileURL: URL, toAlbum name: String, completionHandler: @escaping (Bool, PHLError?) -> Void) throws {
        try addAsset(fileURL, type: .videoByFileURL, title: name, completionHandler: completionHandler)
    }
    
    /// Adds a video to album by file url.
    @objc public func _addVideo(_ fileURL: URL, toAlbum name: String, completionHandler: @escaping (Bool, NSError?) -> Void) {
        do {
            try addVideo(fileURL, toAlbum: name) { success, error in
                if success {
                    completionHandler(true, nil)
                } else {
                    completionHandler(false, NSError(domain: CXPHLErrorDomain, code: -7, userInfo: [NSLocalizedDescriptionKey : error?.localizedDescription ?? ""]))
                }
            }
        } catch let error {
            completionHandler(false, NSError(domain: CXPHLErrorDomain, code: -7, userInfo: [NSLocalizedDescriptionKey : error.localizedDescription]))
        }
    }
    
    private func addAsset(_ target: Any, type: CXAssetCreationType, title: String, completionHandler: @escaping (Bool, PHLError?) -> Void) throws {
        if title.isEmpty {
            throw PHLError.failed("A name for the new asset collection is empty")
        }
        photosPermission.requestAccess { [weak self] result in
            if result.status == .authorized {
                self?._addAsset(target, type: type, title: title, completionHandler: completionHandler)
            } else {
                completionHandler(false, PHLError.unauthorized(result.description))
            }
        }
    }
    
    @objc public func createAssetCollection(withTitle title: String, completionHandler: @escaping (PHAssetCollection?, NSError?) -> Void) {
        var album: PHAssetCollection?
        let fetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        fetchResult.enumerateObjects { assetCollection, index, stop in
            CXLogger.log(level: .info, message: "index=" + "\(index)" + ", title=" + (assetCollection.localizedTitle ?? "") + ", id=" + assetCollection.localIdentifier)
            if assetCollection.localizedTitle == title {
                album = assetCollection
                stop.pointee = true
            }
        }
        
        if album != nil {
            completionHandler(album, nil)
            return
        }
        
        var albumPlaceholder: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            // Request creating an album with parameter name.
            let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
            // Get a placeholder for the new album.
            albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
        }, completionHandler: { success, error in
            if success {
                guard let albumPlaceholder = albumPlaceholder else {
                    // Album placeholder is nil.
                    completionHandler(nil, NSError(domain: CXPHLErrorDomain, code: -3, userInfo: [NSLocalizedDescriptionKey : "Album placeholder is nil"]))
                    return
                }
                let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumPlaceholder.localIdentifier], options: nil)
                guard let album: PHAssetCollection = fetchResult.firstObject else {
                    // FetchResult has no PHAssetCollection
                    completionHandler(nil, NSError(domain: CXPHLErrorDomain, code: -4, userInfo: [NSLocalizedDescriptionKey : "FetchResult has no asset collection"]))
                    return
                }
                // Created successfully!
                //CXLogger.log(level: .info, message: "assetCollectionType=\(album.assetCollectionType)")
                completionHandler(album, nil)
            }
            else if let e = error {
                // Creating album failed with error.
                completionHandler(nil, NSError(domain: CXPHLErrorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey : e.localizedDescription]))
            }
            else {
                // Creating album failed with no error.
                completionHandler(nil, NSError(domain: CXPHLErrorDomain, code: -2, userInfo: [NSLocalizedDescriptionKey : "Creating album failed"]))
            }
        })
    }
    
    private func _addAsset(_ target: Any, type: CXAssetCreationType, title: String, completionHandler: @escaping (Bool, PHLError?) -> Void) {
        createAssetCollection(withTitle: title) { assetCollection, error in
            if let e = error {
                completionHandler(false, PHLError.failed(e.localizedDescription))
                return
            }
            PHPhotoLibrary.shared().performChanges({
                guard let album = assetCollection else {
                    // Asset collection is nil.
                    completionHandler(false, PHLError.failed("Asset collection is nil"))
                    return
                }
                // Request editing the album.
                guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: album) else {
                    // Album change request has failed
                    completionHandler(false, PHLError.failed("Album change request has failed"))
                    return
                }
                
                // Request creating an asset from the image.
                //var createAssetRequest: PHAssetChangeRequest!
                var createAssetRequest: PHAssetCreationRequest!
                if type == .image {
                    if let image = target as? CXImage {
                        createAssetRequest = PHAssetCreationRequest.creationRequestForAsset(from: image)
                    } else {
                        completionHandler(false, PHLError.failed("The target type is wrong"))
                        return
                    }
                } else {
                    guard let fileURL = target as? URL else {
                        completionHandler(false, PHLError.failed("The target type is wrong"))
                        return
                    }
                    createAssetRequest = PHAssetCreationRequest.forAsset()
                    if type == .imageByFileURL {
                        //createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileURL)
                        createAssetRequest.addResource(with: .photo, fileURL: fileURL, options: nil)
                    } else if type == .videoByFileURL {
                        //createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
                        createAssetRequest.addResource(with: .video, fileURL: fileURL, options: nil)
                    } else {
                        completionHandler(false, PHLError.failed("Unsupport asset creation type"))
                        return
                    }
                }
                
                // Get a placeholder for the new asset and add it to the album editing request.
                guard let placeholder = createAssetRequest.placeholderForCreatedAsset else {
                    // The placeholder for created asset is nil
                    completionHandler(false, PHLError.failed("The placeholder for created asset is nil"))
                    return
                }
                
                albumChangeRequest.addAssets([placeholder] as NSArray)
            }, completionHandler: { success, error in
                if success {
                    completionHandler(true, nil)
                }
                else if let e = error {
                    // Save album failed with error.
                    completionHandler(false, PHLError.failed(e.localizedDescription))
                }
                else {
                    // Save album failed with no error.
                    completionHandler(false, PHLError.failed("Saving to album failed"))
                }
            })
        }
    }
    
    /// Adds a photo to default album.
    public func addPhoto(_ image: CXImage, completionHandler: @escaping (Bool, PHLError?) -> Void) {
        addAsset(image, type: .image, completionHandler: completionHandler)
    }
    
    /// Adds a photo to default album.
    @objc public func _addPhoto(_ image: CXImage, completionHandler: @escaping (Bool, NSError?) -> Void) {
        addPhoto(image) { success, error in
            if success {
                completionHandler(true, nil)
            } else {
                completionHandler(false, NSError(domain: CXPHLErrorDomain, code: -8, userInfo: [NSLocalizedDescriptionKey : error?.localizedDescription ?? ""]))
            }
        }
    }
    
    /// Adds a photo to default album by file url.
    public func addPhoto(_ fileURL: URL, completionHandler: @escaping (Bool, PHLError?) -> Void) {
        addAsset(fileURL, type: .imageByFileURL, completionHandler: completionHandler)
    }
    
    /// Adds a photo to default album by file url.
    @objc public func _addPhotoByFileURL(_ fileURL: URL, completionHandler: @escaping (Bool, NSError?) -> Void) {
        addPhoto(fileURL) { success, error in
            if success {
                completionHandler(true, nil)
            } else {
                completionHandler(false, NSError(domain: CXPHLErrorDomain, code: -9, userInfo: [NSLocalizedDescriptionKey : error?.localizedDescription ?? ""]))
            }
        }
    }
    
    /// Adds a video to default album.
    public func addVideo(_ fileURL: URL, completionHandler: @escaping (Bool, PHLError?) -> Void) {
        addAsset(fileURL, type: .videoByFileURL, completionHandler: completionHandler)
    }
    
    /// Adds a video to default album.
    @objc public func _addVideo(_ fileURL: URL, completionHandler: @escaping (Bool, NSError?) -> Void) {
        addVideo(fileURL) { success, error in
            if success {
                completionHandler(true, nil)
            } else {
                completionHandler(false, NSError(domain: CXPHLErrorDomain, code: -10, userInfo: [NSLocalizedDescriptionKey : error?.localizedDescription ?? ""]))
            }
        }
    }
    
    private func addAsset(_ target: Any, type: CXAssetCreationType, completionHandler: @escaping (Bool, PHLError?) -> Void) {
        photosPermission.requestAccess { [weak self] result in
            if result.status == .authorized {
                self?._addAsset(target, type: type, completionHandler: completionHandler)
            } else {
                completionHandler(false, PHLError.unauthorized(result.description))
            }
        }
    }
    
    private func _addAsset(_ target: Any, type: CXAssetCreationType, completionHandler: @escaping (Bool, PHLError?) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            if #available(iOS 9, tvOS 10, macOS 10.15, *) {
                var request: PHAssetCreationRequest!
                if type == .image {
                    guard let image = target as? CXImage else {
                        completionHandler(false, PHLError.failed("The target type is wrong"))
                        return
                    }
                    //var imgData: Data?
                    //#if os(macOS)
                    //imgData = image.tiffRepresentation
                    //#else
                    //imgData = image.pngData()
                    //#endif
                    //if let data = imgData {
                    //    request.addResource(with: .photo, data: data, options: nil)
                    //} else {
                    //    completionHandler(false, PHLError.failed("The image to data failed"))
                    //    return
                    //}
                    request = PHAssetCreationRequest.creationRequestForAsset(from: image)
                } else {
                    guard let fileURL = target as? URL else {
                        completionHandler(false, PHLError.failed("The target type is wrong"))
                        return
                    }
                    request = PHAssetCreationRequest.forAsset()
                    if type == .imageByFileURL {
                        request.addResource(with: .photo, fileURL: fileURL, options: nil)
                    } else if type == .videoByFileURL {
                        request.addResource(with: .video, fileURL: fileURL, options: nil)
                    } else {
                        completionHandler(false, PHLError.failed("Unsupport type"))
                        return
                    }
                }
            } else {
                // Don't execute this.
                //PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(localFilePath: "xxxxxxx"))
            }
        }, completionHandler: { success, error in
            if success {
                completionHandler(true, nil)
            }
            else if let e = error {
                // Save album failed with error.
                completionHandler(false, PHLError.failed(e.localizedDescription))
            }
            else {
                // Save album failed with no error.
                completionHandler(false, PHLError.failed("Saving to album failed"))
            }
        })
    }
    
    /// Returns the list of `CXAlbumModel` model.
    @objc public func listAlbums() -> [CXAlbumModel] {
        var albums: [CXAlbumModel] = [CXAlbumModel]()
        let fetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        fetchResult.enumerateObjects { assetCollection, index, stop in
            let model = CXAlbumModel(name: assetCollection.localizedTitle ?? "",
                                     identifier: assetCollection.localIdentifier,
                                     count: assetCollection.estimatedAssetCount,
                                     assetCollection: assetCollection)
            albums.append(model)
        }
        return albums
    }
    
    /// Fethes all assets matching the specified options.
    ///
    /// let fetchOptions = PHFetchOptions()
    /// fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
    /// fetchOptions.predicate = NSPredicate(format:"mediaType = %d", PHAssetMediaType.image.rawValue)
    @objc public func fetchAssets(withOptions options: PHFetchOptions? = nil) -> [PHAsset] {
        var assets: [PHAsset] = []
        let fetchResult = PHAsset.fetchAssets(with: options)
        fetchResult.enumerateObjects { asset, index, stop in
            assets.append(asset)
        }
        return assets
    }
    
    /// Fethes assets from the specified asset collection.
    @objc public func fetchAssets(inAssetCollection assetCollection: PHAssetCollection, options: PHFetchOptions? = nil) -> [PHAsset] {
        var assets: [PHAsset] = []
        //options?.fetchLimit = 1
        let fetchResult = PHAsset.fetchAssets(in: assetCollection, options: options)
        fetchResult.enumerateObjects { asset, index, stop in
            assets.append(asset)
        }
        return assets
    }
    
    /// Fethes assets with the specified media type.
    ///
    /// Gets the content from the asset:
    /// PHImageManager.default().requestImageDataAndOrientation(for: asset, options: nil) { data, dataUTI, orientation, info in } //@available(iOS 13, tvOS 13, macOS 10.15, *)
    /// PHImageManager.default().requestImageData(for: asset, options: nil) { imageData, dataUTI, orientation, info in } // This is available in swift.
    /// PHImageManager.default().requestLivePhoto(for: asset, targetSize: CGSize.zero, contentMode: .aspectFit, options: nil) { livePhoto, info in }
    /// PHImageManager.default().requestAVAsset(forVideo: asset, options: nil) { asset, audioMix, userInfo in }
    /// let videoReqOptions = PHVideoRequestOptions()
    /// videoReqOptions.isNetworkAccessAllowed = false
    /// videoReqOptions.version = .original
    /// videoReqOptions.deliveryMode = .mediumQualityFormat
    /// videoReqOptions.progressHandler = nil
    /// PHImageManager.default().requestPlayerItem(forVideo: asset, options: videoReqOptions) { playerItem, info in }
    @objc public func fetchAssets(withMediaType mediaType: PHAssetMediaType, options: PHFetchOptions? = nil) -> [PHAsset] {
        var assets: [PHAsset] = []
        let fetchResult = PHAsset.fetchAssets(with: mediaType, options: options)
        fetchResult.enumerateObjects { asset, index, stop in
            assets.append(asset)
        }
        return assets
    }
    
    /// Fethes the latest asset.
    @objc public func fetchLatestAsset() -> PHAsset? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        return fetchResult.firstObject
    }
    
    /// Fetches a latest image from the photo library.
    ///
    /// - Parameter asset: The asset for which to load image data.
    /// - Parameter options: Options specifying how Photos should handle the request, format the requested image, and notify your app of progress or errors.
    /// - Parameter completion: A block called, exactly once, when image loading is complete.
    @objc public func fetchImageData(
        fromAsset asset: PHAsset?,
        options: PHImageRequestOptions? = nil,
        completion: @escaping (Data?, String?, [AnyHashable : Any]?) -> Void)
    {
        guard let _asset = asset else {
            completion(nil, nil, nil)
            return
        }
        let imageManager = PHImageManager.default()
        #if os(iOS) || os(tvOS)
        if #available(iOS 13, tvOS 13, *) {
            imageManager.requestImageDataAndOrientation(for: _asset, options: options) { imageData, dataUTI, orientation, info in
                completion(imageData, dataUTI, info)
            }
        } else {
            imageManager.requestImageData(for: _asset, options: options) { imageData, dataUTI, orientation, info in
                completion(imageData, dataUTI, info)
            }
        }
        #else
        imageManager.requestImageDataAndOrientation(for: _asset, options: options) { imageData, dataUTI, orientation, info in
            completion(imageData, dataUTI, info)
        }
        #endif
    }
    
    /// Requests an image representation for the specified asset.
    ///
    /// - Parameters:
    ///   - asset: The asset whose image data is to be loaded.
    ///   - targetSize: The target size of image to be returned.
    ///   - contentMode: An option for how to fit the image to the aspect ratio of the requested size.
    ///   - options: Options specifying how Photos should handle the request, format the requested image, and notify your app of progress or errors.
    ///   - completion: A block to be called when image loading is complete, providing the requested image or information about the status of the request.
    @objc public func fetchImage(
        fromAsset asset: PHAsset?,
        targetSize: CGSize,
        contentMode: PHImageContentMode,
        options: PHImageRequestOptions? = nil,
        completion: @escaping (CXImage?, [AnyHashable : Any]?) -> Void)
    {
        guard let _asset = asset else {
            completion(nil, nil)
            return
        }
        PHImageManager.default().requestImage(for: _asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, info in
            completion(image, info)
        }
    }
    
    /// Fethes a Live Photo representation for the specified asset.
    ///
    /// - Parameters:
    ///   - asset: The asset whose Live Photo data is to be loaded.
    ///   - targetSize: The target size of Live Photo to be returned.
    ///   - contentMode: An option for how to fit the image to the aspect ratio of the requested size.
    ///   - options: Options specifying how Photos should handle the request, format the requested image, and notify your app of progress or errors.
    ///   - completion: A block to be called when image loading is complete, providing the requested image or information about the status of the request.
    @objc public func fetchLivePhoto(
        fromAsset asset: PHAsset?,
        targetSize: CGSize,
        contentMode: PHImageContentMode,
        options: PHLivePhotoRequestOptions? = nil,
        completion: @escaping (_ livePhoto: PHLivePhoto?) -> Void)
    {
        guard let _asset = asset else {
            completion(nil)
            return
        }
        PHImageManager.default().requestLivePhoto(for: _asset, targetSize: targetSize, contentMode: contentMode, options: options) { livePhoto, info in
            completion(livePhoto)
        }
    }
    
    /// Fethes AVFoundation objects representing the video asset’s content and state, to be loaded asynchronously.
    ///
    /// - Parameters:
    ///   - asset: The video asset for which video objects are to be loaded.
    ///   - options: Options specifying how Photos should handle the request and notify your app of progress or errors.
    ///   - completion: A block that Photos calls after loading the asset’s data.
    @objc public func fetchVideoAsset(
        fromAsset asset: PHAsset?,
        options: PHVideoRequestOptions? = nil,
        completion: @escaping (AVAsset?, AVAudioMix?, [AnyHashable : Any]?) -> Void)
    {
        guard let _asset = asset else {
            completion(nil, nil, nil)
            return
        }
        PHImageManager.default().requestAVAsset(forVideo: _asset, options: options) { avAsset, audioMix, info in
            completion(avAsset, audioMix, info)
        }
    }
    
    #if canImport(AVFoundation)
    /// Fethes a representation of the video asset for playback, to be loaded asynchronously.
    ///
    /// - Parameters:
    ///   - asset: The video asset to be played back.
    ///   - options: Options specifying how Photos should handle the request and notify your app of progress or errors.
    ///   - completion: A block Photos calls after loading the asset’s data and preparing the player item.
    @objc public func fetchVideoPlayerItem(
        fromAsset asset: PHAsset?,
        options: PHVideoRequestOptions? = nil,
        completion: @escaping (AVPlayerItem?, [AnyHashable : Any]?) -> Void)
    {
        guard let _asset = asset else {
            completion(nil, nil)
            return
        }
        PHImageManager.default().requestPlayerItem(forVideo: _asset, options: options) { playerItem, info in
            completion(playerItem, info)
        }
    }
    #endif
    
    /// Imports the current recorded video.
    func importRecordedVideo(replayFileName: String, completionHandler: @escaping (_ path: String, _ errorDescription: String?) -> Void) {
        #if canImport(Photos)
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        for i in 0..<smartAlbums.count {
            let assetCollection = smartAlbums[i]
            //if assetCollection.localizedTitle == "视频" || assetCollection.localizedTitle?.lowercased() == "videos" {
            if assetCollection.assetCollectionSubtype == .smartAlbumVideos {
                let assetsFetchResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: assetCollection, options: nil)
                guard assetsFetchResult.count > 0 else {
                    completionHandler("", "no video assets in the album!")
                    return
                }
                let phAsset: PHAsset = assetsFetchResult.lastObject!
                _ = PHVideoRequestOptions()
                
                let assetResources = PHAssetResource.assetResources(for: phAsset)
                var resource: PHAssetResource?
                
                for assetRes in assetResources {
                    resource = assetRes
                }
                if resource == nil {
                    completionHandler("", "Asset resource is nil")
                    return
                }
                let videoPath = NSTemporaryDirectory().appending(replayFileName)
                try? FileManager.default.removeItem(atPath: videoPath)
                PHAssetResourceManager.default().writeData(for: resource!, toFile: URL(localFilePath: videoPath), options: nil, completionHandler: { error in
                    if error != nil {
                        CXLogger.log(level: .error, message: "error=\(error!)")
                        completionHandler("", error!.localizedDescription)
                    } else {
                        completionHandler(videoPath, nil)
                    }
                })
            }
        }
        #else
        CXLogger.log(level: .error, message: "Can't import photos library... stop importing!")
        completionHandler?("", "Can't import photos library... stop importing!")
        #endif
    }
    
}

#endif
