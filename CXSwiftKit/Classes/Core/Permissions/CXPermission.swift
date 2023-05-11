//
//  CXPermission.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

@objc public protocol CXPermission {
    @objc var type: CXPermissionType { get }
    @objc var authorized: Bool { get }
    @objc var status: CXPermissionStatus { get }
    @objc func requestAccess(completion: @escaping (CXPermissionResult) -> Void)
}
