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

public class CXConfig: NSObject {
    
    /// This is private because the use of 'appConfiguration' is preferred.
    private static var isTestFlight: Bool { Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" }
    @objc public static var embeddedProvisionPath: String { Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") ?? "" }
    
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
        } else if !embeddedProvisionPath.isEmpty {
            if let reader = CXLineReader(path: embeddedProvisionPath) {
                while let line = reader.nextLine {
                    if line.contains("<key>Name</key>") {
                        // <string>xxx Ad Hoc Provisioning Profile: com.xxx.xxx</string>
                        // <string>com.xxx.xxx InHouse</string>
                        let nextLine = reader.nextLine?.lowercased() ?? ""
                        if nextLine.contains("ad hoc") ||
                            nextLine.contains("adhoc") {
                            return .adHoc
                        } else if nextLine.contains("inhouse") {
                            return .inHouse
                        }
                    }
                    if line.contains("<key>ProvisionsAllDevices</key>") {
                        return .inHouse
                    } else if line.contains("<key>ProvisionedDevices</key>") {
                        return .adHoc
                    }
                }
            }
            return .adHoc
        } else {
            return .appStore
        }
    }
    
}

/// The config for the log.
@objcMembers public class CXLogConfig: NSObject {
    /// Whether to enable log, default is false.
    public static var enableLog: Bool = false
}

#endif
