//
//  Int+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

import Foundation

extension Int: CXSwiftBaseCompatible {}

public extension CXSwiftBase where T == Int {
    
    func secondsAsTimeFormat() -> String {
        let formatter = DateComponentsFormatter.init()
        /// .dropMiddle(0d 0h 0m 0s)
        formatter.zeroFormattingBehavior = .dropMiddle
        
        //NSCalendar.Unit(rawValue: NSCalendar.Unit.day.rawValue | NSCalendar.Unit.hour.rawValue | NSCalendar.Unit.minute.rawValue | NSCalendar.Unit.second.rawValue)
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        
        formatter.unitsStyle = DateComponentsFormatter.UnitsStyle.abbreviated
        
        /// 1d 1h 1m 1s
        var resultStr = formatter.string(from: TimeInterval(self.base)) ?? ""
        
        /// Handle according to your own needs.
        resultStr = resultStr.replacingOccurrences(of: "d", with: "天", options: .literal, range: nil)
        resultStr = resultStr.replacingOccurrences(of: "h", with: "小时", options: .literal, range: nil)
        resultStr = resultStr.replacingOccurrences(of: "m", with: "分", options: .literal, range: nil)
        resultStr = resultStr.replacingOccurrences(of: "s", with: "秒", options: .literal, range: nil)
        
        return resultStr
    }
    
}
