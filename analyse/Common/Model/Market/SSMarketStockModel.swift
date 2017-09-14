//
//  SSMarketStockModel.swift
//  stocks-ios
//
//  Created by Hugo on 16/6/22.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit
import Networking

open class SSMarketStockModel: JSONMappable {

    public var tickerTuple: SSTickerTuple
    public var realTime: SSTickerRealtime
    
    public required init?(_ json: JSON) {
        guard let tickerTuple = SSTickerTuple(marketJson: json), let realTime = SSTickerRealtime(marketJson: json) else {
            return nil
        }
        self.tickerTuple = tickerTuple
        self.realTime = realTime
    }
}

