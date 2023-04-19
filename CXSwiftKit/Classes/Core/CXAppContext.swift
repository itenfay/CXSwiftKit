//
//  CXAppContext.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if canImport(Foundation)
import Foundation

public class CXAppContext: NSObject {
    
    /// Check resign of the app by the team identifier. false indicates that nobody re-signs this app, otherwise true.
    @objc public static func checkResign(_ teamIdentifier: String) -> Bool {
        let path = CXConfig.embeddedProvisionPath
        guard !path.isEmpty else {
            return false
        }
        if let reader = CXLineReader(path: path) {
            while let line = reader.nextLine {
                if line.contains("<key>com.apple.developer.team-identifier</key>") {
                    let nextLine = reader.nextLine ?? ""
                    if nextLine.contains("<string>\(teamIdentifier)</string>") {
                        return false
                    }
                    break
                }
            }
        }
        return true
    }
    
}

#endif
