//
//  StringExtensions.swift
//  stocks-ios
//
//  Created by Eason Lee on 06/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import libPhoneNumber_iOS


extension String {

    public static let nilValue: String = "--"

    public subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }

    public func toInt64() -> [Int64] {
        return components(separatedBy: ",").flatMap({ Int64($0) })
    }

    public func toInt() -> [Int] {
        return components(separatedBy: ",").flatMap({ Int($0) })
    }
    
    public func toDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                return nil
            }
        }
        return nil
    }

    public func width(font: UIFont) -> CGFloat {
        return (self as NSString).size(attributes: [NSFontAttributeName: font]).width
    }
    
    public func isEmptyOrNil() -> Bool {
        return self.isEmpty || self == ""
    }

    public func md5() -> String {
        if let data = self.data(using: String.Encoding.utf8) {
            return NSData(data: data).md5String()// .md5String()
        }
        return ""
    }

    public func decimalFormat() -> String {
        guard let double = Double(self) else {
            return self
        }

        let components = self.components(separatedBy: ".")

        var decimal = 2
        if components.count > 1 {
            decimal = components[1].characters.count
        }

        return double.decimalFormat(decimal)
    }

    public func volumeFormat(sign: Bool = true) -> String {
        guard let double = Double(self) else {
            return self
        }

        return double.volumeFormat(sign: sign)
    }

    public func financeFormat() -> String {
        guard let double = Double(self) else {
            return self
        }

        return double.financeFormat()
    }

    public func seasonFormat() -> String {
        guard let date = self.gmtDate() else {
                return ""
        }
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy/MM"
        return fmt.string(from: date)
    }
    
    
    
    public func yearFormat() -> String {
        guard let date = self.gmtDate() else {
            return ""
        }
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy"
        return fmt.string(from: date)
    }

    public func currencyFormat(_ currency: String) -> String {
        guard self != "" else {
            return self
        }

        let first = self[self.startIndex]

        switch first {
        case "+", "-":
            // 币种格式保持为 “￥+100.00”
            return currency + self
//            let index = self.index(self.startIndex, offsetBy: 1)
//            return self.replacingCharacters(in: self.startIndex..<index, with: String(first) + currency)
        default:
            return self
        }
    }

    public func ymdFormat(_ timeZone: TimeZone? = nil) -> String {
        guard let date = self.gmtDate() else {
            return ""
        }

        let formatter = DateFormatter()
        if let timeZone = timeZone {
            formatter.timeZone = timeZone
        } else {
            formatter.timeZone = TimeZone.current
        }
        formatter.locale = StocksConfig.language.locale
        formatter.dateFormat = (StocksConfig.language.isChinese ? "yyyy-MM-dd" : "MMM dd, yyyy")
        return formatter.string(from: date)
    }
    
    public func ymFormat(_ timeZone: TimeZone? = nil) -> String {
        guard let date = self.gmtDate() else {
            return ""
        }
        
        let formatter = DateFormatter()
        if let timeZone = timeZone {
            formatter.timeZone = timeZone
        } else {
            formatter.timeZone = TimeZone.current
        }
        formatter.locale = StocksConfig.language.locale
        formatter.dateFormat = (StocksConfig.language.isChinese ? "yyyy-MM" : "MMM, yyyy")
        return formatter.string(from: date)
    }

    public func firstCharacter() -> String {
        let mutStr = NSMutableString(string: self)
        // 去除带声调的拼音
        CFStringTransform(mutStr, nil, kCFStringTransformMandarinLatin, false)
        // 去除不带声调的拼音
        CFStringTransform(mutStr, nil, kCFStringTransformStripDiacritics, false)
        let pinyin = mutStr.capitalized as NSString

        return pinyin.substring(to: 1)
    }

    public func color() -> UIColor {

        guard self != "" else {
            return SSColor.c301.color
        }

        let first = self[self.startIndex]

        switch first {
        case "+":
            return SSColor.riseText.color
        case "-":
            return SSColor.fallText.color
        default:
            return SSColor.c301.color
        }
    }
    
    public func isPhone(_ isoCode: String) -> Bool {
        let phoneUtil = NBPhoneNumberUtil()
        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(self, defaultRegion: isoCode)
            let type = NBPhoneNumberUtil.sharedInstance().getNumberType(phoneNumber)
            return type == .MOBILE || type == .FIXED_LINE_OR_MOBILE || type == .PAGER
        } catch _ as NSError {
            return false
        }
    }
    
    public func isEmail() -> Bool {
        
        let regex = "^[A-Za-z0-9!#$%&'+/=?^_`{|}~-]+(.[A-Za-z0-9!#$%&'+/=?^_`{|}~-]+)*@([A-Za-z0-9]+(?:-[A-Za-z0-9]+)?.)+[A-Za-z0-9]+(-[A-Za-z0-9]+)?$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: self)
    }
    
    public func isPassword() -> Bool {
        
        if self.characters.count < 6 || self.characters.count > 20 {
            return false
        }
        
        let regex = "\\d+[a-zA-Z]+[\\da-zA-Z]*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        let regex2 = "[a-zA-Z]+\\d+[\\da-zA-Z]*"
        let predicate2 = NSPredicate(format: "SELF MATCHES %@", regex2)
        
        return predicate.evaluate(with: self) || predicate2.evaluate(with: self)
    }
    
    public func matches(_ regex: String!) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = self as NSString
            let results = regex.matches(in: self,
                                        options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substring(with: $0.range) }
        } catch let error as NSError {
            SSLog("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    public func json() -> [String: Any]? {

        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            return nil
        }
    }
    
    public func jsonArray() -> [[String: Any]]? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
        } catch {
            return nil
        }
    }
    
    public func ratioFormat(_ showSign: Bool = false) -> String {
        return self.double().ratioFormat(showSign)
    }
    
    public func double() -> Double {
        let charset = CharacterSet(charactersIn: ",+%")
        let string = self.trimmingCharacters(in: charset).replacingOccurrences(of: ",", with: "")
        
        guard let double = Double(string) else {
            return 0
        }
        return double
    }
    
    public func moneyFormat(_ flag: Bool? = false) -> String {
        
        let moneys = self.components(separatedBy: ".")
        if moneys.count == 2 {
            let fractionNum = moneys[1].characters.count
            return self.digitalFormat(flag, minFraction: fractionNum, maxFraction: fractionNum)
        } else if moneys.count == 1 {
            return self.digitalFormat(flag, minFraction: 0, maxFraction: 0)
        }
        return self.digitalFormat(flag)
        
    }
    
    public func digitalFormat(_ flag: Bool? = false, minFraction: Int? = nil, maxFraction: Int? = nil) -> String {
        
        let number = self.double()
        return number.digitalFormat(flag, minFraction: minFraction, maxFraction: maxFraction)
    }
    
    public func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    public func ss_sign() -> String {
        if self.double() > 0 {
            return "+\(self)"
        }
        return self
    }
    
    public func ss_percent() -> String {
        
        if self.characters.count > 0 {
            return "\(self)%"
        }
        
        return self
    }
    
    public func ss_signPercent() -> String {
        return self.ss_sign().ss_percent()
    }
    
    public func toData() -> Data? {
        return self.data(using: String.Encoding.utf8)
    }
    
    public var ss_textColor: UIColor {
        return self.double().ss_textColor
    }
    
    public func getStringSize(maxSize: CGSize, font: UIFont) -> CGSize {
        if let cString = self.cString(using: String.Encoding.utf8),
           let text = NSString(cString: cString, encoding: String.Encoding.utf8.rawValue) {
            return text.size(for: font, size: maxSize, mode: NSLineBreakMode.byWordWrapping)
        }
        return CGSize.zero
    }
    
    public func timeAgo() -> String {
        
        let date = self.gmtDate() ?? Date()
        let now = Date()
        
        if date.timeIntervalSince1970 > now.timeIntervalSince1970 {
            return i18n("date.format.just_now")
        }
        
        let minute = Calendar.current.dateComponents([.minute], from: date, to: now).minute ?? 0
        
        if minute < 1 {
            return i18n("date.format.just_now")
        } else if minute == 1 {
            return i18n("date.format.minute_ago")
        } else if minute < 60 {
            return "\(minute)\(i18n("date.format.minutes_ago"))"
        } else if minute < 120 {
            return i18n("date.format.hour_ago")
        } else if minute < 1440 {
            return "\(minute/60)\(i18n("date.format.hours_ago"))"
        }
        
        let day = Calendar.current.dateComponents([.day], from: date, to: now).day ?? 0
        
        if day == 1 {
            return i18n("date.format.day_ago")
        } else if day <= 3 {
            return "\(day)\(i18n("date.format.days_ago"))"
        }
        
        let year = Calendar.current.dateComponents([.year], from: date, to: now).year ?? 0
        
        if year == 0 {
            return date.monthDayFormat()
        } else {
            return date.ymdFormat()
        }
        
    }
    
    public func bigNumberFormat(_ decimals: Int = 2, isInteger: Bool = false, power: Int = 0, sign: Bool = false, noFormatBit: Int = 0) -> String {
        return self.double().bigNumberFormat(decimals, isInteger: isInteger, power: power, sign: sign, noFormatBit: noFormatBit)
    }
    
    public func isURL() -> Bool {
        let expression = try? NSRegularExpression(pattern: "(https?|ftp|file|webull|wbtrade)://[-A-Z0-9+&@#/%?=~_|!:,.;]*[-A-Z0-9+&@#/%=~_|]", options: .caseInsensitive)
        let numberOfMatchURL = expression?.numberOfMatches(in: self, options: .anchored, range: NSRange(location: 0, length: self.characters.count))
        if let _ = numberOfMatchURL {
            return numberOfMatchURL! > 0
        } else {
            return false
        }
    }
    
    public func toURL() -> URL? {
        guard self.isURL() else {
            return nil
        }
        var result = URL(string: self)
        if result == nil {
            if let encodestr = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                result = URL(string: encodestr)
            }
        }
        return result
    }
    
    /// 用于交易数量，如果是小数则需要保留小数
    public func quantityFormat() -> String {
        let doubleValue = self.double()
        if abs(doubleValue - Double(Int(doubleValue))).notEqualZero {
            return self.numberFormat(-1)
        }
        return self.numberFormat(0)
    }
    
    /**
     yyyy-MM-dd HH:mm:ss
     
     - returns: yyyy-MM-dd HH:mm:ss zzz
     */
    public func tradeFullFormat() -> String {
        if StocksConfig.language == .english {
            let df = Foundation.DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
            df.locale = Locale(identifier: "en_US")
            if let timeZoneAbbreviation = self.components(separatedBy: " ").last, let timeZone = TimeZone(abbreviation: timeZoneAbbreviation) {
                df.timeZone = timeZone
                if let date = df.date(from: self) {
                    df.dateFormat = "MMM dd YYYY HH:mm:ss zzz"
                    return df.string(from: date)
                }
            }
        }
        return self
    }
    
    public func tradeSplitFormat() -> (date: String, time: String) {
        if StocksConfig.language == .english {
            let df = Foundation.DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
            df.locale = Locale(identifier: "en_US")
            if let timeZoneAbbreviation = self.components(separatedBy: " ").last, let timeZone = TimeZone(abbreviation: timeZoneAbbreviation) {
                df.timeZone = timeZone
                if let date = df.date(from: self) {
                    df.dateFormat = "MMM dd YYYY"
                    let dateString = df.string(from: date)
                    df.dateFormat = "HH:mm:ss zzz"
                    let timeString = df.string(from: date)
                    return (dateString, timeString)
                }
            }
        }
        
        let comp = self.components(separatedBy: " ")
        
        if comp.count >= 2 {
            return (comp[0], comp[1])
        }
        
        return ("--", "--")
    }
    
    /// precision传-1代表小数部分原本有几位就格式化为几位
    public func numberFormat(_ precision: Int = 2, power: Int = 0) -> String {
        if precision == -1 {
            let arr = self.components(separatedBy: ".")
            if arr.count > 1 {
                return self.double().numberFormat(arr[1].characters.count, power: power)
            }
        }
        return self.double().numberFormat(precision, power: power)
    }

    /// 该方法非常耗cpu，容易造成iphone5甚至6的卡顿，需要放在后台线程中完成，完成后在主线程刷新
    public func ss_latinize() -> String {
        let str = NSMutableString(string: self) as CFMutableString
        
        CFStringTransform(str, nil, kCFStringTransformToLatin, false)
        CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false)
        
        return (str as NSString) as String
    }
}
