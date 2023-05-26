//
//  DispatchQueue+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

import Foundation
#if canImport(Dispatch)
import Dispatch

// Declares an array of string to record the token.
fileprivate var _cxOnceTracker = [String]()

extension CXSwiftBase where T : DispatchQueue {
    
    /// Submits a work item to a dispatch queue
    ///
    /// - Parameter work: The work item to be invoked on the queue.
    public static func mainAsync(execute work: @escaping @convention(block) () -> Void)
    {
        DispatchQueue.main.async(execute: work)
    }
    
    /// Submits a block object for execution and returns after that block finishes executing.
    ///
    /// - Parameter block: The block that contains the work to perform.
    public static func mainSync(execute block: () -> Void)
    {
        DispatchQueue.main.sync(execute: block)
    }
    
    /// Submits a work item to a dispatch queue for asynchronous execution after a specified time.
    ///
    /// - Parameters:
    ///   - delay: The time interval after which the work item should be executed.
    ///   - work: The work item to be invoked on the queue.
    public static func mainAsyncAfter(_ delay: TimeInterval, execute work: @escaping @convention(block) () -> Void)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: work)
    }
    
    /// Submits a work item to a global dispatch queue.
    ///
    /// - Parameters:
    ///   - qos: The quality-of-service level to associate with the queue.
    ///   - work: The work item to be invoked on the queue.
    public static func globalAsync(_ qos: DispatchQoS.QoSClass = .default, execute work: @escaping @convention(block) () -> Void)
    {
        DispatchQueue.global(qos: qos).async(execute: work)
    }
    
    /// Executes a block of code associated with a given token, only once.
    /// The code is thread safe and will only execute the code once even in the presence of multi-thread calls.
    ///
    /// - Parameters:
    ///   - token: A unique idetifier.
    ///   - block: A block to execute once.
    public static func once(token: String, block: () -> Void)
    {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if _cxOnceTracker.contains(token) {
            return
        }
        _cxOnceTracker.append(token)
        block()
    }
    
}

extension CXSwiftBase where T: DispatchGroup {
    
    /// Explicitly indicates that a block has entered the group.
    public func enter()
    {
        self.base.enter()
    }
    
    /// Explicitly indicates that a block in the group finished executing.
    public func leave()
    {
        self.base.leave()
    }
    
    /// Schedules the submission of a block with the specified attributes to a queue when all tasks in the current group have finished executing.
    ///
    /// - Parameter work: The work to be performed on the dispatch queue when the group is completed.
    public func notify(queue: DispatchQueue = DispatchQueue.main, execute work: @escaping @convention(block) () -> Void)
    {
        self.base.notify(queue: queue, execute: work)
    }
    
    /// Waits synchronously for the previously submitted work to finish.
    public func wait()
    {
        self.base.wait()
    }
    
    /// Waits synchronously for the previously submitted work to complete,
    /// and returns if the work is not completed before the specified timeout period has elapsed.
    ///
    /// - Parameter timeout: The latest time to wait for a group to complete.
    public func wait(timeout: DispatchTime) -> DispatchTimeoutResult
    {
        return self.base.wait(timeout: timeout)
    }
    
}

#endif
