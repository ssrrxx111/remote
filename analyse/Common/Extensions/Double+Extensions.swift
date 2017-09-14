//
//  DoubleExtensions.swift
//  stocks-ios
//
//  Created by JunrenHuang on 13/1/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

public let ss_eps = 0.000001

extension Double {

    static var formatter: NumberFormatter = {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    // minimumFractionDigits会变
    static var decimalFormatter: NumberFormatter = {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    public func decimalFormat(_ decimal: Int = 2) -> String {
        Double.decimalFormatter.minimumFractionDigits = decimal
        Double.decimalFormatter.maximumFractionDigits = decimal

        if let string = Double.decimalFormatter.string(from: NSNumber(value: self)) {
            return string
        }
        return String(format: "%f", self)
    }

    public func percent(sign: Bool = true) -> String {
        let sign = (self > 0 && sign) ? "+" : ""
        return String(format: "%@%@%%", sign, (self * 100).decimalFormat())
    }

    public func volumeFormat(sign: Bool) -> String {
        let sign = (self > 0 && sign) ? "+" : ""

        return sign + self.volumeFormat()
    }

    public func volumeFormat() -> String {
        var t = self
        var index = 0
        
        var units: [String] = []
        switch StocksConfig.language {
        case .chineseSimplified:
            units = ["", "万", "亿", "兆"]
        case .chineseTraditional:
            units = ["", "萬", "億", "兆"]
        default:
            units = ["", "K", "M", "B", "T"]
        }

        if StocksConfig.language.isChinese {
            while t >= 100000 || t <= -100000 {
                t /= 10000
                index += 1
            }
        } else {
            while t >= 10000 || t <= -10000 {
                t /= 1000
                index += 1
            }
        }
        
        Double.decimalFormatter.minimumFractionDigits = 0
        Double.decimalFormatter.maximumFractionDigits = 2

        if let string = Double.decimalFormatter.string(from: NSNumber(value: t)), units.count > index {
            
            return string + units[index]
        }
        return String(format: "%f", self)

    }

    public func financeFormat() -> String {
        var t = self
        var index = 0
        let units = ["", "K", "M", "B", "T"]

        if t < 100 && t > -100 {
            return t.decimalFormat()
        }

        while t >= 100000 || t <= -100000 {
            t /= 1000
            index += 1
        }

        return t.decimalFormat(0) + units[index]
    }

    public func financeChartFormat(unit: String) -> String {

        var t = self

        let units = ["", "K", "M", "B", "T"]

        guard let unitIndex = units.index(of: unit) else {
            return String(format: "%.0f", t)
        }

        let base: Double = 1000//t < 0 ? -1000 :
        t /= pow(base, Double(unitIndex))

        if t < 100 && t > -100 {
            return t.decimalFormat()
        }

        return String(format: "%.0f", t)
    }

    public func color() -> UIColor {

        if self > 0 {
            return SSColor.riseText.color
        } else if fabs(self) < ss_eps {
            return SSColor.c301.color
        }
        return SSColor.fallText.color
    }
    
    public func ratioFormat(_ showSign: Bool = true, decimals: Int = 2) -> String {
        if showSign {
            return self.numberFormat(decimals, power: -2).ss_signPercent()
        } else {
            return self.numberFormat(decimals, power: -2).ss_percent()
        }
    }
    
    /// precision传-1代表小数部分原本有几位就格式化为几位
    public func numberFormat(_ precision: Int = 2, power: Int = 0) -> String {
        if precision == -1 {
            var precisionResult = 0
            let doubleString = "\(self)"
            let precisionComponents = doubleString.components(separatedBy: ".")
            if precisionComponents.count > 1, let precisionString = precisionComponents.last {
                precisionResult = precisionString.characters.count
            }
            
            return String(format: "%.\(precisionResult)f", self / pow(10.0, Double(power))).moneyFormat(false)
        }
        return String(format: "%.\(precision)f", self / pow(10.0, Double(power))).moneyFormat(false)
    }
    
    public func digitalFormat(_ flag: Bool? = false, minFraction: Int? = nil, maxFraction: Int? = nil) -> String {
        
        let formatter = Double.ss_digitalFormat
        if let min = minFraction {
            formatter.minimumFractionDigits = min
        }
        if let max = maxFraction {
            formatter.maximumFractionDigits = max
        }
        
        if let formatString = formatter.string(from: NSNumber(value: self)) {
            if flag! && self > 0.0 {
                return "+\(formatString.trim())"
            }
            return formatString.trim()
        }
        
        return "-"
    }
    
    public static var ss_digitalFormat: NumberFormatter = {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.currencySymbol = ""
        formatter.locale = Locale(identifier: "en_US")
        
        return formatter
    }()
    
    public var ss_textColor: UIColor {
        
        get {
            switch self {
            case _ where fabs(self).isEqualZero:
                return SSColor.c301.color
            case _ where self > 0.0:
                return SSColor.riseText.color
            case _ where self < 0.0:
                return SSColor.fallText.color
            default:
                return SSColor.c301.color
            }
        }
    }

    public var isEqualZero: Bool {
        return !self.isNaN && (self < Double.ulpOfOne )
    }
    
    public var notEqualZero: Bool {
        return !self.isEqualZero
    }

    public func shareNumberFormat(_ decimals: Int = 2,
                                  isInteger: Bool = false,
                                  power: Int = 0,
                                  sign: Bool = false,
                                  noFormatBit: Int = 0) -> String {
        var result = ""
        let number = self / pow(10.0, Double(power))
        let signFlag = number > 0 && sign ? "+" : ""
        let abs = fabs(number)
        if abs < pow(10.0, Double(noFormatBit)) {
            return signFlag + String(format: "%.\(isInteger ? 0 : decimals)f", number).moneyFormat()
        }

        if StocksConfig.language == .chineseSimplified {
            if abs < 1.0e5 {
                result = String(format: "%.\(isInteger ? 0 : decimals)f", number).moneyFormat()
            } else if abs < 1.0e9 {
                result = String(format: "%.\(decimals)f", number / 1.0e4).moneyFormat() + "万"
            } else if abs < 1.0e13 {
                result = String(format: "%.\(decimals)f", number / 1.0e8).moneyFormat() + "亿"
            } else {
                result = String(format: "%.\(decimals)f", number / 1.0e12).moneyFormat() + "兆"
            }
        } else if StocksConfig.language == .chineseTraditional {
            if abs < 1.0e5 {
                result = String(format: "%.\(isInteger ? 0 : decimals)f", number).moneyFormat()
            } else if abs < 1.0e9 {
                result = String(format: "%.\(decimals)f", number / 1.0e4).moneyFormat() + "萬"
            } else if abs < 1.0e13 {
                result = String(format: "%.\(decimals)f", number / 1.0e8).moneyFormat() + "億"
            } else {
                result = String(format: "%.\(decimals)f", number / 1.0e12).moneyFormat() + "兆"
            }
        } else {
            if abs < 1.0e4 {
                result = String(format: "%.\(isInteger ? 0 : decimals)f", number).moneyFormat()
            } else if abs < 1.0e7 {
                result = String(format: "%.\(decimals)f", number / 1.0e3).moneyFormat() + "K"
            } else if abs < 1.0e10 {
                result = String(format: "%.\(decimals)f", number / 1.0e6).moneyFormat() + "M"
            } else if abs < 1.0e13 {
                result = String(format: "%.\(decimals)f", number / 1.0e9).moneyFormat() + "B"
            } else {
                result = String(format: "%.\(decimals)f", number / 1.0e12).moneyFormat() + "T"
            }
        }

        return signFlag + result
    }

    public func bigNumberFormat(_ decimals: Int = 2, isInteger: Bool = false, power: Int = 0, sign: Bool = false, noFormatBit: Int = 0) -> String {
        
        var result = ""
        let number = self / pow(10.0, Double(power))
        let signFlag = number > 0 && sign ? "+" : ""
        let abs = fabs(number)
        if abs < pow(10.0, Double(noFormatBit)) {
            return signFlag + String(format: "%.\(isInteger ? 0 : decimals)f", number).moneyFormat()
        }
        
        if StocksConfig.language == .chineseSimplified {
            if abs < 1.0e4 {
                result = String(format: "%.\(isInteger ? 0 : decimals)f", number).moneyFormat()
            } else if abs < 1.0e8 {
                result = String(format: "%.\(decimals)f", number / 1.0e4).moneyFormat() + "万"
            } else {
                result = String(format: "%.\(decimals)f", number / 1.0e8).moneyFormat() + "亿"
            }
        } else if StocksConfig.language == .chineseTraditional {
            if abs < 1.0e4 {
                result = String(format: "%.\(isInteger ? 0 : decimals)f", number).moneyFormat()
            } else if abs < 1.0e8 {
                result = String(format: "%.\(decimals)f", number / 1.0e4).moneyFormat() + "萬"
            } else {
                result = String(format: "%.\(decimals)f", number / 1.0e8).moneyFormat() + "億"
            }
        } else {
            if abs < 1.0e3 {
                result = String(format: "%.\(isInteger ? 0 : decimals)f", number).moneyFormat()
            } else if abs < 1.0e6 {
                result = String(format: "%.\(decimals)f", number / 1.0e3).moneyFormat() + "K"
            } else if abs < 1.0e9 {
                result = String(format: "%.\(decimals)f", number / 1.0e6).moneyFormat() + "M"
            } else {
                result = String(format: "%.\(decimals)f", number / 1.0e9).moneyFormat() + "B"
            }
        }
        
        return signFlag + result
    }
}
