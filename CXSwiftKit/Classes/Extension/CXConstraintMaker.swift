//
//  CXConstraintMaker.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

import Foundation

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
    
    @objc public func offset(_ constant: CGFloat) {
        value = value + constant
    }
}

public class CXConstraintMaker: NSObject {
    /// The top item of the constraint maker.
    @objc public var top: CXConstraintItem!
    /// The leading item of the constraint maker.
    @objc public var leading: CXConstraintItem!
    /// The bottom item of the constraint maker.
    @objc public var bottom: CXConstraintItem!
    /// The trailing item of the constraint maker.
    @objc public var trailing: CXConstraintItem!
    /// The width item of the constraint maker.
    @objc public var width: CXConstraintItem!
    /// The height item of the constraint maker.
    @objc public var height: CXConstraintItem!
    /// The center x item of the constraint maker.
    @objc public var centerX: CXConstraintItem!
    /// The center y item of the constraint maker.
    @objc public var centerY: CXConstraintItem!
    
    init(top: CXConstraintItem,
         leading: CXConstraintItem,
         bottom: CXConstraintItem,
         trailing: CXConstraintItem,
         width: CXConstraintItem,
         height: CXConstraintItem,
         centerX: CXConstraintItem,
         centerY: CXConstraintItem)
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
