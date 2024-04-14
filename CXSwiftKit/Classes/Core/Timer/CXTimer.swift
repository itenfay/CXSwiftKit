//
//  CXTimer.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2021/5/20.
//

import Foundation

public class CXTimer: NSObject {
    
    /// The private inner timer.
    private var timer: Timer?
    
    /// The repeating time interval.
    @objc public private(set) var repeatingInterval: TimeInterval = 1
    /// The remaining count for the countdown.
    @objc public private(set) var remainingFireCount: Int = 0
    /// Represents the timer whether you want to fire.
    @objc public private(set) var isFiring: Bool = false
    
    /// The closure for callback.
    private var invocationHandler: ((CXTimer) -> Void)?
    
    /// The receiver's userInfo object.
    @objc public var userInfo: Any? { return timer?.userInfo }
    
    @objc public override init() {
        super.init()
    }
    
    private func handleFireAction() {
        if remainingFireCount <= 0 {
            remainingFireCount = 0
            isFiring = false
            invalidate()
        } else {
            remainingFireCount--
            DispatchQueue.main.async {
                self.invocationHandler?(self)
            }
        }
    }
    
    @objc public func schedule(repeating interval: TimeInterval, invocation: @escaping (CXTimer) -> Void) {
        schedule(repeating: interval, userInfo: nil, invocation: invocation)
    }
    
    @objc public func schedule(repeating interval: TimeInterval, userInfo: Any?, invocation: @escaping (CXTimer) -> Void) {
        assert(interval >= 0, "The repeat time interval for the timer can not less than or equal to zero.")
        if timer != nil { return }
        repeatingInterval = interval
        invocationHandler = invocation
        timer = Timer(timeInterval: interval,
                      target: self,
                      selector: #selector(handleTimerAciton),
                      userInfo: userInfo,
                      repeats: interval > 0 ? true : false)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    /// Set the count of you want the timer to fire, it can be used to the countdown.
    @objc public func setFireCount(_ count: UInt) {
        remainingFireCount = Int(count)
        isFiring = true
    }
    
    @objc private func handleTimerAciton() {
        if repeatingInterval <= 0 {
            DispatchQueue.main.async {
                self.invocationHandler?(self)
            }
            invalidate()
            return
        }
        if isFiring {
            handleFireAction()
        } else {
            DispatchQueue.main.async {
                self.invocationHandler?(self)
            }
        }
    }
    
    /// Resume the timer.
    @objc public func resume() {
        timer?.fireDate = Date.distantPast
    }
    
    /// Pause the timer.
    @objc public func pause() {
        timer?.fireDate = Date.distantFuture
    }
    
    /// Invalidate the timer.
    @objc public func invalidate() {
        if timer == nil {
            return
        }
        timer?.invalidate()
        timer = nil
    }
    
}
