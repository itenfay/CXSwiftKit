//
//  AtomicWrapper.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2023/6/5.
//

import Foundation

@propertyWrapper
public struct Atomic<T> {
    
    private var lock: NSLock = NSLock()
    private var value: T
    
    public init(wrappedValue value: T) {
        self.value = value
    }
    
    public var wrappedValue: T {
        get { return read() }
        set { write(newValue) }
    }
    
    public func read() -> T {
        lock.lock()
        defer { lock.unlock() }
        return self.value
    }
    
    public mutating func write(_ value: T) {
        lock.lock()
        self.value = value
        lock.unlock()
    }
    
}
