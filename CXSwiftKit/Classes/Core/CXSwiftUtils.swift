//
//  CXSwiftUtils.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

import UIKit

public class CXSwiftUtils: NSObject {
    
    /// Convert the seconds to a string which contains the format(0d0h0m0s).
    ///
    /// - Parameters:
    ///   - seconds: The seconds you want to convert.
    ///   - sinicized: Whether to convert an English string into Chinese.
    /// - Returns: A string which contains the format(0d0h0m0s).
    @objc public static func timeString(withSeconds seconds: Int, sinicized: Bool) -> String
    {
        return seconds.cx.secondsAsTimeString(sinicized: sinicized)
    }
    
    /// Get the length of a string, which can contain emoji.
    ///
    /// - Parameter string: The string you want to get the length.
    /// - Returns: The length of a string, which can contain emoji.
    @objc public static func lengthOf(_ string: String) -> Int
    {
        return string.cx.length
    }
    
}
