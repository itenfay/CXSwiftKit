//
//  CXPhotoLibraryHandler.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/8/12.
//

import Foundation
#if os(iOS) || os(tvOS) || os(macOS)
import Photos

public enum CXAssetCreationType: UInt8 {
    case image
    case imageByFileURL
    case videoByFileURL
    case audioByFileURL
}

public class CXPhotoLibraryHandler: NSObject {
    
    private lazy var photosPermission = CXPhotosPermission()
    
    @objc public override init() {
        super.init()
    }
    
    public enum PHLError: Error {
        case unauthorized(String)
        case failed(String)
        case noAssetCollection
    }
    
    public func addPhotoAsset(_ image: CXImage, title: String, completionHandler: @escaping (Bool, PHLError?) -> Void) throws {
        try addAsset(image, type: .image, title: title, completionHandler: completionHandler)
    }
    
    public func addPhotoAsset(_ fileURL: URL, title: String, completionHandler: @escaping (Bool, PHLError?) -> Void) throws {
        try addAsset(fileURL, type: .imageByFileURL, title: title, completionHandler: completionHandler)
    }
    
    public func addVideoAsset(_ fileURL: URL, title: String, completionHandler: @escaping (Bool, PHLError?) -> Void) throws {
        try addAsset(fileURL, type: .videoByFileURL, title: title, completionHandler: completionHandler)
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
    
    private func _addAsset(_ target: Any, type: CXAssetCreationType, title: String, completionHandler: @escaping (Bool, PHLError?) -> Void) {
        var albumPlaceholder: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            // Request creating an album with parameter name
            let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
            // Get a placeholder for the new album
            albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
            
            guard let placeholder = albumPlaceholder else {
                completionHandler(false, PHLError.failed("Album placeholder is nil"))
                return
            }
            
            let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
            guard let album: PHAssetCollection = fetchResult.firstObject else {
                // FetchResult has no PHAssetCollection
                completionHandler(false, PHLError.noAssetCollection)
                return
            }
            // Saved successfully!
            CXLogger.log(level: .info, message: "assetCollectionType=\(album.assetCollectionType)")
            
            // Request creating an asset from the image
            var createAssetRequest: PHAssetChangeRequest!
            if type == .image {
                if let image = target as? CXImage {
                    createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                } else {
                    completionHandler(false, PHLError.failed("The target type is wrong"))
                    return
                }
            } else {
                if let fileURL = target as? URL {
                    if type == .imageByFileURL {
                        createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileURL)
                    } else if type == .videoByFileURL {
                        createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
                    } else {
                        completionHandler(false, PHLError.failed("Unsupport type"))
                        return
                    }
                } else {
                    completionHandler(false, PHLError.failed("The target type is wrong"))
                    return
                }
            }
            
            // Request editing the album
            guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: album) else {
                // Album change request has failed
                completionHandler(false, PHLError.failed("Album change request has failed"))
                return
            }
            // Get a placeholder for the new asset and add it to the album editing request
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
                // Save album failed with error
                completionHandler(false, PHLError.failed(e.localizedDescription))
            }
            else {
                // Save album failed with no error
                completionHandler(false, PHLError.failed("Saving to album failed"))
            }
        })
    }
    
    public func addPhotoAsset(_ image: CXImage, completionHandler: @escaping (Bool, PHLError?) -> Void) {
        addAsset(image, type: .image, completionHandler: completionHandler)
    }
    
    public func addPhotoAsset(_ fileURL: URL, completionHandler: @escaping (Bool, PHLError?) -> Void) {
        addAsset(fileURL, type: .imageByFileURL, completionHandler: completionHandler)
    }
    
    public func addVideoAsset(_ fileURL: URL, completionHandler: @escaping (Bool, PHLError?) -> Void) {
        addAsset(fileURL, type: .videoByFileURL, completionHandler: completionHandler)
    }
    
    public func addAudioAsset(_ fileURL: URL, completionHandler: @escaping (Bool, PHLError?) -> Void) {
        addAsset(fileURL, type: .audioByFileURL, completionHandler: completionHandler)
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
                var request: PHAssetCreationRequest = PHAssetCreationRequest.forAsset()
                if type == .image {
                    if let image = target as? CXImage {
                        var imgData: Data?
                        #if os(macOS)
                        imgData = image.tiffRepresentation
                        #else
                        imgData = image.pngData()
                        #endif
                        if let data = imgData {
                            request.addResource(with: .photo, data: data, options: nil)
                        } else {
                            completionHandler(false, PHLError.failed("Image to data failed"))
                            return
                        }
                    } else {
                        completionHandler(false, PHLError.failed("The target type is wrong"))
                        return
                    }
                } else {
                    if let fileURL = target as? URL {
                        if type == .imageByFileURL {
                            request.addResource(with: .photo, fileURL: fileURL, options: nil)
                        } else if type == .videoByFileURL {
                            request.addResource(with: .video, fileURL: fileURL, options: nil)
                        } else if type == .audioByFileURL {
                            request.addResource(with: .audio, fileURL: fileURL, options: nil)
                        } else {
                            completionHandler(false, PHLError.failed("Unsupport type"))
                            return
                        }
                    } else {
                        completionHandler(false, PHLError.failed("The target type is wrong"))
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
                // Save album failed with error
                completionHandler(false, PHLError.failed(e.localizedDescription))
            }
            else {
                // Save album failed with no error
                completionHandler(false, PHLError.failed("Saving to album failed"))
            }
        })
    }
    
}

#endif
