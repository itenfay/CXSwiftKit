//
//  CXLineReader.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2023/3/16.
//

import Foundation

/// Read text file line by line in efficient way.
public class CXLineReader: NSObject {
    @objc public let path: String
    
    fileprivate let file: UnsafeMutablePointer<FILE>!
    
    @objc public init?(path: String) {
        self.path = path
        file = fopen(path, "r")
        guard file != nil else { return nil }
    }
    
    @objc public var nextLine: String? {
        var line: UnsafeMutablePointer<CChar>? = nil
        var linecap: Int = 0
        defer { free(line) }
        return getline(&line, &linecap, file) > 0 ? String(cString: line!) : nil
    }
    
    deinit {
        fclose(file)
    }
}

extension CXLineReader: Sequence {
    
    public func makeIterator() -> AnyIterator<String> {
        return AnyIterator<String> {
            return self.nextLine
        }
    }
    
}
