//
//  CXPermission.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2023/3/16.
//

@objc public protocol CXPermission {
    var type: CXPermissionType { get }
    var authorized: Bool { get }
    var status: CXPermissionStatus { get }
    func requestAccess(completion: @escaping (CXPermissionResult) -> Void)
}
