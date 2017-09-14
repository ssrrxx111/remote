//
//  SSBoardSummaryDividend.swift
//  Common
//
//  Created by JunrenHuang on 17/2/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

public struct SSBoardSummaryDividendModel: JSONMappable {

    public let announceDate: String
    public let planDesc: String
    public let rightDay: String

    public init?(_ json: JSON) {
        guard
            let planDesc = json["planDesc"] as? String
        else {
            return nil
        }
        self.announceDate = SSFormatter.formatTimeYMD(json["announceDate"])
        self.rightDay = SSFormatter.formatTimeYMD(json["rightDay"])
        self.planDesc = planDesc
    }

    init(
        announceDate: String,
        rightDay: String,
        planDesc: String)
    {

        self.announceDate = announceDate
        self.rightDay = rightDay
        self.planDesc = planDesc
    }
}

public struct SSBoardSummaryDividend: SSBoardSummary {

    public var dividends = [SSBoardSummaryDividendModel]()

    public var type: SSBoardSummaryType = .dividend

    public init?(_ json: [SSBoardSummaryDividendModel]) {

        if json.isEmpty {
            return nil
        }

        dividends.append(contentsOf: json)

        let preLabel = "ticker.board.summary.dividend."

        let diviend = SSBoardSummaryDividendModel(
            announceDate: i18n(preLabel + "announceDate"),
            rightDay: i18n(preLabel + "rightDay"),
            planDesc: i18n(preLabel + "planDesc")
        )

        dividends.insert(diviend, at: 0)
    }
}

