//
//  SSTickerRealtime.swift
//  stocks-ios
//
//  Created by Eason Lee on 10/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

public struct SSTickerRealtime: JSONMappable {
    
    public var id: Int64
    public var close: String
    public var change: String
    public var changeRatio: String
    public var status: String
    public var faStatus: String?
    public var price: String
    public var pPrice: String?
    public var pChange: String?
    public var pChRatio: String?
    public var tradeTime: Date
    
    public var regionID: Int64
    public var regionAlias: String?
    
    public var oldPrice: String = String.nilValue
    
    public var priceValue: Double {
        return Double(price) ?? 0
    }
    
    public var changeValue: Double {
        return Double(change) ?? 0
    }
    
    public var changeRatioValue: Double {
        return Double(changeRatio) ?? 0
    }
    
    public static let priceAttr: [String: Any] = [
        NSForegroundColorAttributeName: SSColor.c301.color,
        NSFontAttributeName: SSFont.t04.digit
    ]
    
    public mutating func updatePushData(_ json: JSON) -> Bool {
        
        var valueChanged: Bool = false
        
        let changeRatio = json["changeRatio"] as? String
        let change = json["change"] as? String
        let price = json["price"] as? String
        let status = json["status"] as? String
        let faStatus = json["faStatus"] as? String
        let pPrice = json["pPrice"] as? String
        let pChange = json["pChange"] as? String
        let pChRatio = json["pChRatio"] as? String
        let tradeTime = (json["tradeTime"] as? String ?? "").gmtDate()?.timeIntervalSince1970
        
        guard let newTradeTime = tradeTime, self.tradeTime.timeIntervalSince1970 <= newTradeTime else {
            return false
        }
        
        valueChanged = (self.change != change) ||
            (self.changeRatio != changeRatio) ||
            (self.price != price) ||
            (self.status != status) ||
            (self.faStatus != faStatus) ||
            (self.pPrice != pPrice) ||
            (self.pChange != pChange) ||
            (self.pChRatio != pChRatio)
        
        
        // 盘前盘后数据
        var fa: Bool = false  // 是否有盘前盘后

        if let statusStr = status, let status = SSTickerStatus(rawValue: statusStr) {
            if status == .F || status == .A, let _ = pPrice {  // 盘前盘后
                fa = true
            } else if status == .B, let faStatusStr = faStatus, let _ = SSTickerStatus(rawValue: faStatusStr) {
                fa = true
            }
        }
        
        if !fa {  // 盘前盘后阶段，推送不会推price change changRatio
            self.change = change ?? ""
            self.changeRatio = changeRatio ?? ""
            self.price = price ?? ""
        }
        
        self.status = status ?? ""
        self.faStatus = faStatus ?? ""
        self.pPrice = pPrice ?? ""
        self.pChange = pChange ?? ""
        self.pChRatio = pChRatio ?? ""
        
        return valueChanged
    }
    
    public init(indexJSON json: JSON) {
        
        if let id = json["tickerId"] as? Int64 {
            self.id = id
        } else {
            self.id = 0
        }
        
        var decimal = 2
        if let close = json["close"] as? String {
            decimal = SSFormatter.getDecimal(close)
        }
        self.close = SSFormatter.formatNumberString(json["close"], decimal: decimal)
        self.change = SSFormatter.formatSignedString(json["change"], decimal: decimal)
        self.changeRatio = SSFormatter.formatPercent(json["changeRatio"])
        
        self.price = close
        
        self.status = json["status"] as? String ?? ""
        self.tradeTime = (json["tradeTime"] as? String)?.gmtDate() ?? Date()
        
        self.regionID = json["regionId"] as? Int64 ?? 0
    }
    
    public init?(_ json: JSON) {
        guard
            let id = json["tickerId"] as? Int64,
            let close = json["close"] as? String
            else { return nil }
        
        self.id = id
        self.close = close
        
        if let change = json["change"] as? String {
            self.change = change
        } else {
            self.change = ""
        }
        
        if let pChange = json["pChange"] as? String {
            self.pChange = pChange
        }
        
        if let changeRatio = json["changeRatio"] as? String {
            self.changeRatio = changeRatio
        } else {
            self.changeRatio = ""
        }
        
        if let changeRatio = json["pChRatio"] as? String {
            self.pChRatio = changeRatio
        }
        
        if let price = json["price"] as? String {
            self.price = price
        } else {
            self.price = close
        }
        
        if let pPrice = json["pPrice"] as? String {
            self.pPrice = pPrice
        }
        
        self.status = json["status"] as? String ?? ""
        self.faStatus = json["faStatus"] as? String
        self.tradeTime = (json["tradeTime"] as? String)?.gmtDate() ?? Date()
        
        self.regionID = json["regionId"] as? Int64 ?? 0
        self.regionAlias = json["regionAlias"] as? String
    }
    
    /// 市场tab的大部分接口使用的是price字段，只有共同基金\etf使用的close字段表示价格
    public init?(marketJson json: JSON) {
        
        //兼容诊股排名接口
        var doubleCloseStirng: String?
        if let doubleClose = json["close"] as? Double {
            doubleCloseStirng = "\(doubleClose)"
        }
        
        guard
            let id = json["tickerId"] as? Int64,
            let close = ((json["price"] as? String) ?? (json["close"] as? String)) ?? doubleCloseStirng
            else { return nil }
        
        self.id = id
        self.close = close
        
        if let change = json["change"] as? String {
            self.change = change
        } else if let change = json["pChange"] as? String {
            self.change = change
        } else {
            if let changeDouble = json["change"] as? Double {
                self.change = "\(changeDouble)"
            } else {
                self.change = ""
            }
        }
        
        if let changeRatio = json["changeRatio"] as? String {
            self.changeRatio = changeRatio
        } else if let changeRatio = json["pChRatio"] as? String {
            self.changeRatio = changeRatio
        } else {
            if let changeRatioDouble = json["changeRatio"] as? Double {
                self.changeRatio = "\(changeRatioDouble)"
            } else {
                self.changeRatio = ""
            }
        }
        
        if let price = json["price"] as? String {
            self.price = price
        } else {
            self.price = close
        }
        
        self.status = json["status"] as? String ?? ""
        self.tradeTime = (json["tradeTime"] as? String)?.gmtDate() ?? Date()
        
        self.regionID = json["regionId"] as? Int64 ?? 0
        self.regionAlias = json["regionAlias"] as? String
    }
}
