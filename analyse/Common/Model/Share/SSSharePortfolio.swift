//
//  SSPortfolioShare.swift
//  Common
//
//  Created by JunrenHuang on 2/3/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

/// 自选及模拟持仓中数字格式化后正数无“+” 号
public class SSSharePortfolio: SSShareGain {

    public var performanceTickers = [SSShareTicker]()
    public var closeTickers = [SSShareTicker]()

    public let name: String
    public let portfolioID: String

    public var isValid: Bool {
        return !performanceTickers.isEmpty || !closeTickers.isEmpty
    }

    public required init?(_ json: JSON) {

        guard
            let portfolioId = json["portfolioId"] as? String,
            let name = json["name"] as? String
        else {
            return nil
        }

        self.portfolioID = portfolioId
        self.name = name

        super.init(json)

        guard let tickerGainList = json["tickerGainList"] as? [JSON] else {
            return
        }

        for ticker in tickerGainList {
            if let shareTicker = SSShareTicker(ticker) {

                if shareTicker.isPerformance {
                    performanceTickers.append(shareTicker)
                } else {
                    closeTickers.append(shareTicker)
                }
            }
        }
    }
}

/// 自选及模拟持仓中数字格式化后正数有“+” 号
public class SSSignSharePortfolio: SSSharePortfolio {
    
    public override func updateDisplayValue(_ currentCurrency: String?) {
        var ratio: Double = 1
        
        if
            let currency = currentCurrency,
            let newRatio = Utils.findExchangeRate(currencyCode, destinationSymbol: currency)
        {
            ratio = newRatio
        }
        
        self.marketValueString = formatValue(self.marketValue, sign: false, ratio: ratio)
        
        self.dayGainString = formatValue(self.dayGain, sign: true, ratio: ratio)
        self.totalGainString = formatValue(self.totalGain, sign: true, ratio: ratio)
        self.unrealizedGainString = formatValue(self.unrealizedGain, sign: true, ratio: ratio)
        self.totalBonusGainString = formatValue(self.totalBonusGain, sign: true, ratio: ratio)
        
        self.dayGainRatioString = formatRatioValue(self.dayGainRatio)
        self.totalGainRatioString = formatRatioValue(self.totalGainRatio)
        self.unrealizedGainRatioString = formatRatioValue(self.unrealizedGainRatio)
    }
}

public class SSShareAllPortfolio: SSShareGain {

    public var portfolios = [SSSignSharePortfolio]()

    public required init?(_ json: JSON) {
        super.init(json)

        guard let portfolioGainList = json["portfolioGainList"] as? [JSON] else {
            return
        }

        for portfolio in portfolioGainList {
            if let sharePortfolio = SSSignSharePortfolio(portfolio) {
                portfolios.append(sharePortfolio)
            }
        }
    }
}

public class SSShareGain: JSONMappable {

    public var currencyId: Int?

    public var marketValue: String?

    public var dayGain: String?
    public var dayGainRatio: String?

    public var totalGain: String?
    public var totalGainRatio: String?

    public var unrealizedGain: String?
    public var unrealizedGainRatio: String?
    
    public var totalBonusGain: String?

    public var currencySymbol: String {
        guard
            let id = self.currencyId,
            let string = StringUtils.getCurrencyDisplaySymbol(id)
        else {
            return ""
        }
        return string
    }

    public var currencyCode: String {
        guard
            let id = self.currencyId,
            let string = StringUtils.getCurrencyDisplayCode(id)
            else {
                return ""
        }
        return string
    }

    public required init?(_ json: JSON) {

        if let currencyId = json["currencyId"] as? Int {
            self.currencyId = currencyId
        }
//
//        if let marketValue = json["marketValue"] as? String {
//            self.marketValue = Double(marketValue)
//        }
//
//        if let dayGain = json["dayGain"] as? String {
//            self.dayGain = Double(dayGain)
//        }
//
//        if let dayGainRatio = json["dayGainRatio"] as? String {
//            self.dayGainRatio = Double(dayGainRatio)
//        }
//
//        if let totalGain = json["totalGain"] as? String {
//            self.totalGain = Double(totalGain)
//        }
//
//        if let totalGainRatio = json["totalGainRatio"] as? String {
//            self.totalGainRatio = Double(totalGainRatio)
//        }
//
//        if let unrealizedGain = json["unrealizedGain"] as? String {
//            self.unrealizedGain = Double(unrealizedGain)
//        }

        self.marketValue = json["marketValue"] as? String
        self.dayGain = json["dayGain"] as? String
        self.dayGainRatio = json["dayGainRatio"] as? String
        self.totalGain = json["totalGain"] as? String
        self.totalGainRatio = json["totalGainRatio"] as? String
        self.unrealizedGain = json["unrealizedGain"] as? String
        self.unrealizedGainRatio = json["unrealizedGainRatio"] as? String
        self.totalBonusGain = json["totalBonuseGain"] as? String

        self.updateDisplayValue()
    }

    // 汇率更新后，这边Doule数据更新完，还得刷这个。
    public func updateDisplayValue(_ currentCurrency: String? = nil) {

        var ratio: Double = 1

        if
            let currency = currentCurrency,
            let newRatio = Utils.findExchangeRate(currencyCode, destinationSymbol: currency)
        {
            ratio = newRatio
        }

        self.marketValueString = formatValue(self.marketValue, sign: false, ratio: ratio)

        self.dayGainString = formatValue(self.dayGain, sign: true, ratio: ratio)
        self.totalGainString = formatValue(self.totalGain, sign: true, ratio: ratio)
        self.unrealizedGainString = formatValue(self.unrealizedGain, sign: true, ratio: ratio)
        self.totalBonusGainString = formatValue(self.totalBonusGain, sign: true, ratio: ratio)
        
        self.dayGainRatioString = formatRatioValue(self.dayGainRatio)
        self.totalGainRatioString = formatRatioValue(self.totalGainRatio)
        self.unrealizedGainRatioString = formatRatioValue(self.unrealizedGainRatio)
        
    }

    public var marketValueString = ""

    public var dayGainString = ""
    public var dayGainRatioString = ""

    public var totalGainString = ""
    public var totalGainRatioString = ""

    public var unrealizedGainString = ""
    public var unrealizedGainRatioString = ""
    
    public var totalBonusGainString = ""

    func getDouble(_ json: Any?) -> Double? {
        if let string = json as? String {
            return Double(string)
        }
        return nil
    }
}

public func formatValue(_ value: String?, sign: Bool = false, ratio: Double = 1) -> String {
    guard let value = value, let double = Double(value) else {
        return String.nilValue
    }
    return (double * ratio).shareNumberFormat(sign: sign)
}

public func formatRatioValue(_ value: String?) -> String {
    guard let value = value, let double = Double(value) else {
        return String.nilValue
    }
    return double.percent()
}
