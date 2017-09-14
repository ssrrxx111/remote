//
//  SSShareTicker.swift
//  Common
//
//  Created by JunrenHuang on 2/3/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking


public class SSShareTickerModel: JSONMappable {

    public var tradings = [SSShareTradingInfo]()
    public var events = [SSShareEventMsg]()
    public var records = [SSShareTickerRecord]()

    public let tickerGain: SSShareTicker

    public init(tickerGain: SSShareTicker) {
        self.tickerGain = tickerGain
    }

    public required init?(_ json: JSON) {
        guard
            let tickerGainJSON = json["tickerGain"] as? JSON,
            let tickerGain = SSShareTicker(tickerGainJSON)
        else {
            return nil
        }
        self.tickerGain = tickerGain
        self.events = tickerGain.events
        self.records = tickerGain.events

        guard let tradingList = json["tradingList"] as? [JSON] else {
            return
        }

        for trade in tradingList {
            guard
                let tickerID = trade["tickerId"] as? Int,
                let portfolioId = trade["portfolioId"] as? String,
                let tradingId = trade["tradingId"] as? String,
                let commission = trade["commission"] as? String,
                let amount = trade["amount"] as? String,
                let date = trade["date"] as? String,
                let type = trade["type"] as? Int,
                let price = trade["price"] as? String,
                let entryType = SSEntryType(rawValue: type),
                let priceValue = Double(price),
                let amountValue = Double(amount),
                let commissionValue = Double(commission),
                let ymdDate = date.ymdDate()
            else {
                continue
            }
            let info = SSShareTradingInfo(
                portfolioID: portfolioId,
                tickerID: Int64(tickerID),
                tradingID: tradingId,
                amount: amountValue,
                commission: commissionValue,
                date: ymdDate,
                price: priceValue,
                entryType: entryType
            )

            self.tradings.append(info)
            self.records.append(info)
        }
        
        self.records.sort { (record1, record2) -> Bool in
            record1.date.timeIntervalSince1970 > record2.date.timeIntervalSince1970
        }
    }
}

public class SSShareTicker: SSShareGain {

    public var costPrice: String
    public var totalCost: String
    public var holdings: String
    public var lastPrice: String

    // 其实是showCode
    public var exchangeCode: String?

    public let name: String
    public let symbol: String
    public let tickerID: Int64
    public var type: Int64 = 2

    public var tradings = [SSShareTradingInfo]()
    public var events = [SSShareEventMsg]()

    public var isPerformance: Bool = true

    public var showTitle: NSMutableAttributedString {
        if StocksConfig.appearance.titleStyle == .name {
            return NSMutableAttributedString(string: name, attributes: [NSForegroundColorAttributeName: SSColor.c301.color, NSFontAttributeName: SSFont.t05.bold])
        } else {
            let str = NSMutableAttributedString(string: symbol, attributes: [NSForegroundColorAttributeName: SSColor.c301.color, NSFontAttributeName: SSFont.t05.bold])
            var code = ""
            if let exchangeCode = self.exchangeCode {
                code = " " + exchangeCode
            }
            
            let subStr = NSAttributedString(string: code, attributes: [NSForegroundColorAttributeName: SSColor.c302.color, NSFontAttributeName: SSFont.t08.font])
            str.append(subStr)
            return str
        }
    }

    public var showSubTitle: NSMutableAttributedString {
        if StocksConfig.appearance.titleStyle == .name {
            let str = NSMutableAttributedString(string: symbol, attributes: [NSForegroundColorAttributeName: SSColor.c302.color, NSFontAttributeName: SSFont.t08.font])
            var code = ""
            if let exchangeCode = self.exchangeCode {
                code = " " + exchangeCode
            }
            
            let subStr = NSAttributedString(string: code, attributes: [NSForegroundColorAttributeName: SSColor.c302.color, NSFontAttributeName: SSFont.t08.font])
            str.append(subStr)
            return str
        } else {
            return NSMutableAttributedString(string: name, attributes: [NSForegroundColorAttributeName: SSColor.c302.color, NSFontAttributeName: SSFont.t08.font])
        }
    }

//    public init(ticker: SSTickerTuple) {
//        self.name = ticker.name
//        self.symbol = ticker.symbol
//        self.tickerID = ticker.id
//        self.holdings = "0"
//        super.init()
//    }

    public required init?(_ json: JSON) {
        guard
            let tickerID = json["tickerId"] as? Int,
            let symbol = json["disSymbol"] as? String ?? json["symbol"] as? String,
            let name = json["name"] as? String,
            let holdings = json["holdings"] as? String
        else {
            return nil
        }

        self.name = name
        self.symbol = symbol
        self.tickerID = Int64(tickerID)

        SSLog(json)

        self.costPrice = getString(json["costPrice"]).decimalFormat()
        self.totalCost = getString(json["totalCost"]).volumeFormat(sign: false)
        self.lastPrice = getString(json["lastPrice"]).decimalFormat()

        if let holdingsValue = Double(holdings), holdingsValue == 0 {
            self.isPerformance = false
        }

        self.holdings = getString(json["holdings"])

        if let tickerInfo = json["tickerInfo"] as? JSON {
            if let showCode = tickerInfo["disExchangeCode"] as? String ?? tickerInfo["showCode"] as? String {
                self.exchangeCode = showCode
            }
            if let type = tickerInfo["type"] as? Int64 {
                self.type = type
            }
        }

        super.init(json)
        
        guard let eventList = json["eventMsgVoList"] as? [JSON] else {
            return
        }
        
        for event in eventList {
            guard
                let date = event["date"] as? String,
                let gmtDate = date.ymdDate(),
                let typeString = event["type"] as? String,
                let type = SSEventType(rawValue: typeString),
                let event = event["event"] as? String
                else {
                    continue
            }
            let info = SSShareEventMsg(
                date: gmtDate,
                type: type,
                event: event)
            
            events.append(info)
        }
    }
    
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

fileprivate func getString(_ json: Any?) -> String {
    if let string = json as? String {
        return string
    }
    return String.nilValue
}

public class SSShareTradingInfo: SSShareTickerRecord {
    public let portfolioID: String
    public let tickerID: Int64
    public let tradingID: String

    public var amount: Double
    public var commission: Double
    public var commissionRatio: Double?
    public var price: Double
    public var entryType: SSEntryType

    init(
        portfolioID: String,
        tickerID: Int64,
        tradingID: String,
        amount: Double,
        commission: Double,
        date: Date,
        price: Double,
        entryType: SSEntryType,
        commissionRatio: Double? = nil)
    {
        self.portfolioID = portfolioID
        self.tickerID = tickerID
        self.tradingID = tradingID
        self.amount = amount
        self.commission = commission
        self.commissionRatio = commissionRatio
        self.price = price
        self.entryType = entryType
        super.init(date: date)
    }
}

//拆股分红记录
public class SSShareEventMsg: SSShareTickerRecord {
    public var type: SSEventType
    public var event: String
    
    init(
        date: Date,
        type: SSEventType,
        event: String)
    {
        self.type = type
        self.event = event
        super.init(date: date)
    }
}

public class SSShareTickerRecord {
    public var date: Date
    
    init(date: Date) {
        self.date = date
    }
}

extension SSEntryType {

    public var name: String {
        switch self {
        case .buy:
            return i18n("portfolio.holding.buy")
        case .sell:
            return i18n("portfolio.holding.sell")
        }

    }
    
    public var color: UIColor {
        switch self {
        case .buy:
            return SSColor.riseArea.color
        case .sell:
            return SSColor.fallArea.color
        }
    }
}
