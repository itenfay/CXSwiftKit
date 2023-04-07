//
//  CXConfig.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if canImport(Foundation)
import Foundation

@objc public enum AppConfiguration: UInt8 {
    case debug
    case testFlight
    case enterprise
    case appStore
}

public class CXConfig: NSObject {
    
    /// This is private because the use of 'appConfiguration' is preferred.
    private static var isTestFlight: Bool { Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" }
    private static var hasEmbeddedProvision: Bool { Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil }
    
    /// This can be used to add debug statements.
    @objc public static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    @objc public static var appConfiguration: AppConfiguration {
        if isDebug {
            return .debug
        } else if isTestFlight {
            return .testFlight
        } else if hasEmbeddedProvision {
            return .enterprise
        } else {
            return .appStore
        }
    }
    
}

/// The config for the log.
@objcMembers public class CXLogConfig: NSObject {
    /// Whether to enable log, the default is false.
    public static var enableLog: Bool = false
}

#endif
