//
//  CXAVExportConfig.swift
//  CXSwiftKit
//
//  Created by chenxing on 2021/9/26.
//

import AVFoundation

public class CXAVExportConfig: NSObject {
    
    /// Remove an item at specified path.
    @discardableResult
    public func removeItem(atPath path: String) -> Bool {
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
    public func cachesDirectory() -> String {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).map(\.path)[0]
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
