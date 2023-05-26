//
//  CXSwiftUtils.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

import Foundation

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
    
    /// Makes the vibrate system sound.
    @objc public static func makeVibrate(completion: (() -> Void)?) {
        #if canImport(AudioToolbox)
        cxMakeVibrate(completion: completion)
        #else
        CXLogger.log(level: .error, message: "Can't import AudioToolbox...")
        #endif
    }
    
    /// Creates a notification with a given name and sender and posts it to the notification center.
    @objc public static func notify(name aName: Notification.Name,
                                    object anObject: Any? = nil,
                                    userInfo aUserInfo: [AnyHashable: Any]? = nil)
    {
        cxNotify(name: aName, object: anObject, userInfo: aUserInfo)
    }
    
    /// Returns the time string by comparing current time.
    @objc public static func timeStringByComparingCurrentTime(_ string: String) -> String {
        return string.cx.timeStringByComparingCurrentTime()
    }
    
}

#if canImport(HandyJSON)
import HandyJSON

extension CXSwiftUtils {
    
    /// Converts an object into a json string, and the object should comply with the HandyJSON protocol.
    ///
    /// - Returns: A json string.
    public static func toJSONString<T>(with object: T) -> String? where T: HandyJSON
    {
        return object.toJSONString()
    }
    
    /// Converts a json string into an object, and the object should comply with the HandyJSON protocol.
    ///
    /// - Returns: An object should comply with the HandyJSON protocol.
    public static func toObject<T>(with json: String?, type: T.Type) -> T? where T: HandyJSON
    {
        return type.deserialize(from: json)
    }
    
    /// Converts an array that contains the objects into a json string, and the objects should comply with the HandyJSON protocol.
    ///
    /// - Returns: A json string.
    public static func toJSONString<T>(with objects: [T]) -> String? where T: HandyJSON
    {
        return objects.toJSONString()
    }
    
    /// Converts a json string into an array that contains the objects, and the objects should comply with the HandyJSON protocol.
    ///
    /// - Returns: An array that contains the objects should comply with the HandyJSON protocol.
    public static func toObjectArray<T>(with json: String?, type: T.Type) -> [T]? where T: HandyJSON
    {
        guard let jsonString = json,
              let objects = (JSONDeserializer<T>.deserializeModelArrayFrom(json: jsonString)) as? [T]
        else {
            return nil
        }
        return objects
    }
    
}
#endif
