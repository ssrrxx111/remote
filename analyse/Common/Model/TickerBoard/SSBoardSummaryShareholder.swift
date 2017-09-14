//
//  SSBoardSummaryShareholder.swift
//  Common
//
//  Created by JunrenHuang on 17/2/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

public struct SSBoardSummaryShareholder: JSONMappable, SSBoardSummary {

    public var equities = [SSBoardSummaryEquityModel]()

    public var totalLabel = ""
    public var totalValue = ""

    public var quarter = ""

    public var shareholders = [SSBoardSummaryEquityModel]()

    public var type: SSBoardSummaryType = .shareholder

    public init?(_ json: JSON) {
        guard
            let equity = json["equity"] as? JSON,
            let shareholders = json["shareholders"] as? JSON
            else {
                return nil
        }

        let totalKey = "totalShares"
        let i18nPre = "ticker.board.summary.capitalAnsShareholder."

        if let total = equity[totalKey] as? Double, total > 0 {

            let shareArray = [
                "nonRestrictedShares",
                "restrictedShares",
                "nonListedShares"
            ]

            for share in shareArray {
                guard let value = equity[share] as? Double else {
                    continue
                }

                let percent = value / total
                let label = i18n(i18nPre + share)
                let formatValue = value.volumeFormat()

                let equityModel = SSBoardSummaryEquityModel(
                    label: label,
                    value: formatValue,
                    percent: percent
                )
                equities.append(equityModel)
            }

            totalLabel = i18n(i18nPre + totalKey)
            totalValue = total.volumeFormat()
        }

        guard
            let list = shareholders["list"] as? [JSON],
            let quarter = shareholders["quarter"] as? String,
            list.count > 0
        else {
            return
        }
        self.quarter = quarter

        let headHolder = SSBoardSummaryEquityModel(
            label: "",
            value: quarter,
            percent: 0
        )
        self.shareholders.append(headHolder)

        for element in list {
            guard
                let percent = element["changeRatio"] as? Double,
                let name = element["name"] as? String,
                let value = element["value"] as? Double
            else {
                continue
            }

            let label = i18n(i18nPre + name)
            let formatValue = value.volumeFormat()

            let holder = SSBoardSummaryEquityModel(
                label: label,
                value: formatValue,
                percent: percent / 100
            )
            self.shareholders.append(holder)
        }

    }
}

public struct SSBoardSummaryEquityModel {
    public let label: String
    public let value: String
    public let percent: Double

    public init(label: String, value: String, percent: Double) {
        self.label = label
        self.value = value
        self.percent = percent
    }
}
