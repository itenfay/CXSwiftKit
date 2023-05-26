//
//  CXFileToolbox.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

import Foundation

public class CXFileToolbox: NSObject {
    
    /// The path extension of the URL, or an empty string if the path is an empty string.
    @objc public class func pathExtension(withURL url: URL) -> String {
        return url.pathExtension
    }
    
    /// A new string made by deleting the extension (if any, and only the last) from the receiver.
    @objc public class func fileName(withURL url: URL) -> String {
        return url.deletingPathExtension().lastPathComponent
    }
    
    /// The last path component of the URL, or an empty string if the path is an empty string.
    @objc public class func lastPathComponent(withURL url: URL) -> String {
        return url.lastPathComponent
    }
    
    /// Returns a Boolean value that indicates whether a file or directory exists at a specified path.
    @objc public class func fileExists(atPath path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    /// Returns the path to either the user’s or application’s home directory, depending on the platform.
    @objc public class var homeDirectory: String {
        return NSHomeDirectory()
    }
    
    /// Returns the path of the temporary directory for the current user.
    @objc public class var tempDirectory: String {
        return NSTemporaryDirectory()
    }
    
    /// Returns the path of the document directory for the current user.
    @objc public class var documentDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    /// Creates a directory at the specified path.
    @objc public class func createDirectory(atPath path: String) -> Bool {
        do {
            var isDir: ObjCBool = false
            let isDirExist = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
            if isDirExist && isDir.boolValue {}
            else {
                try FileManager.default.createDirectory(at: URL(localFilePath: path), withIntermediateDirectories: true)
            }
            return true
        } catch {
            CXLogger.log(level: .error, message: "error=\(error)")
            return false
        }
    }
    
    /// Creates a cache directory with the given path component and returns the specified URL.
    @objc public class func cacheURL(byAppendingPathComponent pathComponent: String = "") -> URL? {
        do {
            let cacheURL = try FileManager.default.url(for: .cachesDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: false)
            if pathComponent.isEmpty {
                return cacheURL
            }
            let dstURL = cacheURL.cx_appendingPathComponent(pathComponent)
            var isDir: ObjCBool = false
            let isDirExist = FileManager.default.fileExists(atPath: dstURL.cx_path, isDirectory: &isDir)
            if isDirExist && isDir.boolValue {}
            else {
                try FileManager.default.createDirectory(at: dstURL, withIntermediateDirectories: true)
            }
            return dstURL
        } catch {
            CXLogger.log(level: .error, message: "error=\(error)")
            return nil
        }
    }
    
    /// Returns a destination file path by the url, custom file name and directory.
    @objc public class func filePath(withURL url: URL) -> String {
        return filePath(withURL: url, atDirectory: "")
    }
    
    /// Returns a destination file path by the url, custom file name and directory.
    @objc public class func filePath(withURL url: URL, atDirectory directory: String) -> String {
        return filePath(withURL: url, usingCustomFileName: nil, atDirectory: directory)
    }
    
    /// Returns a destination file path by the url, custom file name and directory.
    @objc public class func filePath(withURL url: URL, usingCustomFileName: String?, atDirectory directory: String?) -> String {
        var rootURL: URL?
        if let dir = directory, !dir.isEmpty {
            rootURL = cacheURL(byAppendingPathComponent: dir)
        } else {
            rootURL = cacheURL()
        }
        var filePathURL: URL?
        if let name = usingCustomFileName, !name.isEmpty {
            filePathURL = rootURL?.cx_appendingPathComponent(name)
        } else {
            let fileName = fileName(withURL: url)
            let fileExt  = pathExtension(withURL: url)
            let file = (fileName.cx.md5 ?? fileName) + "." + fileExt
            filePathURL = rootURL?.cx_appendingPathComponent(file)
        }
        return filePathURL?.cx_path ?? ""
    }
    
    /// The file’s size in bytes at the specified path.
    @objc public class func fileSize(atPath path: String) -> Int64 {
        var fileSizeBytes: Int64 = 0
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            return fileSizeBytes
        }
        do {
            let attributes = try fileManager.attributesOfItem(atPath: path)
            fileSizeBytes = attributes[.size] as? Int64 ?? 0
        } catch let error {
            CXLogger.log(level: .error, message: "error=\(error)")
        }
        return fileSizeBytes
    }
    
    /// Moves the file or directory at the specified path to a new location synchronously.
    @objc public class func moveFile(atPath srcPath: String, toPath dstPath: String) {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: srcPath) { return }
        do {
            try fileManager.moveItem(atPath: srcPath, toPath: dstPath)
        } catch {
            CXLogger.log(level: .error, message: "error=\(error)")
        }
    }
    
    /// Copies the file or directory at the specified path to a new location synchronously.
    @objc public class func copyFile(atPath srcPath: String, toPath dstPath: String) {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: srcPath) { return }
        do {
            try fileManager.copyItem(atPath: srcPath, toPath: dstPath)
        } catch {
            CXLogger.log(level: .error, message: "error=\(error)")
        }
    }
    
    /// Removes the file or directory at the specified path.
    @objc public class func removeFile(atPath path: String) {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) { return }
        do {
            try fileManager.removeItem(atPath: path)
        } catch {
            CXLogger.log(level: .error, message: "error=\(error)")
        }
    }
    
    /// Writes the specified data synchronously to specified path.
    @objc public class func write(data: Data, toPath path: String) {
        do {
            let fileHandle = try FileHandle(forUpdating: URL(localFilePath: path))
            if #available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *) {
                try fileHandle.seekToEnd()
                try fileHandle.write(contentsOf: data)
                // macos(10.15), ios(13.0), watchos(6.0), tvos(13.0)
                try fileHandle.close()
            } else {
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            }
        } catch let error {
            CXLogger.log(level: .error, message: "error=\(error)")
        }
    }
    
    /// Writes the specified data synchronously to specified path.
    @objc public class func write(array: NSArray, toPath path: String) {
        if #available(macOS 10.13, iOS 11.0, watchOS 4.0, tvOS 11.0, *) {
            do {
                try array.write(to: URL(localFilePath: path))
            } catch {
                CXLogger.log(level: .error, message: "error=\(error)")
            }
        } else {
            let ret = array.write(toFile: path, atomically: true)
            if !ret {
                CXLogger.log(level: .error, message: "The file isnot written successfully")
            }
        }
    }
    
    /// Writes the specified data synchronously to specified path.
    @objc public class func write(dictionary: NSDictionary, toPath path: String) {
        if #available(macOS 10.13, iOS 11.0, watchOS 4.0, tvOS 11.0, *) {
            do {
                try dictionary.write(to: URL(localFilePath: path))
            } catch {
                CXLogger.log(level: .error, message: "error=\(error)")
            }
        } else {
            let ret = dictionary.write(toFile: path, atomically: true)
            if !ret {
                CXLogger.log(level: .error, message: "The file isnot written successfully")
            }
        }
    }
    
}
