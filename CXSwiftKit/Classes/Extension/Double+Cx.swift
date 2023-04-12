//
//  Double+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

import Foundation

extension Double: CXSwiftBaseCompatible {}

extension CXSwiftBase where T == Double {
    
    /// Rounds the double to decimal places value.
    public func roundTo(places value: Int) -> Double {
        return base.cx_roundTo(places: value)
    }
    
    public func interceptDecimal(_ number: Int) -> String {
        return base.cx_interceptDecimal(number)
    }
    
    /// Converts the seconds to a audio duration format.
    public func toAudioDurationFormat() -> String {
        return base.cx_toAudioDurationFormat()
    }
    
    /// Converts the seconds to a film duration format.
    public func toFilmDurationFormat() -> String {
        return base.cx_toFilmDurationFormat()
    }
    
}

extension Double {
    
    /// Rounds the double to decimal places value.
    public func cx_roundTo(places value: Int) -> Double {
        let divisor = pow(10.0, Double(value))
        return (self * divisor).rounded() / divisor
    }
    
    public func cx_interceptDecimal(_ number: Int) -> String {
        let format = NumberFormatter()
        format.numberStyle = .decimal
        format.minimumFractionDigits = 0 // The minimum number of digits.
        format.maximumFractionDigits = number // The maximum number of digits.
        format.formatterBehavior = .default
        format.roundingMode = .down // Round towards zero.
        return format.string(from: NSNumber(value: self)) ?? ""
    }
    
    /// Converts the seconds to a audio duration format.
    public func cx_toAudioDurationFormat() -> String {
        let min = Int(self / 60)
        let seconds = Int(self) % 60
        return String(format: "%02ld:%02ld", min, seconds)
    }
    
    /// Converts the seconds to a film duration format.
    public func cx_toFilmDurationFormat() -> String {
        let min = Int(self / 60)
        let hours = min / 60
        let seconds = Int(self) % 60
        return hours > 0
        ? String(format: "%02ld:%02ld:%02ld", hours, min, seconds)
        : String(format: "%02ld:%02ld", min, seconds)
    }
    
}
