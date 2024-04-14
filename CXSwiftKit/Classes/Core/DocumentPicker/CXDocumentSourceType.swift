//
//  CXDocumentSourceType.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2022/5/9.
//

@objc public enum CXDocumentSourceType: UInt8, CustomStringConvertible {
    case none
    case file
    case folder
    
    public var description: String {
        switch self {
        case .none: return "None"
        case .file: return "File"
        case .folder: return "Folder"
        }
    }
}
