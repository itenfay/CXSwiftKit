//
//  Double+Cx.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2022/11/14.
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
    public func toAudioTimeString() -> String {
        return base.cx_toAudioTimeString()
    }
    
    /// Converts the seconds to a film duration format.
    public func toFilmTimeString() -> String {
        return base.cx_toFilmTimeString()
    }
    
    /// Converts the meters to the latitude.
    public func metersToLatitude() -> Double {
        return base.cx_metersToLatitude()
    }
    
    /// Converts the meters to the longitude.
    public func metersToLongitude() -> Double {
        return base.cx_metersToLongitude()
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
    public func cx_toAudioTimeString() -> String {
        let min = Int(self / 60)
        let seconds = Int(self) % 60
        return String(format: "%02ld:%02ld", min, seconds)
    }
    
    /// Converts the seconds to a film duration format.
    public func cx_toFilmTimeString() -> String {
        let min = Int(self / 60)
        let hours = min / 60
        let seconds = Int(self) % 60
        return hours > 0
        ? String(format: "%02ld:%02ld:%02ld", hours, min, seconds)
        : String(format: "%02ld:%02ld", min, seconds)
    }
    
    /// Converts the meters to the latitude.
    public func cx_metersToLatitude() -> Double {
        return self / (6360500.0)
    }
    
    /// Converts the meters to the longitude.
    public func cx_metersToLongitude() -> Double {
        return self / (5602900.0)
    }
    
}
