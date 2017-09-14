//
//  DateExtensions.swift
//  stocks-ios
//
//  Created by Eason Lee on 07/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

private let gmtDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}()

extension Date {

    public var gmtFormat: String {
        return gmtDateFormatter.string(from: self)
    }

    public static func staticFormatter(format: String) -> DateFormatter {

        let threadDictionary = Thread.current.threadDictionary

        if let fmt = threadDictionary[format] as? Foundation.DateFormatter {
            fmt.timeZone = TimeZone.autoupdatingCurrent
            return fmt
        } else {
            let fmt = Foundation.DateFormatter()
            fmt.dateFormat = format
            fmt.timeZone = TimeZone.autoupdatingCurrent
            fmt.locale = Locale(identifier: "en_US")

            threadDictionary[format] = fmt

            return fmt
        }
    }
    
    public func fullFormat() -> String {
        return Date.ss_formatter(.full).string(from: self)
    }

    public func timeFormat() -> String {
        let fmt = Date.staticFormatter(format:"yyyy-MM-dd'T'HH:mm:ssZ")
        return fmt.string(from: self)
    }
    
    public func seasonFormat() -> String {
        return Date.ss_formatter(.season).string(from: self).replacingOccurrences(of: "-", with: "Q", options: [], range: nil)
    }

    public func ymdFormat(_ utcOffset: String? = nil) -> String {
        if let utc = utcOffset, let timezone = TimeZone(identifier: utc) {
            let formatter = DateFormatter()
            if StocksConfig.language.isChinese {
                formatter.dateFormat = "yyyy-MM-dd"
            } else {
                formatter.dateFormat = "MMM dd,yyyy"
                formatter.locale = Locale(identifier: "en_US")
            }
            formatter.timeZone = timezone
            return formatter.string(from: self)
        }
        let fmt = Date.staticFormatter(format:"yyyy-MM-dd")
        return fmt.string(from: self)
    }
    
    public func HMFormat() -> String {
        let fmt = Date.staticFormatter(format:"HH:mm")
        return fmt.string(from: self)
    }
    
    public func hourMinuteFormat() -> String {
        return Date.ss_formatter(.hourMinute).string(from: self)
    }

    public func ymdLocalFormat() -> String {

        let formatter = DateFormatter()

        formatter.locale = StocksConfig.language.locale
        formatter.dateFormat = (StocksConfig.language.isChinese ? "yyyy-MM-dd" : "MMM dd, yyyy")

        return formatter.string(from: self)
    }

    public func financeLocalFormat() -> String {

        let formatter = DateFormatter()

        formatter.locale = StocksConfig.language.locale
        formatter.dateFormat = (StocksConfig.language.isChinese ? "yyyy-MM-dd" : "MM/dd/yyyy")

        return formatter.string(from: self)
    }
    
    //计算间隔 "x年x天"
    static public func yearDayFormatter(start: Date, end: Date) -> String {
        
        let calendar: Calendar = Calendar.current
        let unitFlags: Set<Calendar.Component> = [.year, .day]
        let component: DateComponents = calendar.dateComponents(unitFlags, from: start, to: end)
        //        log.debug("年是：\(component.year)  日: \(component.day)")
        let years: Int = component.year ?? 0
        let days: Int = component.day ?? 0
        var compString: String = ""
        if years == 0 {
            if days < 2 {
                compString = i18n("date.format.duration.day", arguments: ["\(days)"])
            }
            
            compString = i18n("date.format.duration.days", arguments: ["\(days)"])
        } else {
            var string = ""
            if years < 2 {
                string = string + i18n("date.format.duration.year", arguments: ["\(years)"])
            } else {
                string = string + i18n("date.format.duration.years", arguments: ["\(years)"])
            }
            if days < 2 {
                string = string + " " + i18n("date.format.duration.day", arguments: ["\(days)"])
            } else if days > 0 {
                string = string + " " + i18n("date.format.duration.days", arguments: ["\(days)"])
            }
            compString = string
        }
        
        return compString
    }
    
    public func monthDayFormat() -> String {
        return Date.ss_formatter(.monthDay).string(from: self)
    }
    
    public enum SSformatterKey: Int {
        case timezone
        case day
        case gmt
        case monthDay
        case yearMonth
        case hourMinute
        case hourMinuteSecond
        case time
        case full
        case ymd
        case season
        case trade
        case tradeFull
    }
    
    static public func static_formatter(format: String) -> Foundation.DateFormatter {
        
        let threadDictionary = Thread.current.threadDictionary
        
        if let fmt = threadDictionary[format] as? Foundation.DateFormatter {
            
            return fmt
        } else {
            let fmt = Foundation.DateFormatter()
            fmt.dateFormat = format
            fmt.timeZone = TimeZone.autoupdatingCurrent
            fmt.locale = Locale(identifier: "en_US")
            
            threadDictionary[format] = fmt
            
            return fmt
        }
    }
    
    static public func ss_formatter(_ formatterType: SSformatterKey, languageRelative: Bool = true) -> Foundation.DateFormatter {
        
        var fmt: Foundation.DateFormatter!
        
        let needEnglishFormat = languageRelative && (!StocksConfig.language.isChinese)
        
        switch formatterType {
        case .day:
            fmt = Date.static_formatter(format:"dd")
        case .hourMinute:
            fmt = Date.static_formatter(format:"HH:mm")
        case .hourMinuteSecond:
            fmt = Date.static_formatter(format:"HH:mm:ss")
        case .time:
            fmt = Date.static_formatter(format:"yyyy-MM-dd'T'HH:mm:ssZ")
        case .gmt:
            fmt = Date.static_formatter(format:"yyyy-MM-dd'T'HH:mm:ss.SSSZ")
        case .monthDay:
            if needEnglishFormat {
                fmt = Date.static_formatter(format:"MMM dd")
            } else {
                fmt = Date.static_formatter(format:"MM-dd")
            }
        case .yearMonth:
            if needEnglishFormat {
                fmt = Date.static_formatter(format:"MMM YYYY")
            } else {
                fmt = Date.static_formatter(format:"yyyy-MM")
            }
        case .timezone:
            if needEnglishFormat {
                fmt = Date.static_formatter(format:"MMM dd HH:mm")
            } else {
                fmt = Date.static_formatter(format:"MM-dd HH:mm")
            }
        case .full:
            if needEnglishFormat {
                fmt = Date.static_formatter(format:"MMM dd YYYY HH:mm:ss")
            } else {
                fmt = Date.static_formatter(format:"yyyy-MM-dd HH:mm:ss")
            }
        case .ymd:
            if needEnglishFormat {
                fmt = Date.static_formatter(format:"MMM dd YYYY")
            } else {
                fmt = Date.static_formatter(format:"yyyy-MM-dd")
            }
        case .season:
            fmt = Date.static_formatter(format:"yyyy-q")
        case .trade:
            fmt = Date.static_formatter(format:"MM-dd hh:mm:ss")
        case .tradeFull:
            if let timezone = TimeZone(abbreviation: "EST") {
                fmt.timeZone = timezone
            }
            if needEnglishFormat {
                fmt = Date.static_formatter(format:"MMM dd YYYY HH:mm:ss zzz")
            } else {
                fmt = Date.static_formatter(format:"yyyy-MM-dd HH:mm:ss zzz")
            }
            //        default:
            //            break
        }
        
        return fmt
    }
}

extension String {

    public func gmtDate() -> Date? {
        return gmtDateFormatter.date(from: self)
    }

    public func ymdDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self)
    }
}
