//
//  HandyJSONHelper.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

import Foundation
#if canImport(HandyJSON)
import HandyJSON

//MARK: - CXHJBaseModel

public class HandyJSONHelper {
    
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
