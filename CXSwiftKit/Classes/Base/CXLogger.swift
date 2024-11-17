//
//  CXLogger.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2022/11/10.
//

import Foundation

/// The level of the log.
@objc public enum CXLogLevel: UInt8, CustomStringConvertible {
    case debug, info, warning, error
    
    public var description: String {
        switch self {
        case .debug: return "Debug"
        case .info: return "Info"
        case .warning: return "Warning"
        case .error: return "Error"
        }
    }
}

@objcMembers public class CXLogger: NSObject {
    
    public static var currentDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    public static var currentZDateString: String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        return dateFormatter.string(from: Date.init())
    }
    
    @nonobjc
    private static func log(_ level: CXLogLevel, prefix: String, message: String) {
        let _prefix = prefix.isEmpty ? " " : (" " + prefix + " ")
        if CXConfig.enableLog {
            print("\(currentZDateString)\(_prefix)[CX] [\(level.description)] \(message)")
        } else {
            if level == .error {
                print("\(currentZDateString)\(_prefix)[CX] [\(level.description)] \(message)")
            }
        }
    }
    
    /// Outputs the logs to the console(Swift).
    @nonobjc
    public static func log(level: CXLogLevel, message: String, file: String = #file, function: String = #function, lineNumber: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let prefix = "[F: \(fileName) M: \(function) L: \(lineNumber)]"
        log(level, prefix: prefix, message: message)
    }
    
    /// Outputs the logs to the console(Swift).
    @nonobjc
    public static func log(_ obj: Any, level: CXLogLevel, message: String, file: String = #file, function: String = #function, lineNumber: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let prefix = "[F: \(fileName) M: \(function) L: \(lineNumber)]"
        log(level, prefix: "\(prefix) [\(type(of: obj))]", message: message)
    }
    
    /// Outputs the logs to the console(Objective-C).
    ///
    /// e.g.:
    ///   [CXLogger outputLogWithLevel:CXLogLevelError message:CXLogMessage(@"123")];
    public static func outputLog(level: CXLogLevel, message: String) {
        log(level, prefix: "", message: message)
    }
    
    /// Outputs the logs to the console(Objective-C).
    ///
    /// e.g.:
    ///   #define CXLogMessage(m) ([NSString stringWithFormat:@"[F: %s, M: %s, L: %d] %@",  __FILE__, __PRETTY_FUNCTION__, __LINE__, (m)])
    ///   [CXLogger outputLog:self level:CXLogLevelError message:CXLogMessageFormat(@"===")];
    public static func outputLog(_ obj: Any, level: CXLogLevel, message: String) {
        log(level, prefix: "[\(type(of: obj))]", message: message)
    }
    
}

public struct CXLog {
    
    /// Outputs the logs of `Debug` level to the console.
    public static func debug(_ message: String, file: String = #file, function: String = #function, lineNumber: Int = #line) {
        CXLogger.log(level: .debug, message: message, file: file, function: function, lineNumber: lineNumber)
    }
    
    /// Outputs the logs of `Info` level to the console.
    public static func info(_ message: String, file: String = #file, function: String = #function, lineNumber: Int = #line) {
        CXLogger.log(level: .info, message: message, file: file, function: function, lineNumber: lineNumber)
    }
    
    /// Outputs the logs of `Warning` level to the console.
    public static func warn(_ message: String, file: String = #file, function: String = #function, lineNumber: Int = #line) {
        CXLogger.log(level: .warning, message: message, file: file, function: function, lineNumber: lineNumber)
    }
    
    /// Outputs the logs of `Error` level to the console.
    public static func error(_ message: String, file: String = #file, function: String = #function, lineNumber: Int = #line) {
        CXLogger.log(level: .error, message: message, file: file, function: function, lineNumber: lineNumber)
    }
    
}
