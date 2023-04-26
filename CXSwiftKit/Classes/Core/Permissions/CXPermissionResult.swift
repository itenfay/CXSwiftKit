//
//  CXPermissionResult.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

#if canImport(Foundation)
import Foundation

/// The result for a permission status request.
public class CXPermissionResult: NSObject {
    @objc public let type: CXPermissionType
    @objc public let status: CXPermissionStatus
    
    @objc public init(type: CXPermissionType, status: CXPermissionStatus) {
        self.type   = type
        self.status = status
    }
    
    override public var description: String {
        return "\(type): \(status)"
    }
}

#endif
