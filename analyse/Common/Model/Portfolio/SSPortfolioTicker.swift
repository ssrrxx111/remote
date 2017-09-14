//
//  SSPortfolioTicker.swift
//  stocks-ios
//
//  Created by Eason Lee on 10/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

public class SSPortfolioTicker {

    public var objectID: String

    public var id: Int64 {
        return tickerTuple.id
    }
    
    public var tickerTuple: SSTickerTuple
    public var realtime: SSTickerRealtime?
    public var order: Int64
    public var operationTime: Date

    public init(_ tickerTuple: SSTickerTuple,
                objectID: String,
                realtime: SSTickerRealtime?,
                order: Int64,
                operationTime: Date) {
        self.objectID = objectID
        self.tickerTuple = tickerTuple
        self.realtime = realtime
        self.order = order
        self.operationTime = operationTime
    }

    public func toJSON() -> [String: Any] {

        var json: [String: Any] = [
            "id": tickerTuple.id,
            "type": tickerTuple.type,
            "name": tickerTuple.name,
            "symbol": tickerTuple.symbol,
            "showCode": tickerTuple.showCode,
            "exchangeCode": tickerTuple.exchangeCode,
        ]

        if let realtime = realtime {
            json["changeRatio"] = realtime.changeRatio
            json["change"] = realtime.change
            json["price"] = realtime.price
        }

        return json
    }
}

extension SSPortfolioTicker: Hashable {

    public var hashValue: Int {
        return id.hashValue
    }

    public static func == (lhs: SSPortfolioTicker, rhs: SSPortfolioTicker) -> Bool {
        return lhs.id == rhs.id
    }

}
