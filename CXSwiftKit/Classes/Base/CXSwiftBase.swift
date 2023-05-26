//
//  CXSwiftBase.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/30.
//

import Foundation

//MARK: - CXBaseModel

#if canImport(HandyJSON)
import HandyJSON
public protocol CXBaseModel: HandyJSON {}
#else
public protocol CXBaseModel {}
#endif

//MARK: - CXObjcBaseModel

@objc public protocol CXObjcBaseModel: AnyObject {}

#if os(iOS) || os(tvOS)
import UIKit
public typealias CXViewController = UIViewController
public typealias CXView           = UIView
public typealias CXImageView      = UIImageView
public typealias CXImage          = UIImage
public typealias CXFont           = UIFont
#elseif os(macOS)
import AppKit
public typealias CXViewController = NSViewController
public typealias CXView           = NSView
public typealias CXImageView      = NSImageView
public typealias CXImage          = NSImage
public typealias CXFont           = NSFont
#else
#endif

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
