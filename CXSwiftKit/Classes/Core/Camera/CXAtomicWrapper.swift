//
//  AtomicWrapper.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/6/5.
//

import Foundation

@propertyWrapper
public struct atomic<Value> {
    
    private var value: Value
    private var lock: NSLock = NSLock()
    
    public init(wrappedValue value: Value) {
        self.value = value
    }
    
    public var wrappedValue: Value {
        get {
            return load()
        }
        set {
            store(newValue)
        }
    }
    
    public func load() -> Value {
        lock.lock()
        defer { lock.unlock() }
        return self.value
    }
    
    public mutating func store(_ newValue: Value) {
        lock.lock()
        defer { lock.unlock() }
        self.value = newValue
    }
    
}
