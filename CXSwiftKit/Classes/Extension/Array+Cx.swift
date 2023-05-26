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

extension Array where Element: Equatable {
    
    /// Remove all duplicate elements from Array.
    public mutating func cx_removeDuplicates() {
        self = reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }
    
    /// Return array with all duplicate elements removed.
    ///
    /// - Returns: an array of unique elements.
    ///
    public func cx_withoutDuplicates() -> [Element] {
        return reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }
    
    /// Remove all duplicate elements using KeyPath to compare.
    ///
    /// - Parameter path: Key path to compare, the value must be Equatable.
    public mutating func cx_removeDuplicates<E: Equatable>(keyPath path: KeyPath<Element, E>) {
        var items = [Element]()
        removeAll { element -> Bool in
            guard items.contains(where: { $0[keyPath: path] == element[keyPath: path] }) else {
                items.append(element)
                return false
            }
            return true
        }
    }
    
    /// Remove all duplicate elements using KeyPath to compare.
    ///
    /// - Parameter path: Key path to compare, the value must be Hashable.
    public mutating func cx_removeDuplicates<E: Hashable>(keyPath path: KeyPath<Element, E>) {
        var set = Set<E>()
        removeAll { !set.insert($0[keyPath: path]).inserted }
    }
    
    /// Returns an array with all duplicate elements removed using KeyPath to compare.
    ///
    /// - Parameter path: Key path to compare, the value must be Equatable.
    /// - Returns: an array of unique elements.
    public func cx_withoutDuplicates<E: Equatable>(keyPath path: KeyPath<Element, E>) -> [Element] {
        return reduce(into: [Element]()) { (result, element) in
            if !result.contains(where: { $0[keyPath: path] == element[keyPath: path] }) {
                result.append(element)
            }
        }
    }
    
    /// Returns an array with all duplicate elements removed using KeyPath to compare.
    ///
    /// - Parameter path: Key path to compare, the value must be Hashable.
    /// - Returns: an array of unique elements.
    public func cx_withoutDuplicates<E: Hashable>(keyPath path: KeyPath<Element, E>) -> [Element] {
        var set = Set<E>()
        return filter { set.insert($0[keyPath: path]).inserted }
    }
    
}
