//
//  File.swift
//  Common
//
//  Created by JunrenHuang on 27/4/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

public class SSBoardRecommendationPrice: JSONMappable {

    public let low: String
    public let lowValue: Double
    public let high: String
    public let highValue: Double
    public let current: String
    public let currentValue: Double
    public let average: String
    public let averageValue: Double

    public func getRatio(value: Double) -> CGFloat {
        return CGFloat((value - lowValue) / (highValue - lowValue))
    }

    public required init?(_ json: JSON) {
        guard
            let low = json["low"] as? String,
            let lowValue = Double(low),
            let high = json["high"] as? String,
            let highValue = Double(high),
            let current = json["current"] as? String,
            let currentValue = Double(current),
            let mean = json["mean"] as? String,
            let meanValue = Double(mean),
            highValue > lowValue

            else {
                return nil
        }

        let pre = "ticker.board.recommendation."

        self.low = i18n(pre + "low") + " " + low
        self.lowValue = lowValue
        self.high = i18n(pre + "high") + " " + high
        self.highValue = highValue
        self.current = i18n(pre + "current") + " " + current
        self.currentValue = currentValue
        self.average = i18n(pre + "mean") + " " + mean
        self.averageValue = meanValue
        
    }
}

public class SSBoardRecommendationTrend: JSONMappable {

    public var stackEntries = [Double](repeating: 0, count: 5)
    public let age: String
    public let totalNumber: Double

    public required init?(_ json: JSON) {
        guard
            let age = json["age"] as? String,
            let number = json["numberOfAnalysts"] as? Int,
            let list = json["distributionList"] as? [JSON]
        else {
            return nil
        }

        self.totalNumber = Double(number)

        let count = stackEntries.count

        for element in list {
            guard
                let recommendation = element["Recommendation"] as? Int,
                let subnumber = element["NumberOfAnalysts"] as? Int
            else {
                continue
            }
            if recommendation - 1 < count {
                stackEntries[count - 1 - (recommendation - 1)] = Double(subnumber)
            }
        }

        func getDate() -> Date {
            
            var dateComponents = DateComponents()
            
            switch age {
            case "OneWeekAgo":
                dateComponents.month = 0
            case "ThirtyDaysAgo":
                dateComponents.month = -1
            case "SixtyDaysAgo":
                dateComponents.month = -2
            case "NinetyDaysAgo":
                dateComponents.month = -3
            default:
                dateComponents.month = 0
            }
            let newDate = Calendar.current.date(byAdding: dateComponents, to: Date()) ?? Date()
            return newDate
        }

        let currentDate = Date()

        func getMonthSymbol() -> String {

            var monthSymbol: String = ""
            if StocksConfig.language.isChinese {
                let month = Calendar.current.component(.month, from: getDate())
                monthSymbol = "\(month)月"
            } else {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US")
                formatter.dateFormat = "MMM"
                monthSymbol = formatter.string(from: getDate())
            }
            // 国际化
            return monthSymbol
        }
        
        self.age = getMonthSymbol()
    }
}
