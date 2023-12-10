//
//  CXSwiftBase.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/30.
//

import Foundation

//MARK: - CXBaseModel
public protocol CXBaseModel {}

//MARK: - CXOBaseModel
@objc public protocol CXOBaseModel: AnyObject {}

#if os(iOS) || os(tvOS)
import UIKit
public typealias CXResponder      = UIResponder
public typealias CXViewController = UIViewController
public typealias CXView           = UIView
public typealias CXImageView      = UIImageView
public typealias CXImage          = UIImage
public typealias CXColor          = UIColor
public typealias CXFont           = UIFont
public typealias CXRect           = CGRect
public typealias CXPoint          = CGPoint
public typealias CXSize           = CGSize
public typealias CXEdgeInsets     = UIEdgeInsets
public typealias CXFontDescriptor = UIFontDescriptor
#elseif os(macOS)
import AppKit
public typealias CXResponder      = NSResponder
public typealias CXViewController = NSViewController
public typealias CXView           = NSView
public typealias CXImageView      = NSImageView
public typealias CXImage          = NSImage
public typealias CXColor          = NSColor
public typealias CXFont           = NSFont
public typealias CXRect           = NSRect
public typealias CXPoint          = NSPoint
public typealias CXSize           = NSSize
public typealias CXEdgeInsets     = NSEdgeInsets
public typealias CXFontDescriptor = NSFontDescriptor
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
