//
//  String+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

import Foundation
import CommonCrypto

extension String: CXSwiftBaseCompatible {}

extension CXSwiftBase where T == String {
    
    /// Get the length of a string, which can contain emoji.
    public var length: Int {
        return self.base.utf16.count
    }
    
    /// String to integer number.
    public var intValue: Int? {
        return Int(self.base)
    }
    
    /// String to double number.
    public var doubleValue: Double? {
        return Double(self.base)
    }
    
    /// Get a MD5 encoded string.
    public var md5: String? {
        let cStr = self.base.cString(using: String.Encoding.utf8)
        if cStr != nil {
            let digestLen = Int(CC_MD5_DIGEST_LENGTH)
            let strLen = (CC_LONG)(self.base.lengthOfBytes(using: String.Encoding.utf8))
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLen)
            
            CC_MD5(cStr!, strLen, buffer) // (CC_LONG)(strlen(cStr!))
            
            let result = NSMutableString()
            for i in 0..<digestLen {
                result.appendFormat("%02x", buffer[i])
            }
            free(buffer)
            return result as String
        }
        return nil
    }
    
    /// Convert a date string to a timestamp，dateFormat: "yyyy-MM-dd HH:mm:ss".
    /// - Parameter dateFormat: <#dateFormat description#>
    /// - Returns: <#description#>
    public func asTimestamp(with dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Double? {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: self.base)
        return date?.timeIntervalSince1970
    }
    
    /// Convert a timestamp to a date string，dateFormat: "yyyy-MM-dd HH:mm:ss".
    public func timestampAsDateString(with dateFormat: String = "yyyy-MM-dd HH:mm:ss" ) -> String {
        let ts = NSString.init(string: self.base)
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = dateFormat
        let date = Date.init(timeIntervalSince1970: ts.doubleValue)
        return dateFormatter.string(from: date)
    }
    
    // 时间格式转换为Date类型 (传入的字符串要与下方的格式一致！！！)
    public func timeToDate(with dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        guard let date = dateFormatter.date(from: self.base) else {
            return nil
        }
        return date
    }
    
    /// 将 Base64 编码中的"-"，"_"字符串转换成"+"，"/"，字符串长度余4倍的位补"="
    public func safeUrlBase64Decode() -> Data? {
        // '-' -> '+'
        // '_' -> '/'
        // 不足4倍长度，补'='
        var base64Str = "" + self.base
        base64Str = base64Str.replacingOccurrences(of: "-", with: "+")
        base64Str = base64Str.replacingOccurrences(of: "_", with: "/")
        let mod4 = base64Str.count % 4
        if mod4 > 0 {
            let padding = String.init(repeating: "=", count: 4 - mod4)
            base64Str.append(padding)
        }
        return Data.init(base64Encoded: base64Str)
    }
    
    /// Base64 decoding.
    public func base64Decode() -> Data? {
        return Data.init(base64Encoded: self.base)
    }
    
    /// Encodes an url.
    public func urlEncode() -> String {
        let encodeUrlString = self.base.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
        return encodeUrlString ?? self.base
    }
    
    /// Encodes an url bestly.
    public func urlEncode2() -> String {
        var allowedCharacters = NSCharacterSet.urlQueryAllowed
        //does not include "?" or "/" due to RFC 3986 - Section 3.4
        allowedCharacters.remove(charactersIn: ":#[]@!$&'()*+,;=")
        let encodeUrlString = self.base.addingPercentEncoding(
            withAllowedCharacters: allowedCharacters
        )
        return encodeUrlString ?? self.base
    }
    
    /// Decodes an url.
    public func urlDecode() -> String {
        return self.base.removingPercentEncoding ?? self.base
    }
    
    /// Convert a string to an attributed string.
    public func asAttributedString(with foregroundColor: UIColor, font: UIFont) -> NSAttributedString {
        let attr = NSMutableAttributedString.init(string: self.base)
        attr.addAttribute(
            NSAttributedString.Key.foregroundColor, value: foregroundColor,
            range: NSRange.init(location: 0, length: self.base.utf16.count)
        )
        attr.addAttribute(
            NSAttributedString.Key.font, value: font,
            range: NSRange.init(location: 0, length: self.base.utf16.count)
        )
        return attr as NSAttributedString
    }
    
    /// Copy string to pasteboard.
    public func copyToPasteboard() {
        guard self.base.utf16.count > 0 else {
            return
        }
        UIPasteboard.general.string = self.base
    }
    
    /// 截取指定范围的字符串 索引默认从 0 开始
    /// - Parameters:
    ///   - location: 开始的索引位置
    ///   - length: 截取长度
    /// - Returns: 字符串
    public func substring(at location: Int = 0, length: Int) -> String {
        if location > self.base.count || (location+length > self.base.count) {
            return self.base
        }
        var subStr: String = ""
        for idx in location..<(location + length) {
            subStr += self.base[self.base.index(self.base.startIndex, offsetBy: idx)].description
        }
        return subStr
    }
    
    /// Represent the name of a notification.
    ///
    /// - Returns: The name of a notification.
    public func asNotificationName() -> Notification.Name? {
        return self.base.cx_asNotificationName()
    }
    
}

//MARK: - Notification

extension String {
    
    /// Represent the name of a notification.
    ///
    /// - Returns: The name of a notification.
    public func cx_asNotificationName() -> Notification.Name?
    {
        // A string for the name of a notification.
        if self.isEmpty {
            return nil
        }
        return Notification.Name(self)
    }
    
}
