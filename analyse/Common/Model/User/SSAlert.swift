//
//  SSAlert.swift
//  Common
//
//  Created by Eason Lee on 2017/2/17.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import Foundation
import Networking

public class SSAlert: JSONMappable {

    public var tickerID: Int
    public var rules: [SSAlertRule]
    public var timestamp: Int64?

    // public var tickerTuple: SSTickerTuple?

    // meta data
    public var showCode: String?
    public var symbol: String?
    public var name: String?
    public var exchangeCode: String?

    public required init?(_ json: JSON) {

        guard
            let tickerID = json["tickerId"] as? Int,
            let showCode = json["disExchangeCode"] as? String ?? json["showCode"] as? String,
            let symbol = json["disSymbol"] as? String ?? json["tickerSymbol"] as? String,
            let name = json["tickerName"] as? String,
            let rules = json["rules"] as? [JSON]
            else { return nil }

        var _rules = [SSAlertRule]()
        for item in rules {
            if let rule = SSAlertRule(item) {
                _rules.append(rule)
            }
        }

        self.tickerID = tickerID
        self.rules = _rules
        self.timestamp = json["bizTimestamp"] as? Int64

        self.showCode = showCode
        self.symbol = symbol
        self.name = name
        self.exchangeCode = json["exchangeCode"] as? String
    }

    public init(tickerID: Int, rules: [SSAlertRule]) {
        self.tickerID = tickerID
        self.rules = rules
    }

    /// copy
    public static func copy(_ alert: SSAlert, rules: [SSAlertRule]) -> SSAlert {
        let new = SSAlert(tickerID: alert.tickerID, rules: rules)
        new.showCode = alert.showCode
        new.symbol = alert.symbol
        new.name = alert.name
        new.exchangeCode = alert.exchangeCode
        return new
    }

    public func toJSON() -> [String: Any] {
        var json = [String: Any]()
        json["tickerId"] = tickerID
        json["rules"] = rules.map({ $0.toJSON() })
        json["warning_mode"] = 1
        json["warning_frequency"] = 1
        json["bizTimestamp"] = Int64(Date().timeIntervalSince1970 * 1000)
        return json
    }
}
