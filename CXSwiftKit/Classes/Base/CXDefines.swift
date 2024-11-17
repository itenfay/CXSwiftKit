//
//  CXSwiftBase.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2022/11/30.
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
