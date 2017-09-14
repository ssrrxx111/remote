//
//  SSTickerSummaryInfo.swift
//  Common
//
//  Created by Eason Lee on 22/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

public struct SSTickerSummaryInfo: JSONMappable {

    public var id: Int64
    public var type: Int64
    public var name: String
    public var symbol: String

//    var exchangeCode: String
//    var showCode: String
//
//    var regionID: Int64
//    var status: Int64
//
//    var currencyID: Int64?
//    var secType: [Int64]

    public init?(_ json: JSON) {

        guard
            let id = json["tickerId"] as? Int64,
            let type = json["type"] as? Int64,
            let name = json["name"] as? String,
            let symbol = json["disSymbol"] as? String ?? json["symbol"] as? String
            else { return nil }

        self.id = id
        self.type = type
        self.name = name
        self.symbol = symbol
    }
}
