//
//  CXLogger.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/10.
//

import Foundation

/// The level of the log.
@objc public enum CXLogLevel: Int {
    case info, warning, error
    
    var description: String {
        switch self {
        case .info: return "Info"
        case .warning: return "Warning"
        case .error: return "Error"
        }
    }
}

/// The config for the log.
@objcMembers public class CXLogConfig: NSObject {
    /// Whether to enable log, the default is true.
    public static var enableLog: Bool = true
}

@objcMembers public class CXLogger: NSObject {
    
    @nonobjc
    private static var currentDateFormatString: String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        return dateFormatter.string(from: Date.init())
    }
    
    @nonobjc
    private static func log(_ level: CXLogLevel, message: String, posi: (file: String, function: String, lineNumber: Int)? = nil) {
        var logDesc = ""
        if let _posi = posi {
            let fileName = (_posi.file as NSString).lastPathComponent
            logDesc = "[F: \(fileName) M: \(_posi.function) L: \(_posi.lineNumber)]"
        }
        logDesc = (logDesc.isEmpty ? "" : logDesc + " ") + message
        if CXLogConfig.enableLog {
            print("\(currentDateFormatString) [CX] [\(level.description)] \(logDesc)")
        } else {
            if level == .error {
                print("\(currentDateFormatString) [CX] [\(level.description)] \(logDesc)")
            }
        }
    }
    
    /// Outputs logs to the console(Swift).
    @nonobjc
    public static func log(level: CXLogLevel, message: String, file: String = #file, function: String = #function, lineNumber: Int = #line) {
        log(level, message: message, posi: (file, function, lineNumber))
    }
    
    /// Outputs logs to the console(Swift).
    @nonobjc
    public static func log(_ obj: Any, level: CXLogLevel, message: String, file: String = #file, function: String = #function, lineNumber: Int = #line) {
        log(level, message: "\(type(of: obj)) \(message)", posi: (file, function, lineNumber))
    }
    
    /// Outputs logs to the console(Objective-C).
    public static func outputLog(level: CXLogLevel, message: String) {
        log(level, message: message, posi: nil)
    }
    
    /// Outputs logs to the console(Objective-C).
    public static func outputLog(_ obj: Any, level: CXLogLevel, message: String) {
        log(level, message: "\(type(of: obj)) \(message)", posi: nil)
    }
    
}
