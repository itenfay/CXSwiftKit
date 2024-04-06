//
//  CXLock.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

import Foundation

/// Declare a `CXLockable` protocol.
@objc public protocol CXLockable: AnyObject {
    func lock()
    func unlock()
}

/// The unfair lock for multi-threading
@available(iOS 10.0, OSX 10.12, watchOS 3.0, tvOS 10.0, *)
@objc public final class CXUnfairLock: NSObject, CXLockable {
    private var unfairLock = os_unfair_lock_s()
    
    public func lock() {
        os_unfair_lock_lock(&unfairLock)
    }
    
    public func unlock() {
        os_unfair_lock_unlock(&unfairLock)
    }
}

/// The mutex lock for multi-threading.
@objc public final class CXMutex: NSObject, CXLockable {
    private var mutex = pthread_mutex_t()
    
    @objc public override init() {
        pthread_mutex_init(&mutex, nil)
    }
    
    deinit {
        pthread_mutex_destroy(&mutex)
    }
    
    public func lock() {
        pthread_mutex_lock(&mutex)
    }
    
    public func unlock() {
        pthread_mutex_unlock(&mutex)
    }
}

/// The recursive mutex lock for multi-threading.
@objc public final class CXRecursiveMutex: NSObject, CXLockable {
    private var mutex = pthread_mutex_t()
    
    @objc public override init() {
        var attr = pthread_mutexattr_t()
        pthread_mutexattr_init(&attr)
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(&mutex, &attr)
    }
    
    deinit {
        pthread_mutex_destroy(&mutex)
    }
    
    public func lock() {
        pthread_mutex_lock(&mutex)
    }
    
    public func unlock() {
        pthread_mutex_unlock(&mutex)
    }
}

/// The spin lock for multi-threading.
@objc public final class CXSpin: NSObject, CXLockable {
    private let locker: CXLockable
    
    @objc public override init() {
        if #available(iOS 10.0, macOS 10.12, watchOS 3.0, tvOS 10.0, *) {
            locker = CXUnfairLock()
        } else {
            locker = CXMutex()
        }
    }
    
    public func lock() {
        locker.lock()
    }
    
    public func unlock() {
        locker.unlock()
    }
}

/// The condition lock for multi-threading.
@objc public final class CXConditionLock: NSObject, CXLockable {
    private var mutex = pthread_mutex_t()
    private var cond = pthread_cond_t()
    
    @objc public override init() {
        pthread_mutex_init(&mutex, nil)
        pthread_cond_init(&cond, nil)
    }
    
    deinit {
        pthread_cond_destroy(&cond)
        pthread_mutex_destroy(&mutex)
    }
    
    public func lock() {
        pthread_mutex_lock(&mutex)
    }
    
    public func unlock() {
        pthread_mutex_unlock(&mutex)
    }
    
    @objc public func wait() {
        pthread_cond_wait(&cond, &mutex)
    }
    
    @objc public func wait(timeout: TimeInterval) {
        let integerPart = Int(timeout.nextDown)
        let fractionalPart = timeout - Double(integerPart)
        var ts = timespec(tv_sec: integerPart, tv_nsec: Int(fractionalPart * 1000000000))
        
        pthread_cond_timedwait_relative_np(&cond, &mutex, &ts)
    }
    
    @objc public func signal() {
        pthread_cond_signal(&cond)
    }
}
