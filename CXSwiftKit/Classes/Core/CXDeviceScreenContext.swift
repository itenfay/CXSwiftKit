//
//  CXDeviceScreenContext.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if os(iOS) || os(tvOS)
import UIKit

public class CXDeviceScreenContext: NSObject {
    
    private var onObserveScreenBrightness: ((CGFloat) -> Void)?
    private var onObserveProtectedDataDidBecomeAvailable: ((Notification) -> Void)?
    private var onObserveProtectedDataWillBecomeUnavailable: ((Notification) -> Void)?
    private var onObserveProximityStateDidChange: ((Bool) -> Void)?
    
    @objc public func subscribeBrightnessChange(handler: @escaping (CGFloat) -> Void) {
        onObserveScreenBrightness = handler
        NotificationCenter.default.addObserver(self, selector: #selector(brightnessDidChange(_:)), name: UIScreen.brightnessDidChangeNotification, object: nil)
    }
    
    @objc public func unsubscribeBrightnessChange() {
        onObserveScreenBrightness = nil
        NotificationCenter.default.removeObserver(self, name: UIScreen.brightnessDidChangeNotification, object: nil)
    }
    
    @objc private func brightnessDidChange(_ noti: Notification) {
        guard let screen = noti.object as? UIScreen else {
            return
        }
        CXLogger.log(level: .info, message: "brightness: \(screen.brightness)" +
                     (screen.brightness > 0 ? "Screen Light" : "Screen Extinction"))
        onObserveScreenBrightness?(screen.brightness)
    }
    
    @objc public func subscribeProtectedDataDidBecomeAvailable(handler: @escaping (Notification) -> Void) {
        onObserveProtectedDataDidBecomeAvailable = handler
        NotificationCenter.default.addObserver(self, selector: #selector(protectedDataDidBecomeAvailable(_:)), name: UIApplication.protectedDataDidBecomeAvailableNotification, object: nil)
    }
    
    @objc public func unsubscribeProtectedDataDidBecomeAvailable() {
        onObserveProtectedDataDidBecomeAvailable = nil
        NotificationCenter.default.removeObserver(self, name: UIApplication.protectedDataDidBecomeAvailableNotification, object: nil)
    }
    
    @objc private func protectedDataDidBecomeAvailable(_ noti: Notification) {
        onObserveProtectedDataDidBecomeAvailable?(noti)
    }
    
    @objc public func subscribeProtectedDataWillBecomeUnavailable(handler: @escaping (Notification) -> Void) {
        onObserveProtectedDataWillBecomeUnavailable = handler
        NotificationCenter.default.addObserver(self, selector: #selector(protectedDataWillBecomeUnavailable(_:)), name: UIApplication.protectedDataWillBecomeUnavailableNotification, object: nil)
    }
    
    @objc public func unsubscribeProtectedDataWillBecomeUnavailable() {
        onObserveProtectedDataWillBecomeUnavailable = nil
        NotificationCenter.default.removeObserver(self, name: UIApplication.protectedDataWillBecomeUnavailableNotification, object: nil)
    }
    
    @objc private func protectedDataWillBecomeUnavailable(_ noti: Notification) {
        onObserveProtectedDataWillBecomeUnavailable?(noti)
    }
    
    @objc public func subscribeProximityStateChange(handler: @escaping (Bool) -> Void) {
        onObserveProximityStateDidChange = handler
        // Indicates whether proximity monitoring is enabled.
        UIDevice.current.isProximityMonitoringEnabled = true
        // Posts state change notification by the proximity sensor.
        NotificationCenter.default.addObserver(self, selector: #selector(proximityStateDidChange(_:)), name: UIDevice.proximityStateDidChangeNotification, object: nil)
    }
    
    @objc public func unsubscribeProximityStateChange() {
        onObserveProximityStateDidChange = nil
        UIDevice.current.isProximityMonitoringEnabled = false
        NotificationCenter.default.removeObserver(self, name: UIDevice.proximityStateDidChangeNotification, object: nil)
    }
    
    /// The state of the proximity sensor changes.
    @objc private func proximityStateDidChange(_ noti: Notification) {
        onObserveProximityStateDidChange?(UIDevice.current.proximityState)
    }
    
    /// Unsubscribes the all of observers.
    @objc public func unsubscribeAll() {
        onObserveScreenBrightness = nil
        onObserveProtectedDataDidBecomeAvailable = nil
        onObserveProtectedDataWillBecomeUnavailable = nil
        onObserveProximityStateDidChange = nil
        UIDevice.current.isProximityMonitoringEnabled = false
        NotificationCenter.default.removeObserver(self)
    }
    
}

#endif
