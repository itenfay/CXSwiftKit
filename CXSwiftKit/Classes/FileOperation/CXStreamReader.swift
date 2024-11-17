//
//  CXStreamReader.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2023/3/16.
//

import Foundation

public class CXStreamReader: NSObject {
    
    private let encoding: String.Encoding
    private let blockSize: Int
    private var fileHandle: FileHandle!
    private let delimData: Data
    private var buffer: Data
    @objc public private(set) var atEof: Bool
    
    @objc public convenience init?(path: String) {
        self.init(path: path, blockSize: 4096)
    }
    
    @objc public convenience init?(path: String, blockSize: Int) {
        self.init(path: path, delimiter: "\n", blockSize: blockSize)
    }
    
    @objc public convenience init?(path: String, delimiter: String, blockSize: Int) {
        self.init(path: path, delimiter: delimiter, encoding: .utf8, blockSize: blockSize)
    }
    
    public init?(path: String, delimiter: String, encoding: String.Encoding, blockSize: Int) {
        guard let fileHandle = FileHandle(forReadingAtPath: path),
              let delimData = delimiter.data(using: .utf8) else {
            return nil
        }
        self.encoding = encoding
        self.blockSize = blockSize
        self.fileHandle = fileHandle
        self.delimData = delimData
        self.buffer = Data(capacity: blockSize)
        self.atEof = false
    }
    
    deinit {
        close()
    }
    
    /// Return next line, or nil on EOF.
    @objc public func nextLine() -> String? {
        precondition(fileHandle != nil, "Attempt to read from closed file")
        
        // Read data chunks from file until a line delimiter is found:
        while !atEof {
            if let range = buffer.range(of: delimData) {
                // Convert complete line (excluding the delimiter) to a string:
                let line = String(data: buffer.subdata(in: 0..<range.lowerBound), encoding: encoding)
                // Remove line (and the delimiter) from the buffer:
                buffer.removeSubrange(0..<range.upperBound)
                return line
            }
            var tmpData = Data()
            if #available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *) {
                do {
                    tmpData = try fileHandle.read(upToCount: blockSize) ?? Data()
                } catch let error {
                    CXLogger.log(level: .error, message: "error=\(error)")
                }
            } else {
                tmpData = fileHandle.readData(ofLength: blockSize)
            }
            if tmpData.count > 0 {
                buffer.append(tmpData)
            } else {
                // EOF or read error.
                atEof = true
                if buffer.count > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = String(data: buffer as Data, encoding: encoding)
                    buffer.count = 0
                    return line
                }
            }
        }
        
        return nil
    }
    
    /// Start reading from the beginning of file.
    @objc public func rewind() {
        if #available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *) {
            do {
                try fileHandle.seek(toOffset: 0)
            } catch let error {
                CXLogger.log(level: .error, message: "error=\(error)")
            }
        } else {
            fileHandle.seek(toFileOffset: 0)
        }
        
        buffer.count = 0
        atEof = false
    }
    
    /// Close the underlying file. No reading must be done after calling this method.
    @objc public func close() {
        if #available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *) {
            do {
                try fileHandle.close()
            } catch {
                CXLogger.log(level: .error, message: "error=\(error)")
            }
        } else {
            fileHandle.closeFile()
        }
        fileHandle = nil
    }
    
}

extension CXStreamReader: Sequence {
    
    public func makeIterator() -> AnyIterator<String> {
        return AnyIterator {
            return self.nextLine()
        }
    }
    
}
