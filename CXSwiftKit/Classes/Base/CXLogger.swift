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
    private static var currentDateString: String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        return dateFormatter.string(from: Date.init())
    }
    
    @nonobjc
    private static func log(_ level: CXLogLevel, message: String, file: String = #file, method: String = #function, lineNumber: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let mark = "[F: \(fileName) M: \(method) L: \(lineNumber)]"
        if CXLogConfig.enableLog {
            print("\(currentDateString) [CX] [\(level.description)] \(mark) \(message)")
        } else {
            if level == .error {
                print("\(currentDateString) [CX] [\(level.description)] \(mark) \(message)")
            }
        }
    }
    
    /// Outputs the log to the console.
    public static func log(level: CXLogLevel, message: String) {
        log(level, message: message)
    }
    
    /// Outputs the log to the console.
    public static func log(_ obj: Any, level: CXLogLevel, message: String) {
        log(level, message: "\(type(of: obj)) \(message)")
    }
    
}
