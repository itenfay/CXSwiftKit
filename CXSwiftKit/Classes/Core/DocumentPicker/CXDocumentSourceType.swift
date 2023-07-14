//
//  CXDocumentSourceType.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/5/9.
//

@objc public enum CXDocumentSourceType: UInt8, CustomStringConvertible {
    case file
    case folder
    
    public var description: String {
        switch self {
        case .file: return "File"
        case .folder: return "Folder"
        }
    }
}
