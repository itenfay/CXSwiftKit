//
//  Array+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

import Foundation

extension Array {
    
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
