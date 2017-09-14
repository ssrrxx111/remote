//
//  RecommendListTicker.swift
//  Common
//
//  Created by Eason Lee on 2017/3/16.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import Foundation
 

public class RecommendListTicker: JSONMappable {

    public var id: Int64
    public var name: String
    public var symbol: String
    public var price: String
    public var change: String
    public var changeRatio: String
    public var exchangeCode: String

    public var oldPrice: String = String.nilValue

    public var exchangeID: Int64?
    public var sort: Int64

    public var exchangeTrade: Bool?

    public required init?(_ json: JSON) {

        guard
            let id = json["tickerId"] as? Int64,
            let name = json["tickerName"] as? String,
            let symbol = json["symbol"] as? String,
            let price = json["close"] as? String,
            let change = json["change"] as? String,
            let changeRatio = json["changeRatio"] as? String,
            let exchangeCode = json["exChangeCode"] as? String
            else { return nil }

        self.id = id
        self.name = name
        self.symbol = symbol
        self.price = price
        self.change = change
        self.changeRatio = changeRatio
        self.exchangeCode = exchangeCode

        self.exchangeID = json["exChangeId"] as? Int64
        self.sort = json["sort"] as? Int64 ?? 0

        if let exchangeTrade = json["exchangeTrade"] as? Bool {
            self.exchangeTrade = exchangeTrade
        }
    }

    public var decimal: Int?

    public func updatePushData(_ json: JSON) -> Bool {
        if let changeRatio = json["changeRatio"] as? String {
            self.changeRatio = changeRatio
        }

        if let change = json["change"] as? String {
            self.change = change
        }

        if let price = json["price"] as? String, self.price != price {
            self.decimal = SSFormatter.getDecimal(price)
            self.price = price
            return true
        } else {
            return false
        }
    }
}
