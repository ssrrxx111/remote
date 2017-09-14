//
//  SSAlertRule.swift
//  Common
//
//  Created by Eason Lee on 2017/2/17.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import Foundation

public enum SSAlertValueType: String {
    case price = "price"
    case percent = "percent"
}

public enum SSAlertChangeType: String {
    case above = "above"
    case below = "below"
}

public enum SSAlertActiveType: String {
    case on = "on"
    case off = "off"
}

public struct SSAlertRule {

    public var alertID: Int
    public var active: SSAlertActiveType
    public var valueType: SSAlertValueType
    public var changeType: SSAlertChangeType
    public var value: Double
    public var timestamp: Int64?

    public init?(_ json: [String: Any]) {

        guard
            let alertID = json["alertId"] as? Int,
            let active = json["active"] as? String,
            let valueType = json["field"] as? String,
            let changeType = json["type"] as? String,
            let value = json["value"] as? Double
            else { return nil }

        self.alertID = alertID
        self.active = SSAlertActiveType(rawValue: active) ?? .off
        self.valueType = SSAlertValueType(rawValue: valueType) ?? .price
        self.changeType = SSAlertChangeType(rawValue: changeType) ?? .above
        self.value = value
        self.timestamp = json["timestamp"] as? Int64
    }

    public init(valueType: SSAlertValueType, changeType: SSAlertChangeType, value: Double) {
        self.alertID = UUID().hashValue
        self.active = .on
        self.valueType = valueType
        self.changeType = changeType
        self.value = value
        self.timestamp = Int64(Date().timeIntervalSince1970 * 1000)
    }

    public func toJSON() -> [String: Any] {
        var json = [String: Any]()
        json["alertId"] = alertID
        json["active"] = active.rawValue
        json["field"] = valueType.rawValue
        json["type"] = changeType.rawValue
        json["value"] = value
        json["timestamp"] = timestamp ?? Int64(Date().timeIntervalSince1970 * 1000)
        return json
    }
}

extension SSAlertRule: Hashable {

    public var hashValue: Int {
        return alertID
    }

    public static func ==(lhs: SSAlertRule, rhs: SSAlertRule) -> Bool {
        return lhs.alertID == rhs.alertID
    }
}
