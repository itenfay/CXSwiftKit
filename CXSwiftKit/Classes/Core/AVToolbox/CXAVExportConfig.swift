//
//  CXAVExportConfig.swift
//  CXSwiftKit
//
//  Created by chenxing on 2021/9/26.
//

#if canImport(Foundation)
import Foundation

public class CXAVExportConfig: NSObject {
    
    /// Remove an item at specified path.
    @discardableResult
    @objc public func removeItem(atPath path: String) -> Bool {
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
    @objc public func fileName(withURL url: URL) -> String {
        return url.deletingPathExtension().lastPathComponent
    }
    
    /// Export the file url with the directory and file name.
    @objc public func exportFileURL(withDirName dirName: String, fileName: String) -> URL? {
        let t = exportFileURL(with: dirName, fileName: fileName)
        return t.0 ? t.1 : nil
    }
    
    /// Export the file url with the directory and file name.
    public func exportFileURL(with dirName: String, fileName: String) -> (Bool, URL) {
        let (success, directory) = makeDirectory(with: dirName)
        let fileURL = URL(fileURLWithPath: directory).appendingPathComponent(fileName)
        CXLogger.log(level: .info, message: "fileURL=\(fileURL)")
        if success {
            removeItem(atPath: fileURL.cx_path)
            return (true, fileURL)
        }
        return (false, fileURL)
    }
    
    /// The caches directory(Library/Caches).
    @objc public func cachesDirectory() -> String {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).map(\.path)[0]
    }
    
    /// Make a directory with the specified name in caches directory.
    @objc public func makeDirectory(withName name: String) -> String? {
        let t = makeDirectory(with: name)
        return t.0 ? t.1 : nil
    }
    
    /// Make a directory with the specified name in caches directory.
    public func makeDirectory(with name: String) -> (Bool, String) {
        let dirPath = URL(fileURLWithPath: cachesDirectory()).appendingPathComponent(name).path
        CXLogger.log(level: .info, message: "dirPath=\(dirPath)")
        do {
            try FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
            return (true, dirPath)
        } catch let error {
            CXLogger.log(level: .error, message: "error=\(error)")
        }
        return (false, dirPath)
    }
    
}

#endif
