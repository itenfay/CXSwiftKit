//
//  CXAVGlobal.swift
//  CXSwiftKit
//
//  Created by chenxing on 2021/9/26.
//

import Foundation

/// Remove an item at specified path.
@discardableResult
public func cxAVRemoveItem(atPath path: String) -> Bool {
    if FileManager.default.fileExists(atPath: path) {
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch let error {
            CXLogger.log(level: .error, message: "error=\(error)")
        }
    }
    return false
}

/// A new string made by deleting the extension (if any, and only the last) from the receiver.
public func cxAVGetFileName(withURL url: URL) -> String {
    return CXFileToolbox.fileName(withURL: url)
}

/// Export the file url with the directory and file name.
public func cxAVExportedFileURL(with dirName: String, fileName: String) -> (Bool, URL) {
    let (success, directory) = cxAVMakeDirectory(with: dirName)
    let fileURL = URL(localFilePath: directory).cx.appendingPathComponent(fileName)
    CXLogger.log(level: .info, message: "fileURL=\(fileURL)")
    if success {
        cxAVRemoveItem(atPath: fileURL.cx_path)
        return (true, fileURL)
    }
    return (false, fileURL)
}

/// The caches directory(Library/Caches).
public func cxAVGetCachesDirectory() -> String {
    return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).map(\.path)[0]
}

/// Make the path of a directory with the specified name in caches directory.
public func cxAVMakeDirectoryPath(with name: String) -> String? {
    let t = cxAVMakeDirectory(with: name)
    return t.0 ? t.1 : nil
}

/// Make a directory with the specified name in caches directory.
public func cxAVMakeDirectory(with name: String) -> (Bool, String) {
    let dirPath = URL(localFilePath: cxAVGetCachesDirectory()).cx_appendingPathComponent(name).cx.path
    CXLogger.log(level: .info, message: "dirPath=\(dirPath)")
    do {
        try FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
        return (true, dirPath)
    } catch let error {
        CXLogger.log(level: .error, message: "error=\(error)")
    }
    return (false, dirPath)
}
