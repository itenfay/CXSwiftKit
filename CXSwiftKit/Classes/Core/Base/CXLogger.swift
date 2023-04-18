//
//  CXLogger.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/10.
//

#if canImport(Foundation)
import Foundation

/// The level of the log.
@objc public enum CXLogLevel: UInt8 {
    case debug, info, verbose, warning, error
    
    var description: String {
        switch self {
        case .debug: return "Debug"
        case .info: return "Info"
        case .verbose: return "Verbose"
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
    private static func log(_ level: CXLogLevel, message: String, posi: (file: String, function: String, lineNumber: Int)? = nil) {
        var desc = ""
        if let t = posi {
            let fileName = (t.file as NSString).lastPathComponent
            desc = "[F: \(fileName) M: \(t.function) L: \(t.lineNumber)]"
        }
        desc = (desc.isEmpty ? "" : desc + " ") + message
        if CXLogConfig.enableLog {
            print("\(currentDateString) [CX] [\(level.description)] \(desc)")
        } else {
            if level == .debug {
                print("\(currentDateString) [CX] [\(level.description)] \(desc)")
            }
        }
    }
    
    /// Outputs logs to the console (Swift).
    @nonobjc
    public static func log(level: CXLogLevel, message: String, file: String = #file, function: String = #function, lineNumber: Int = #line) {
        log(level, message: message, posi: (file, function, lineNumber))
    }
    
    /// Outputs logs to the console (Swift).
    @nonobjc
    public static func log(_ obj: Any, level: CXLogLevel, message: String, file: String = #file, function: String = #function, lineNumber: Int = #line) {
        log(level, message: "[\(type(of: obj))] \(message)", posi: (file, function, lineNumber))
    }
    
    /// Outputs logs to the console (Objective-C).
    /// e.g.:
    ///   [CXLogger outputLogWithLevel:CXLogLevelError message:CXLogMessageFormat(@"123")];
    public static func outputLog(level: CXLogLevel, message: String) {
        log(level, message: message, posi: nil)
    }
    
    /// Outputs logs to the console (Objective-C).
    /// e.g.:
    ///   #define CXLogMessageFormat(m) ([NSString stringWithFormat:@"[F: %s, M: %s, L: %d] %@",  __FILE__, __PRETTY_FUNCTION__, __LINE__, (m)])
    ///   [CXLogger outputLog:self level:CXLogLevelError message:CXLogMessageFormat(@"===")];
    public static func outputLog(_ obj: Any, level: CXLogLevel, message: String) {
        log(level, message: "[\(type(of: obj))] \(message)", posi: nil)
    }
    
}

#endif
