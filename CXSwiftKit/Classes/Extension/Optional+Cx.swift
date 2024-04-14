//
//  Optional+Cx.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2022/11/14.
//

extension Optional {
    
    /// True if the Optional is .None. Useful to avoid if-let.
    public var cx_isNil: Bool {
        if case .none = self {
            return true
        }
        return false
    }
    
}
