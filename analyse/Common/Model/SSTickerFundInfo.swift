//
//  SSTickerFundInfo.swift
//  Common
//
//  Created by JunrenHuang on 28/3/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

public struct SSTickerFundInfo: JSONMappable {

    public var values = JSON()

    public init?(_ json: JSON) {

        let keys = [
            "netAssets",
            "ytdReturn",
            "anRepTurnRatio",

            "mptBeta3Y",
            "lerageRatio",
            "return5Y",

            "netExpenseRatio",
            "yield1Y",
            "inceptionDate",
            "msRating"
        ]

        for key in keys {

            values[key] = json[key]

            switch key {
            case "mptBeta3Y", "lerageRatio":
                values[key] = json[key]
            case "msRating":
                var rating = -1
                if let value = json[key] as? Int {
                    rating = value
                }
                values[key] = String(rating)
            default:
                values[key] = self.format(key, json: json)
            }
        }
    }

    func format(_ key: String, json: JSON) -> String {

        guard let value = json[key] as? String else {
            return String.nilValue
        }

        switch key {
        case "inceptionDate":

            if let date = value.gmtDate() {
                return date.ymdLocalFormat()
            }
            return value
        case "netAssets":
            return value.volumeFormat(sign: false)
        default:
            return value + "%"
        }
    }
}
