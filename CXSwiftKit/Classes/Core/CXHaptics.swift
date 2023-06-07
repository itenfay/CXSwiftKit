//
//  CXHaptics.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/8/12.
//

import Foundation
#if !os(watchOS) || canImport(AudioToolbox)
import AudioToolbox

/// Some haptic feedback that works on iPhone 6 and up
/// see: http://www.mikitamanko.com/blog/2017/01/29/haptic-feedback-with-uifeedbackgenerator/
public class CXHaptics: NSObject {
    
    @objc public static func weakBoom() {
        AudioServicesPlaySystemSound(1519) // Actuate `Peek` feedback (weak boom)
    }
    
    @objc public static func strongBoom() {
        AudioServicesPlaySystemSound(1520) // Actuate `Pop` feedback (strong boom)
    }
    
    @objc public static func threeWeakBooms() {
        AudioServicesPlaySystemSound(1521) // Actuate `Nope` feedback (series of three weak booms)
    }
    
}

#endif
