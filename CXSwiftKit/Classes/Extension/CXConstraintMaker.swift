//
//  CXConstraintMaker.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2022/11/14.
//

import Foundation
#if !os(watchOS) && canImport(UIKit)
import UIKit

public class CXConstraintItem: NSObject {
    internal var isEqual: Bool = false
    internal var isGreaterThanOrEqual: Bool = false
    internal var isLessThanOrEqual: Bool = false
    
    @objc public private(set) var value: CGFloat = 0
    
    @discardableResult
    @objc public func equalToSuperview() -> CXConstraintItem {
        value = 0
        isEqual = true
        isGreaterThanOrEqual = false
        isLessThanOrEqual = false
        return self
    }
    
    @discardableResult
    @objc public func equalTo(_ constant: CGFloat) -> CXConstraintItem {
        value = constant
        isEqual = true
        isGreaterThanOrEqual = false
        isLessThanOrEqual = false
        return self
    }
    
    @discardableResult
    @objc public func greaterThanOrEqualTo(_ constant: CGFloat) -> CXConstraintItem {
        value = constant
        isEqual = false
        isGreaterThanOrEqual = true
        isLessThanOrEqual = false
        return self
    }
    
    @discardableResult
    @objc public func lessThanOrEqualTo(_ constant: CGFloat) -> CXConstraintItem {
        value = constant
        isEqual = false
        isGreaterThanOrEqual = false
        isLessThanOrEqual = true
        return self
    }
    
    public var hasConstraints: Bool {
        return (isEqual || isGreaterThanOrEqual || isLessThanOrEqual) ? true : false
    }
    
    @objc public func offset(_ constant: CGFloat) {
        value = value + constant
    }
}

public class CXConstraintXAxisItem: CXConstraintItem {
    internal var xAnchor: NSLayoutXAxisAnchor?
    
    @discardableResult
    @objc public func equalToAnchor(_ anchor: NSLayoutXAxisAnchor) -> CXConstraintXAxisItem {
        xAnchor = anchor
        isEqual = true
        isGreaterThanOrEqual = false
        isLessThanOrEqual = false
        return self
    }
    
    @discardableResult
    @objc public func greaterThanOrEqualToAnchor(_ anchor: NSLayoutXAxisAnchor) -> CXConstraintXAxisItem {
        xAnchor = anchor
        isEqual = false
        isGreaterThanOrEqual = true
        isLessThanOrEqual = false
        return self
    }
    
    @discardableResult
    @objc public func lessThanOrEqualToAnchor(_ anchor: NSLayoutXAxisAnchor) -> CXConstraintXAxisItem {
        xAnchor = anchor
        isEqual = false
        isGreaterThanOrEqual = false
        isLessThanOrEqual = true
        return self
    }
}

public class CXConstraintYAxisItem: CXConstraintItem {
    internal var yAnchor: NSLayoutYAxisAnchor?
    
    @discardableResult
    @objc public func equalToAnchor(_ anchor: NSLayoutYAxisAnchor) -> CXConstraintYAxisItem {
        yAnchor = anchor
        isEqual = true
        isGreaterThanOrEqual = false
        isLessThanOrEqual = false
        return self
    }
    
    @discardableResult
    @objc public func greaterThanOrEqualToAnchor(_ anchor: NSLayoutYAxisAnchor) -> CXConstraintYAxisItem {
        yAnchor = anchor
        isEqual = false
        isGreaterThanOrEqual = true
        isLessThanOrEqual = false
        return self
    }
    
    @discardableResult
    @objc public func lessThanOrEqualToAnchor(_ anchor: NSLayoutYAxisAnchor) -> CXConstraintYAxisItem {
        yAnchor = anchor
        isEqual = false
        isGreaterThanOrEqual = false
        isLessThanOrEqual = true
        return self
    }
}

public class CXConstraintDimensionItem: CXConstraintItem {
    internal var dimens: NSLayoutDimension?
    
    @discardableResult
    @objc public func equalToDimension(_ dimension: NSLayoutDimension) -> CXConstraintDimensionItem {
        dimens = dimension
        isEqual = true
        isGreaterThanOrEqual = false
        isLessThanOrEqual = false
        return self
    }
    
    @discardableResult
    @objc public func greaterThanOrEqualToDimension(_ dimension: NSLayoutDimension) -> CXConstraintDimensionItem {
        dimens = dimension
        isEqual = false
        isGreaterThanOrEqual = true
        isLessThanOrEqual = false
        return self
    }
    
    @discardableResult
    @objc public func lessThanOrEqualToDimension(_ dimension: NSLayoutDimension) -> CXConstraintDimensionItem {
        dimens = dimension
        isEqual = false
        isGreaterThanOrEqual = false
        isLessThanOrEqual = true
        return self
    }
}

public class CXConstraintMaker: NSObject {
    /// The top item of the constraint maker.
    @objc public var top: CXConstraintYAxisItem!
    /// The leading item of the constraint maker.
    @objc public var leading: CXConstraintXAxisItem!
    /// The bottom item of the constraint maker.
    @objc public var bottom: CXConstraintYAxisItem!
    /// The trailing item of the constraint maker.
    @objc public var trailing: CXConstraintXAxisItem!
    /// The width item of the constraint maker.
    @objc public var width: CXConstraintDimensionItem!
    /// The height item of the constraint maker.
    @objc public var height: CXConstraintDimensionItem!
    /// The center x item of the constraint maker.
    @objc public var centerX: CXConstraintXAxisItem!
    /// The center y item of the constraint maker.
    @objc public var centerY: CXConstraintYAxisItem!
    
    @objc public init(
        top: CXConstraintYAxisItem,
        leading: CXConstraintXAxisItem,
        bottom: CXConstraintYAxisItem,
        trailing: CXConstraintXAxisItem,
        width: CXConstraintDimensionItem,
        height: CXConstraintDimensionItem,
        centerX: CXConstraintXAxisItem,
        centerY: CXConstraintYAxisItem)
    {
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
        self.width = width
        self.height = height
        self.centerX = centerX
        self.centerY = centerY
    }
}

#endif
