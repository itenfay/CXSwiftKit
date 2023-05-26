//
//  CXLogger.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/10.
//

import Foundation

/// The level of the log.
@objc public enum CXLogLevel: UInt8, CustomStringConvertible {
    case debug, verbose, info, warning, error
    
    public var description: String {
        switch self {
        case .debug: return "Debug"
        case .verbose: return "Verbose"
        case .info: return "Info"
        case .warning: return "Warning"
        case .error: return "Error"
        }
    }
}

@objcMembers public class CXLogger: NSObject {
    
    @nonobjc
    private static var currentDateString: String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        return dateFormatter.string(from: Date.init())
    }
    
    @nonobjc
    private static func log(_ level: CXLogLevel, message: String, locationInfo: (file: String, function: String, lineNumber: Int)? = nil) {
        var desc = ""
        if let li = locationInfo {
            let fileName = (li.file as NSString).lastPathComponent
            desc = "[F: \(fileName) M: \(li.function) L: \(li.lineNumber)]"
        }
        desc = (desc.isEmpty ? "" : desc + " ") + message
        if CXConfig.enableLog {
            print("\(currentDateString) [\(level.description)] [CX] \(desc)")
        } else {
            if level == .debug || level == .verbose {
                print("\(currentDateString) [\(level.description)] [CX] \(desc)")
            }
        }
    }
    
    /// Outputs logs to the console (Swift).
    @nonobjc
    public static func log(level: CXLogLevel, message: String, file: String = #file, function: String = #function, lineNumber: Int = #line) {
        log(level, message: message, locationInfo: (file, function, lineNumber))
    }
    
    /// Outputs logs to the console (Swift).
    @nonobjc
    public static func log(_ obj: Any, level: CXLogLevel, message: String, file: String = #file, function: String = #function, lineNumber: Int = #line) {
        log(level, message: "[\(type(of: obj))] \(message)", locationInfo: (file, function, lineNumber))
    }
    
    /// Outputs logs to the console (Objective-C).
    /// e.g.:
    ///   [CXLogger outputLogWithLevel:CXLogLevelError message:CXLogMessageFormat(@"123")];
    public static func outputLog(level: CXLogLevel, message: String) {
        log(level, message: message, locationInfo: nil)
    }
    
    /// Outputs logs to the console (Objective-C).
    /// e.g.:
    ///   #define CXLogMessageFormat(m) ([NSString stringWithFormat:@"[F: %s, M: %s, L: %d] %@",  __FILE__, __PRETTY_FUNCTION__, __LINE__, (m)])
    ///   [CXLogger outputLog:self level:CXLogLevelError message:CXLogMessageFormat(@"===")];
    public static func outputLog(_ obj: Any, level: CXLogLevel, message: String) {
        log(level, message: "[\(type(of: obj))] \(message)", locationInfo: nil)
    }
    
}
