//
//  SSTickerRealtimeTicker.swift
//  stocks-ios
//
//  Created by JunrenHuang on 11/1/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking
import SwiftDate

// Detail realtime
// 维护几种情况的数据：推送、下拉刷新、从组合过来的基本数据
public struct SSTickerRealtimeTicker: JSONMappable {

    public var handicapLabels = [String]()
    public var handicapValues = [String]()

    public var decimal = 2

    var json = JSON()

    public var volume = ""

    public var close = " "
    public var change = ""
    public var changeRatio = ""

    public var changeColor = UIColor.clear

    public var statusKey = ""
    public var status = ""
    public var tradeTime = ""
    
    //记录最后交易时间
    public var lastTradeTime = Date.init(timeIntervalSince1970: 0)
    
    public var needShowFA = false

    public var faStatus = NSAttributedString()
    public var faTradeTime = ""

    public var timeZone = ""

    public var utcOffset: TimeZone?

    public var avgLabel = "avgVol3M"
    public var avgLabelIndex: Int?

    public var price: String = ""
    public var oldPrice: String = ""

    public var preClose: String = ""

    public var bidList: [SSTickerTradeBidAskData]?
    public var askList: [SSTickerTradeBidAskData]?
    
    public var cleanTime: Int64?
    public var cleanDuration: Int?
    
    public var netDate: String = String.nilValue
    
    public var quoteMaker: String = ""
    
    //买卖档数量
    public var stallNum: Int = 1

    public init?(_ realtime: SSTickerRealtime?) {
        guard let realtime = realtime else {
            return nil
        }

        if realtime.changeRatio.contains("%") {
            self.close = realtime.close
            self.change = realtime.change
            self.changeRatio = realtime.changeRatio
            self.changeColor = realtime.change.color()
            return
        }

        let json: JSON = [
            "close" : realtime.close,
            "change" : realtime.change,
            "changeRatio" : realtime.changeRatio
        ]
        formatCloseValue(json)
    }

    public init?(_ json: JSON) {
        self.json = json

        formatCloseValue(json)
        
        cleanTime = json["cleanTime"] as? Int64
        cleanDuration = json["cleanDuration"] as? Int
        
        let maker: String = (json["quoteMaker"] as? String ?? "") + "(" + (json["quoteMakerAddress"] as? String ?? "") + ")"
        if maker != "()" {
            quoteMaker = maker
        }
        
        stallNum = Int(json["baNum"] as? String ?? "1") ?? 1
    }

    mutating public func setTickerType(_ type: Int, fundType: SSTickerFundType) {
        guard let tickerType = SSTickerType(rawValue: type) else {
            return
        }
        
        if tickerType == .fund && fundType == .MUTF {
            if let appNonETFData = self.json["appNonETFData"] as? JSON {
                for (key, value) in appNonETFData {
                    self.json[key] = value
                }
                if let netDate = self.json["netDate"] as? String {
                    self.netDate = netDate.ymdDate()?.monthDayFormat() ?? netDate.ymdFormat()
                }
            }
        }

        self.handicapLabels = tickerType.handicapLabels(fundType: fundType)

        //avgVol3M
        if let index = self.handicapLabels.index(where: { $0 == "avgVol3M" }) {
            self.avgLabelIndex = index
        }

        self.setupValues()
    }

    fileprivate mutating func format(key: String, data: JSON? = nil) -> String {
  
        var values = json
        if let data = data {
            values = data
        }
        let value = values[key]
        switch key {
        case "dividend":
            let div = SSFormatter.formatNumberString(value, decimal: decimal)
            let yield = SSFormatter.formatPercent(values["yield"], sign: false)
            return div + "/" + yield
        case "marketValue", "volume":
            return SSFormatter.formatBig(value)
        case "projPe":
            return SSFormatter.formatNumber(
                value,
                decimal: decimal
            )
        case "avgVol3M":
            var avg: Any?
            if let avg3M = value {
                avg = avg3M
                avgLabel = key
            } else {
                avg = values["avgVol10D"]
                avgLabel = "avgVol10D"
            }
            return SSFormatter.formatBig(avg)
        case "settlDate":
            return SSFormatter.formatString(value)
        default:
            return SSFormatter.formatNumberString(value, decimal: decimal)
        }
    }
    
    mutating public func setupValues() {
        for (i, label) in self.handicapLabels.enumerated() {
            let value = format(key: label)
            if self.handicapValues.count > i {
                self.handicapValues[i] = value
            } else {
                self.handicapValues.append(value)
            }

            if label == "volume" {
                self.volume = value
            }

            if label == "preClose" {
                self.preClose = SSFormatter.formatString(json[label])
            }
        }

        self.askList = getTradeList(list: json["askList"])
        self.bidList = getTradeList(list: json["bidList"])

        formatTimeValue()
    }

    public func getTradeList(list: Any?) -> [SSTickerTradeBidAskData]? {

        var ret = [SSTickerTradeBidAskData]()
        guard let array = list as? [JSON] else {
            return nil
        }

        for json in array {
            guard
                let price = json["price"] as? String
            else {
                continue
            }

            let volume = json["volume"] as? String ?? String.nilValue
            let row = SSTickerTradeBidAskData(price: price, volume: volume, preClose: self.preClose)
            ret.append(row)
        }
        return ret
    }

    mutating public func updateValuesWithFundInfo(_ info: SSTickerFundInfo?) {

        guard self.handicapLabels.count == self.handicapValues.count, let info = info else {
            return
        }
        for (i, label) in self.handicapLabels.enumerated() {
            if let value = info.values[label] as? String {
                self.handicapValues[i] = value
            }
        }
    }

    mutating func formatCloseValue(_ json: JSON) {
       
        if let close = json["close"] as? String {
            self.decimal = SSFormatter.getDecimal(close)
            self.price = SSFormatter.formatNumberString(close, ret: "", decimal: decimal)
        }

        self.close = SSFormatter.formatNumberString(json["close"], ret: " ", decimal: decimal)
        self.change = SSFormatter.formatSignedString(json["change"], decimal: decimal)
        self.changeRatio = SSFormatter.formatPercent(json["changeRatio"], ret: "")

        if let color = SSFormatter.getChangeColor(json["change"]) {
            self.changeColor = color
        }
    }

    mutating func formatTimeValue() {

        if let utc = json["utcOffset"] as? String {
            self.utcOffset = TimeZone(identifier: utc)
        }

        self.tradeTime = SSFormatter.formatTime(
            json["mktradeTime"],
            utcOffset: self.utcOffset
        )
        
        self.lastTradeTime = (json["mktradeTime"] as? String ?? "").gmtDate() ?? Date.init(timeIntervalSince1970: 0)

        self.timeZone = SSFormatter.formatString(json["timeZone"], ret: "")

        guard
            let s = json["status"] as? String,
            let status = SSTickerStatus(rawValue: s)
        else {
            return
        }

        self.statusKey = s
        self.status = status.i18nNormal
        let showPrice = status.needShowPrice

        guard
            showPrice,
            let faString = status.faStatus,
            let faTradeTimeString = json["faTradeTime"] as? String,
            let faTradeTime = faTradeTimeString.gmtDate(),
            let _ = json["pPrice"] as? String,
            let changeColor = SSFormatter.getChangeColor(json["pChange"])
        else {
            return
        }
        
        //为F或A或者“为B且faTradeTime>=mkTradeTime”
        guard self.statusKey == "F" || self.statusKey == "A" || (self.statusKey == "B" && faTradeTime.timeIntervalSince1970 >= self.lastTradeTime.timeIntervalSince1970) else {
            return
        }
        
        if self.statusKey != "F" && self.statusKey != "A" {
            self.statusKey = "A"
        }
        
        self.needShowFA = true

        let pPrice = SSFormatter.formatNumberString(json["pPrice"], ret: "", decimal: decimal)
        let pChange = SSFormatter.formatSignedString(json["pChange"], decimal: decimal)
        let pRatio = SSFormatter.formatPercent(json["pChRatio"], ret: "")

        let string = NSMutableAttributedString()

        let normalAttr: [String: Any] = [
            NSFontAttributeName: SSFont.t07.font,
            NSForegroundColorAttributeName: SSColor.c302.color
        ]
        let s1 = NSAttributedString(
            string: faString + ": ",
            attributes: normalAttr
        )

        let s2 = NSAttributedString(
            string: pPrice + " " + pChange + " " + pRatio,
            attributes: [
                NSFontAttributeName: SSFont.t07.digit,
                NSForegroundColorAttributeName: changeColor
            ]
        )

        let faTime = SSFormatter.formatTime(
            json["faTradeTime"],
            utcOffset: self.utcOffset,
            showMonthDay: true
        )

        let s3 = NSAttributedString(
            string: "   " + faTime + " " + self.timeZone,
            attributes: normalAttr
        )

        string.append(s1)
        string.append(s2)
        string.append(s3)

        self.faStatus = string
    }

    private mutating func formatPushClose(_ json: JSON) {
        guard
            let closeString = json["close"] as? String,
            let close = Double(closeString),
            let changeString = json["change"] as? String,
            let change = Double(changeString)
            else
        {
            return
        }
        var newJSON = json

        // 修复服务端可能漏传changeRatio的BUG
        let changeR = json["changeRatio"] as? String
        if changeR == nil && close - change != 0 {
            newJSON["changeRatio"] = String(format: "%.4f", change / (close - change))
        }
        formatCloseValue(newJSON)
    }

    mutating public func updatePushData(_ json: JSON) {
        
        let lastTradeTime = (json["mktradeTime"] as? String ?? "").gmtDate() ?? Date.init(timeIntervalSince1970: 0)
        guard lastTradeTime.timeIntervalSince1970 >= self.lastTradeTime.timeIntervalSince1970 else {
            return
        }
        self.lastTradeTime = lastTradeTime
        
        formatPushClose(json)

        let maker: String = (json["quoteMaker"] as? String ?? "") + "(" + (json["quoteMakerAddress"] as? String ?? "") + ")"
        if maker != "()" {
            quoteMaker = maker
        }
        
        // 更新时间
        let newTime = SSFormatter.formatTime(json["mktradeTime"], utcOffset: self.utcOffset, timeZone: nil)
        if newTime != self.tradeTime && newTime != "" {
            self.tradeTime = newTime
        }
        
        //handicap
        for (i, label) in self.handicapLabels.enumerated() {
            
            let labels = ["high", "low", "volume", "marketValue"]
            guard labels.contains(label) else {
                continue
            }
            let value = format(key: label, data: json)
            
            if self.handicapValues.count > i {
                if value != String.nilValue {
                    self.handicapValues[i] = value
                }
            } else {
                self.handicapValues.append(value)
            }
            
            if label == "volume" {
                if value != String.nilValue {
                    self.volume = value
                }
            }
            
            if label == "preClose" {
                if value != String.nilValue {
                    self.preClose = SSFormatter.formatString(json[label])
                }
            }
        }
        
    }
}

public class SSFormatter {
    
    public class func formatNumberString(_ string: Any?, ret: String = String.nilValue, decimal: Int = 2) -> String {
        guard let string = string as? String, let double = Double(string) else {
            return ret
        }
        return double.decimalFormat(decimal)
    }

    class func formatString(_ string: Any?, ret: String = String.nilValue) -> String {
        guard let string = string as? String else {
            return ret
        }
        return string
    }

    class func formatSignedString(_ string: Any?, decimal: Int = 2) -> String {
        let string = formatNumberString(string, ret: "", decimal: decimal)

        let replacedString = string.replacingOccurrences(of: ",", with: "")
        if let number = Double(replacedString), number > 0 {
            return "+" + string
        }

        return string
    }

    // projPe
    class func formatNumber(_ number: Any?, decimal: Int = 2) -> String {
        guard let number = number as? Double else {
            return String.nilValue
        }
        return String(format: "%.\(decimal)f", number)
    }

    // changeRatio, yield（收益率）
    class func formatPercent(_ string: Any?, ret: String = String.nilValue, sign: Bool = true) -> String {
        guard
            let string = string as? String,
            let double = Double(string)
            else {
            return ret
        }
        return double.percent(sign: sign)
    }

    // 成交量，平均成交量，市值
    class func formatBig(_ string: Any?) -> String {
        guard
            let string = string as? String,
            let double = Double(string)
            else {
                return String.nilValue
        }

        return double.volumeFormat()
    }

    class func formatTime(_ time: Any?, utcOffset: TimeZone?, timeZone: Any? = nil, showMonthDay: Bool = true) -> String {
        guard
            let time = time as? String,
            let utcOffset = utcOffset,
            let date = time.gmtDate()
            else {
                return ""
        }

        var monthDay = ""
        if showMonthDay == true {
            monthDay = StocksConfig.language.isChinese ? "MM-dd " : "MMM d, "
        }
        let dateFormat = monthDay + (StocksConfig.language.isChinese ? "ah:mm" : "h:mm a")
        let formattedDate = formatDate(
            date,
            dateFormat: dateFormat,
            timeZone: utcOffset
        )

        if let timeZone = timeZone as? String {
            return formattedDate + " " + timeZone
        } else {
            return formattedDate
        }
        //return formattedDate + " " + timeZone
    }

    // News
    // 没有返回timeZone，是沿用realtime的timeZone吗？
    class func formatTimeYMD(_ time: Any?) -> String {
        guard
            let time = time as? String,
            let date = time.gmtDate() else {
            return ""
        }
        let dateFormat = (StocksConfig.language.isChinese ? "yyyy-MM-dd" : "MMM dd, yyyy")// + " HH:mm"
        return formatDate(date, dateFormat: dateFormat)
    }

    public class func formatTimeYMDNews(_ time: Any?) -> String {
        guard
            let time = time as? String,
            let date = time.gmtDate() else {
                return ""
        }

        let current = Date()

        let timeOffset = current.timeIntervalSince(date)
        if timeOffset > 24 * 3600 {

            let dateFormat: String
            if timeOffset < 24 * 3600 * 365 {
                dateFormat = (StocksConfig.language.isChinese ? "MM-dd" : "MMM dd")
            } else {
                dateFormat = (StocksConfig.language.isChinese ? "yyyy-MM-dd" : "MMM dd, yyyy")
            }
            return formatDate(date, dateFormat: dateFormat)
        } else {
            do {

                let region = Region(
                    tz: TimeZone.current,
                    cal: CalendarName.current.calendar, 
                    loc: StocksConfig.language.newsLocale
                )

                return try date.colloquial(to: current, in: region, max: 1).colloquial
            } catch {
                return ""
            }
        }
    }

    class func getDecimal(_ string: String) -> Int {
        let components = string.components(separatedBy: ".")
        if components.count < 2 {
            return 2
        }
        return components[1].characters.count
    }

    class func formatDate(_ date: Date, dateFormat: String, timeZone: TimeZone? = nil) -> String {
        //国际化
        let formatter = normalDateFormatter
        if let timeZone = timeZone {
            formatter.timeZone = timeZone
        } else {
            formatter.timeZone = TimeZone.current
        }
        formatter.locale = StocksConfig.language.locale
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }

    class func getChangeColor(_ change: Any?) -> UIColor? {
        guard let change = change as? String, let value = Double(change) else {
            return nil
        }

        return value.color()
    }

}

public struct SSTickerTradeDetail: JSONMappable {
    public let deal: String
    public let volume: String
    public let date: Date
    public var tradeTime: String
    public var priceColor = StocksConfig.appearance.colorScheme.plainTextColor

    public init?(_ json: JSON) {
        guard
            let deal = json["deal"] as? String,
            let tradeTime = json["tradeTime"] as? String,
            let date = tradeTime.gmtDate(),
            let volume = json["volume"] as? String
        else {
            return nil
        }

        self.deal = deal
        self.tradeTime = tradeTime
        self.date = date
        self.volume = volume.volumeFormat(sign: false)
    }

    public mutating func format(timeZone: TimeZone?, preClose: String) {

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if let timeZone = timeZone {
            formatter.timeZone = timeZone
        }
        self.tradeTime = formatter.string(from: date)

        if let preClose = Double(preClose), let price = Double(deal) {
            priceColor = (price - preClose).color()
        }
    }
}

public class SSTickerTradeBidAskData {
    public let price: String
    public let volume: String
    public let priceColor: UIColor
    public var volumeValue: Double = 0
    public init(price: String, volume: String, preClose: String) {
        self.price = price.decimalFormat()
        
        if let volume = Double(volume) {
            self.volume = volume.volumeFormat()
            self.volumeValue = volume
        } else {
            self.volume = volume
        }

        if
            let price = Double(price), 
            let preClose = Double(preClose)
        {
            priceColor = (price - preClose).color()
        } else {
            priceColor = StocksConfig.appearance.colorScheme.plainTextColor
        }
    }
}

private let normalDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    return formatter
}()
