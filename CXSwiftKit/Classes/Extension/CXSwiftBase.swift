//
//  CXSwiftBase.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2022/11/30.
//

import Foundation

/// Declares a `CXSwiftBase` struct.
public struct CXSwiftBase<T> {
    public let base: T
    
    public init(_ base: T) {
        self.base = base
    }
}

/// Declares a `CXSwiftBaseCompatible` protocol.
public protocol CXSwiftBaseCompatible {
    associatedtype M
    
    static var cx: CXSwiftBase<M>.Type {get set}
    var cx: CXSwiftBase<M> {get set}
}

/// Implements this protocol by default.
public extension CXSwiftBaseCompatible {
    static var cx: CXSwiftBase<Self>.Type {
        get { return CXSwiftBase<Self>.self }
        set {}
    }
    
    var cx: CXSwiftBase<Self> {
        get { return CXSwiftBase<Self>(self) }
        set {}
    }
}
