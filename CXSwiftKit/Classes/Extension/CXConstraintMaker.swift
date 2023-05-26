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
    @objc public var top: CXConstraintItem { CXConstraintItem() }
    /// The leading item of the constraint maker.
    @objc public var leading: CXConstraintItem { CXConstraintItem() }
    /// The bottom item of the constraint maker.
    @objc public var bottom: CXConstraintItem { CXConstraintItem() }
    /// The trailing item of the constraint maker.
    @objc public var trailing: CXConstraintItem { CXConstraintItem() }
    /// The width item of the constraint maker.
    @objc public var width: CXConstraintItem { CXConstraintItem() }
    /// The height item of the constraint maker.
    @objc public var height: CXConstraintItem { CXConstraintItem() }
    /// The center x item of the constraint maker.
    @objc public var centerX: CXConstraintItem { CXConstraintItem() }
    /// The center y item of the constraint maker.
    @objc public var centerY: CXConstraintItem { CXConstraintItem() }
}
