//
//  CXPermissionStatus.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2023/3/16.
//

/// Possible statuses for a permission.
@objc public enum CXPermissionStatus: Int8, CustomStringConvertible {
    case authorized, unauthorized, unknown, disabled
    
    public var description: String {
        switch self {
        case .authorized:   return "Authorized"
        case .unauthorized: return "Unauthorized"
        case .unknown:      return "Unknown"
        case .disabled:     return "Disabled" // System-level
        }
    }
}
