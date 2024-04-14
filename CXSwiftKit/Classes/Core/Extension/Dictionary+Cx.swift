//
//  Dictionary+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

import Foundation

extension Dictionary: CXSwiftBaseCompatible {}

extension CXSwiftBase where T == Dictionary<AnyHashable, Any> {
    
    public func toJSONString() -> String?
    {
        return base.cx_toJSONString(withPrettyPrinted: false)
    }
    
    public func toJSONString(withPrettyPrinted prettyPrinted: Bool) -> String?
    {
        return base.cx_toJSONString(withPrettyPrinted: prettyPrinted)
    }
    
    public func toJSONData() -> Data?
    {
        return base.cx_toJSONData(withPrettyPrinted: false)
    }
    
    public func toJSONData(withPrettyPrinted prettyPrinted: Bool) -> Data?
    {
        return base.cx_toJSONData(withPrettyPrinted: prettyPrinted)
    }
    
}

extension Dictionary {
    
    public static func += <KeyType, ValueType>(lhs: inout Dictionary<KeyType, ValueType>, rhs: Dictionary<KeyType, ValueType>) {
        for (k, v) in rhs {
            lhs.updateValue(v, forKey: k)
        }
    }
    
    public func cx_toJSONString() -> String?
    {
        return cx_toJSONString(withPrettyPrinted: false)
    }
    
    public func cx_toJSONString(withPrettyPrinted prettyPrinted: Bool) -> String?
    {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: prettyPrinted ? .prettyPrinted : [])
        else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    public func cx_toJSONData() -> Data?
    {
        return cx_toJSONData(withPrettyPrinted: false)
    }
    
    public func cx_toJSONData(withPrettyPrinted prettyPrinted: Bool) -> Data?
    {
        return try? JSONSerialization.data(withJSONObject: self, options: prettyPrinted ? .prettyPrinted : [])
    }
    
}
