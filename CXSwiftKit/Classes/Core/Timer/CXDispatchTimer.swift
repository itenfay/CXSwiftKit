//
//  CXDispatchTimer.swift
//  CXSwiftKit
//
//  Created by chenxing on 2021/5/20.
//

#if canImport(Foundation)
import Foundation

public class CXDispatchTimer {
    
    fileprivate var _timer: DispatchSourceTimer?
    private let _queue: DispatchQueue
    private var _lastActiveDate: Date?
    public private(set) var elapsedAccumulatedTime: Double = 0
    
    public enum Status {
        case invalid
        case active
        case paused
    }
    
    public private(set) var status: Status = .invalid
    public private(set) var isFiring: Bool = false
    public private(set) var remainingFireCount: Int = 0
    
    /// The interval in milliseconds.
    public let interval: UInt
    /// The delay in milliseconds.
    public let delay: UInt
    /// The leeway in nanoseconds.
    public let leeway: UInt
    public let repeats: Bool
    
    private let invocationBlock: (CXDispatchTimer) -> Void
    public var completionHandler: ((CXDispatchTimer) -> Void)?
    public let userInfo: Any?
    public var isValid: Bool { return status != .invalid }
    
    convenience public init(timeInterval ti: UInt, repeats: Bool, invocation: @escaping (CXDispatchTimer) -> Void) {
        self.init(timeInterval: ti, delay: 0, leeway: 0, userInfo: nil, repeats: repeats, queue: nil, invocation: invocation)
    }
    
    convenience public init(timeInterval ti: UInt, userInfo: Any?, repeats: Bool, invocation: @escaping (CXDispatchTimer) -> Void) {
        self.init(timeInterval: ti, delay: 0, leeway: 0, userInfo: userInfo, repeats: repeats, queue: nil, invocation: invocation)
    }
    
    public init(timeInterval interval: UInt, delay: UInt, leeway: UInt, userInfo: Any?, repeats: Bool, queue: DispatchQueue?, invocation: @escaping (CXDispatchTimer) -> Void) {
        self.interval = interval
        self.delay = delay
        self.leeway = leeway
        self.userInfo = userInfo
        self.repeats = repeats
        if queue != nil {
            self._queue = queue!
        } else {
            self._queue = DispatchQueue(label: "cx.dispatchtimer.queue")
        }
        self.invocationBlock = invocation
    }
    
    public class func scheduledTimer(timeInterval ti: UInt, repeats: Bool, invocation: @escaping (CXDispatchTimer) -> Void) -> CXDispatchTimer {
        return scheduledTimer(timeInterval: ti, userInfo: nil, repeats: repeats, invocation: invocation)
    }
    
    public class func scheduledTimer(timeInterval ti: UInt, userInfo: Any?, repeats: Bool, invocation: @escaping (CXDispatchTimer) -> Void) -> CXDispatchTimer {
        return scheduledTimer(timeInterval: ti, userInfo: userInfo, repeats: repeats, queue: nil, invocation: invocation)
    }
    
    public class func scheduledTimer(timeInterval ti: UInt, userInfo: Any?, repeats: Bool, queue: DispatchQueue?, invocation: @escaping (CXDispatchTimer) -> Void) -> CXDispatchTimer {
        return scheduledTimer(timeInterval: ti, delay: 0, userInfo: userInfo, repeats: repeats, queue: queue, invocation: invocation)
    }
    
    public class func scheduledTimer(timeInterval ti: UInt, delay: UInt, userInfo: Any?, repeats: Bool, queue: DispatchQueue?, invocation: @escaping (CXDispatchTimer) -> Void) -> CXDispatchTimer {
        return scheduledTimer(timeInterval: ti, delay: delay, leeway: 0, userInfo: userInfo, repeats: repeats, queue: queue, invocation: invocation)
    }
    
    public class func scheduledTimer(timeInterval ti: UInt, delay: UInt, leeway: UInt, userInfo: Any?, repeats: Bool, queue: DispatchQueue?, invocation: @escaping (CXDispatchTimer) -> Void) -> CXDispatchTimer {
        let timer = CXDispatchTimer(timeInterval: ti, delay: delay, leeway: leeway, userInfo: userInfo, repeats: repeats, queue: queue, invocation: invocation)
        timer.start()
        return timer
    }
    
    /// Destory the timer.
    private func destroyTimer() {
        _timer = nil
    }
    
    private func hanleEvent() {
        self.elapsedAccumulatedTime = 0
        if self.isFiring {
            self.remainingFireCount--
            if self.remainingFireCount <= 0 {
                self.invalidate()
                self.remainingFireCount = 0
                self.isFiring = false
            }
        }
        DispatchQueue.main.async {
            self.invocationBlock(self)
        }
    }
    
    /// Set the count of you want the timer to fire, it can be used to the countdown.
    public func setFireCount(_ count: Int) {
        remainingFireCount = count
        isFiring = true
    }
    
    /// Start the timer.
    public func start() {
        if status == .invalid {
            _timer = DispatchSource.makeTimerSource(flags: .strict, queue: _queue)
            let deadline = DispatchTime.now() + Double(delay) / 1000
            let leeway = DispatchTimeInterval.nanoseconds(Int(leeway))
            _timer!.schedule(deadline: deadline, repeating: !repeats ? .never : .milliseconds(Int(interval)), leeway: leeway)
            _timer!.setEventHandler { [weak self] in
                self?.hanleEvent()
            }
            _timer!.setCancelHandler { [weak self] in
                guard let s = self else { return }
                DispatchQueue.main.async {
                    s.completionHandler?(s)
                }
                s.destroyTimer()
            }
            if #available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
                _timer?.activate()
            } else {
                _timer?.resume()
            }
            status = .active
            _lastActiveDate = Date()
        }
    }
    
    /// Pause the timer.
    public func pause() {
        if status == .active {
            _timer?.suspend()
            status = .paused
            let pauseDate = Date()
            elapsedAccumulatedTime += (pauseDate.timeIntervalSince1970 - _lastActiveDate!.timeIntervalSince1970) * 1000
        }
    }
    
    /// Resume the timer.
    public func resume() {
        if status == .paused {
            _timer?.resume()
            status = .active
            _lastActiveDate = Date()
        }
    }
    
    /// Invalidate the timer.
    public func invalidate() {
        if status != .invalid {
            _timer?.cancel()
            status = .invalid
        }
    }
    
}

extension CXDispatchTimer: Equatable {
    
    public static func == (lhs: CXDispatchTimer, rhs: CXDispatchTimer) -> Bool {
        return lhs._timer === rhs._timer
    }
    
}

#endif
