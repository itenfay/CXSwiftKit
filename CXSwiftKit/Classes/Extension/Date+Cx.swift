//
//  Date+Cx.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2022/11/14.
//

import Foundation

extension Date: CXSwiftBaseCompatible {}

extension CXSwiftBase where T == Date {
    
    public func dateFromGMT() -> Date {
        return base.cx_dateFromGMT()
    }
    
    /// Return a timestamp of the date.
    public var timestamp: Double {
        return base.cx_timestamp
    }
    
    /// Return a tuple that contains the components of chinese lunar.
    public var chineseLunarComponents: (year: String, month: String, day: String, chineseZodiac: String) {
        return base.cx_chineseLunarComponents
    }
    
    /// Return the year of chinese lunar.
    public var chineseLunarYear: String {
        return base.cx_chineseLunarYear
    }
    
    /// Return the month of chinese lunar.
    public var chineseLunarMonth: String {
        return base.cx_chineseLunarMonth
    }
    
    /// Return the day of chinese lunar.
    public var chineseLunarDay: String {
        return base.cx_chineseLunarDay
    }
    
    /// Return the chinese zodiac of chinese lunar.
    public var chineseZodiac: String {
        return base.cx_chineseZodiac
    }
    
    /// Return a string representation of date, default format of the date is "yyyy-MM-dd HH:mm:ss".
    public func dateString(_ dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        return base.cx_dateString(dateFormat)
    }
    
    /// Return a string representation of date, e.g.: 2023-06-01.
    public func dayDateString() -> String {
        return base.cx_dayDateString()
    }
    
    /// Return a string representation of date, e.g.: 2023.06.01.
    public func dotDateString() -> String {
        return base.cx_dotDateString()
    }
    
}

extension Date {
    
    /// The current date between the time zone and Greenwich Mean Time.
    public func cx_dateFromGMT() -> Date {
        let seconds = TimeZone.current.secondsFromGMT(for: self)
        return self.addingTimeInterval(TimeInterval(seconds))
    }
    
    /// Return a timestamp of the date.
    public var cx_timestamp: Double {
        return self.timeIntervalSince1970
    }
    
    /// Return a tuple that contains the components of chinese lunar.
    public var cx_chineseLunarComponents: (year: String, month: String, day: String, chineseZodiac: String) {
        let calendar = Calendar(identifier: .chinese)
        let chineseYears = ["甲子", "乙丑", "丙寅", "丁卯", "戊辰", "己巳", "庚午", "辛未", "壬申", "癸酉", "甲戌", "乙亥", "丙子", "丁丑", "戊寅", "己卯", "庚辰", "辛己", "壬午", "癸未", "甲申", "乙酉", "丙戌", "丁亥", "戊子", "己丑", "庚寅", "辛卯", "壬辰", "癸巳", "甲午", "乙未", "丙申", "丁酉", "戊戌", "己亥", "庚子", "辛丑", "壬寅", "癸丑", "甲辰", "乙巳", "丙午", "丁未", "戊申", "己酉", "庚戌", "辛亥", "壬子", "癸丑", "甲寅", "乙卯", "丙辰", "丁巳", "戊午", "己未", "庚申", "辛酉", "壬戌", "癸亥"]
        let chineseMonths = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "冬月", "腊月"]
        let chineseDays = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十", "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        let _year = dateComponents.year ?? 0
        let _month = dateComponents.month ?? 0
        let _day = dateComponents.day ?? 0
        guard _year > 0, _month > 0, _day > 0 else {
            return ("", "", "", "")
        }
        let yearString = chineseYears[_year - 1]
        var _chineseZodiac: String = ""
        if      yearString.hasSuffix("子") { _chineseZodiac = "鼠" }
        else if yearString.hasSuffix("丑") { _chineseZodiac = "牛" }
        else if yearString.hasSuffix("寅") { _chineseZodiac = "虎" }
        else if yearString.hasSuffix("卯") { _chineseZodiac = "兔" }
        else if yearString.hasSuffix("辰") { _chineseZodiac = "龙" }
        else if yearString.hasSuffix("巳") { _chineseZodiac = "蛇" }
        else if yearString.hasSuffix("午") { _chineseZodiac = "马" }
        else if yearString.hasSuffix("未") { _chineseZodiac = "羊" }
        else if yearString.hasSuffix("申") { _chineseZodiac = "猴" }
        else if yearString.hasSuffix("酉") { _chineseZodiac = "鸡" }
        else if yearString.hasSuffix("戌") { _chineseZodiac = "狗" }
        else if yearString.hasSuffix("亥") { _chineseZodiac = "猪" }
        return (yearString, chineseMonths[_month - 1], chineseDays[_day - 1], _chineseZodiac)
    }
    
    /// Return the year of chinese lunar.
    public var cx_chineseLunarYear: String {
        return self.cx_chineseLunarComponents.year
    }
    
    /// Return the month of chinese lunar.
    public var cx_chineseLunarMonth: String {
        return self.cx_chineseLunarComponents.month
    }
    
    /// Return the day of chinese lunar.
    public var cx_chineseLunarDay: String {
        return self.cx_chineseLunarComponents.day
    }
    
    /// Return the chinese zodiac of chinese lunar.
    public var cx_chineseZodiac: String {
        return self.cx_chineseLunarComponents.chineseZodiac
    }
    
    /// Return a string representation of date, default format of the date is "yyyy-MM-dd HH:mm:ss".
    public func cx_dateString(_ dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    /// Return a string representation of date, e.g.: 2023-06-01.
    public func cx_dayDateString() -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    /// Return a string representation of date, e.g.: 2023.06.01.
    public func cx_dotDateString() -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: self)
    }
    
}
