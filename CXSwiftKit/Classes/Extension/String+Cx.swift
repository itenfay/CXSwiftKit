//
//  String+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if canImport(Foundation)
import Foundation
#if canImport(CommonCrypto)
import CommonCrypto
#endif
#if canImport(CoreImage)
import CoreImage
#endif

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
    
    #if canImport(CommonCrypto)
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
    #endif
    
    /// Convert a date string to a timestamp，dateFormat: "yyyy-MM-dd HH:mm:ss".
    ///
    /// - Parameter dateFormat: The date format string used by the receiver.
    /// - Returns: The interval between the date value and 00:00:00 UTC on 1 January 1970.
    public func toTimestamp(_ dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Double? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: self.base)
        return date?.timeIntervalSince1970
    }
    
    /// Convert a timestamp to a date string，dateFormat: "yyyy-MM-dd HH:mm:ss".
    public func tsToDateString(_ dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let ts = NSString(string: self.base)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = Date(timeIntervalSince1970: ts.doubleValue)
        return dateFormatter.string(from: date)
    }
    
    /// Convert a date string to a date object.
    public func toDate(_ dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        guard let date = dateFormatter.date(from: self.base) else {
            return nil
        }
        return date
    }
    
    /// The specified date whether is greater than the current date.
    public func greaterThanCurrentDate() -> Bool {
        let ts = self.toTimestamp() ?? 0
        let currTS = Date().timeIntervalSince1970
        return ts > currTS
    }
    
    /// The specified date whether is greater than or equal to the current date.
    public func greaterThanOrEqualToCurrentDate() -> Bool {
        let ts = self.toTimestamp() ?? 0
        let currTS = Date().timeIntervalSince1970
        return ts >= currTS
    }
    
    /// Return a Base-64 encoded string.
    public func base64Encode() -> String? {
        guard let data = self.base.data(using: .utf8) else {
            return nil
        }
        return data.base64EncodedString()
    }
    
    /// Return a Base-64 encoded string for the url.
    public func safeUrlBase64Encode() -> String? {
        guard let base = self.base.cx.base64Encode() else {
            return nil
        }
        var base64Str = "" + base
        base64Str = base64Str.replacingOccurrences(of: "+", with: "-")
        base64Str = base64Str.replacingOccurrences(of: "/", with: "_")
        base64Str = base64Str.replacingOccurrences(of: "=", with: "")
        return base64Str
    }
    
    /// The Base-64 decoding for the url.
    public func safeUrlBase64Decode() -> String? {
        // '-' -> '+'
        // '_' -> '/'
        // Less than 4 times the length, complement' ='
        var base64Str = "" + self.base
        base64Str = base64Str.replacingOccurrences(of: "-", with: "+")
        base64Str = base64Str.replacingOccurrences(of: "_", with: "/")
        let mod4 = base64Str.count % 4
        if mod4 > 0 {
            let padding = String(repeating: "=", count: 4 - mod4)
            base64Str.append(padding)
        }
        return base64Str.cx.base64Decode()
    }
    
    /// Return a Base-64 decoded string.
    public func base64Decode() -> String? {
        guard let data = Data.init(base64Encoded: self.base) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    /// Encode an url.
    public func urlEncode() -> String {
        let encodeUrlString = self.base.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
        return encodeUrlString ?? self.base
    }
    
    /// Encode an url.
    public func customUrlEncode() -> String {
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
        guard self.length > 0 else {
            return
        }
        UIPasteboard.general.string = self.base
    }
    
    /// Intercept the specified range of string, indexes starting from 0 by default.
    ///
    /// - Parameters:
    ///   - location: The index to start.
    ///   - length: The length from start index to end index.
    /// - Returns: A substring with the specified range of string.
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
        // A string for the name of a notification.
        if self.base.isEmpty {
            return nil
        }
        return Notification.Name(self.base)
    }
    
    #if canImport(CoreImage)
    /// Generates an image of QRCode.
    ///
    /// - Returns: An image of QRCode.
    public func generateQRCode() -> UIImage? {
        return generateQRCode(withCenterImage: nil)
    }
    
    /// Generates an image of QRCode with a given center image and center size.
    ///
    /// - Parameters:
    ///   - centerImage: A center image to draw.
    ///   - centerSize: The size of center image to draw.
    /// - Returns: An image of QRCode.
    public func generateQRCode(withCenterImage centerImage: UIImage?, centerSize: CGSize = .init(width: 90, height: 90)) -> UIImage? {
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter?.setDefaults()
        
        let data = self.base.data(using: .utf8)
        qrFilter?.setValue(data, forKey: "inputMessage")
        
        let outputImage = qrFilter?.outputImage
        guard let opImage = outputImage else {
            return nil
        }
        let codeImage = opImage.transformed(by: CGAffineTransform(scaleX: 9, y: 9))
        let qrImage = UIImage(ciImage: codeImage)
        let size = qrImage.size
        UIGraphicsBeginImageContext(size)
        qrImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        if centerImage != nil {
            let cX = (size.width - centerSize.width) / 2
            let cY = (size.height - centerSize.height) / 2
            centerImage!.draw(in: CGRect(x: cX, y: cY, width: centerSize.width, height: centerSize.height))
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /// Generates an image of QRCode with a given background color and foreground color.
    ///
    /// - Parameters:
    ///   - backgroudColor: A background color to draw.
    ///   - foregroudColor: A foreground color to draw.
    /// - Returns: An image of QRCode.
    public func generateQRCode(withBackgroudColor backgroudColor: UIColor, foregroudColor: UIColor) -> UIImage? {
        return generateQRCode(withBackgroudColor: backgroudColor, foregroudColor: foregroudColor, centerImage: nil)
    }
    
    /// Generates an image of QRCode with a given background color, foreground color, center image and center size.
    ///
    /// - Parameters:
    ///   - backgroudColor: A background color to draw.
    ///   - foregroudColor: A foreground color to draw.
    ///   - centerImage: A center image to draw.
    ///   - centerSize: The size of center image to draw.
    /// - Returns: An image of QRCode.
    public func generateQRCode(withBackgroudColor backgroudColor: UIColor, foregroudColor: UIColor, centerImage: UIImage?, centerSize: CGSize = .init(width: 90, height: 90)) -> UIImage? {
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter?.setDefaults()
        
        let data = self.base.data(using: .utf8)
        qrFilter?.setValue(data, forKey: "inputMessage")
        
        let outputImage = qrFilter?.outputImage
        guard let opImage = outputImage else {
            return nil
        }
        
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter?.setDefaults()
        colorFilter?.setValue(opImage, forKey: "inputImage")
        colorFilter?.setValue(CIColor(cgColor: foregroudColor.cgColor), forKey: "inputColor0")
        colorFilter?.setValue(CIColor(cgColor: backgroudColor.cgColor), forKey: "inputColor1")
        let cOutputImage = colorFilter?.outputImage
        guard let cOpImage = cOutputImage else {
            return nil
        }
        
        let codeImage = cOpImage.transformed(by: CGAffineTransform(scaleX: 9, y: 9))
        let qrImage = UIImage(ciImage: codeImage)
        let size = qrImage.size
        UIGraphicsBeginImageContext(size)
        qrImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        if centerImage != nil {
            let cX = (size.width - centerSize.width) / 2
            let cY = (size.height - centerSize.height) / 2
            centerImage!.draw(in: CGRect(x: cX, y: cY, width: centerSize.width, height: centerSize.height))
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    #endif
    
    /// The string whether is a valid number.
    public func validNumber() -> Bool{
        do {
            let pattern = "^[0-9]*$"
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let results = regex.matches(in: self.base, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.length))
            return results.count > 0
        } catch {
            return false
        }
    }
    
    /// The string whether is a telephone number.
    public func evaluateTelephone() -> Bool {
        let regex = "^1[3456789]\\d{9}$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self.base)
    }
    
    /// The string whether is a decimal number.
    public func evaluateDecimal() -> Bool {
        let regex = "^[0-9]+(\\.[0-9]{1,2})?$"
        let pred = NSPredicate.init(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self.base)
    }
    
    /// The string whether is safe password.
    public func evaluateSafePassword() -> Bool {
        let regex = "^[a-zA-Z0-9]{6,16}+$"
        let pred = NSPredicate.init(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self.base)
    }
    
    /// Returns the time string by comparing current time.
    public func timeStringByComparingCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let timeDate = formatter.date(from: self.base) else {
            return ""
        }
        let currentDate = Date()
        let timeInterval = currentDate.timeIntervalSince(timeDate)
        var temp: Double = 0
        var result = String()
        if (timeInterval/60 < 1) {
            result = "刚刚"
        } else if ((timeInterval/60) < 60) {
            temp = timeInterval/60
            result = String(format:"%ld分钟前", Int(temp))
        } else if ((timeInterval/60/60) < 24) {
            temp = timeInterval/60/60
            result = String(format:"%ld小时前", Int(temp))
        } else if ((timeInterval/60/60/24) < 30) {
            temp = timeInterval/60/60/24
            result = String(format:"%ld天前", Int(temp))
        } else if ((timeInterval/60/60/24/30) < 12) {
            temp = timeInterval/60/60/24/30
            result = String(format:"%ld月前", Int(temp))
        } else {
            temp = timeInterval/60/60/24/30/12;
            result = String(format:"%ld年前", Int(temp))
        }
        return result
    }
    
    /// NSLocalizedString shorthand.
    public var localizedString: String {
        return localizedString(withValue: "", comment: "")
    }
    
    /// Returns a localized string from a table that Xcode generates for you when exporting localizations.
    ///
    /// - Parameters:
    ///   - value: The localized string for the development locale. For other locales, return this value if key isn’t found in the table.
    ///   - comment: The comment to place above the key-value pair in the strings file. This parameter provides the translator with some context about the localized string’s presentation to the user.
    ///   - tableName: The name of the table containing the key-value pairs. This defaults to the table in Localizable.strings when tableName is nil or an empty string.
    ///   - bundle: The bundle containing the table’s strings file. The main bundle is used if one isn’t specified.
    /// - Returns: The result of sending localizedString(forKey:value:table:) to bundle, passing the specified key, value, and tableName.
    public func localizedString(withValue value: String, comment: String, table tableName: String? = nil, bundle: Bundle = .main) -> String {
        return NSLocalizedString(self.base, tableName: tableName, bundle: bundle, value: value, comment: comment)
    }
    
    /// Returns a localized version of the string designated by the specified key and residing in the specified table.
    ///
    /// - Parameters:
    ///   - value: The value to return if key is nil or if a localized string for key can’t be found in the table.
    ///   - tableName: The receiver’s string table to search. If tableName is nil or is an empty string, the method attempts to use the table in Localizable.strings.
    ///   - bundle: The bundle containing the table’s strings file. The main bundle is used if one isn’t specified.
    /// - Returns: A localized version of the string designated by key in table tableName. This method returns the following when key is nil or not found in table:
    /// * If key is nil and value is nil, returns an empty string.
    /// * If key is nil and value is non-nil, returns value.
    /// * If key is not found and value is nil or an empty string, returns key.
    /// * If key is not found and value is non-nil and not empty, return value.
    public func localizedString(withValue value: String?, table tableName: String? = "", bundle: Bundle = .main) -> String {
        return bundle.localizedString(forKey: self.base, value: value, table: tableName)
    }
    
    /// Returns a Boolean value indicating whether a string has characters.
    public func isNotEmpty() -> Bool {
        return !self.base.isEmpty
    }
    
    /// Returns a new string made by adding to the receiver a given string.
    public func addPathComponent(_ string: String) -> String {
        let nsStr = NSString(string: self.base)
        return nsStr.appendingPathComponent(string)
    }
    
    /// Returns a Boolean value indicating whether a string is equal to self.base.
    public func equalsIgnoreCase(_ string: String) -> Bool {
        return self.base.lowercased() == string.lowercased()
    }
    
}

#endif
