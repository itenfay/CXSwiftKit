//
//  CXConfig.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if canImport(Foundation)
import Foundation

@objc public enum AppConfiguration: UInt8, CustomStringConvertible {
    case debug
    case adHoc
    case inHouse
    case testFlight
    case appStore
    
    public var description: String {
        switch self {
        case .debug: return "Debug"
        case .adHoc: return "AdHoc"
        case .inHouse: return "InHouse" //Enterprise
        case .testFlight: return "TestFlight"
        case .appStore: return "AppStore"
        }
    }
}

/// The config for this kit.
public class CXConfig: NSObject {
    /// Whether to enable log, default is false.
    @objc public static var enableLog: Bool = false
}

#endif
