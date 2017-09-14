//
//  SSBoardIndexComponent.swift
//  Common
//
//  Created by JunrenHuang on 10/4/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

public struct SSBoardIndexComponent: JSONMappable {

    public var realtime: SSTickerRealtime
    public var ticker: SSTickerTuple

    public init?(_ json: JSON) {

        guard
            let name = json["name"] as? String,
            let symbol = json["disSymbol"] as? String,
            let tickerID = json["tickerId"] as? Int64,
            let code = json["disExchangeCode"] as? String
        else {
            return nil
        }

        self.realtime = SSTickerRealtime(indexJSON: json)

        if (json["currencyId"] as? Int64) != nil {

        }

        var ticker = SSTickerTuple(
            name: name,
            type: 2,
            symbol: symbol, 
            id: tickerID, 
            showCode: code,
            currencyID: json["currencyId"] as? Int64,
            exchangeTrade: json["exchangeTrade"] as? Bool
        )
        ticker.secType = json["secType"] as? [Int64] ?? []
        let countryIsoCode = json["countryISOCode"] as? String ?? ""
        ticker.countryISOCode = countryIsoCode
        ticker.exchangeCode = json["exchangeCode"] as? String ?? ""
        ticker.regionID = Int64(ShareRegion.mapCountryISOCodeToRegionId(countryIsoCode) ?? 0)

        self.ticker = ticker
    }
}
