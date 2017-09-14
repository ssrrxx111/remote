//
//  File.swift
//  Common
//
//  Created by JunrenHuang on 17/2/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

public struct SSBoardSummaryExecutiveModel: JSONMappable {

    public let name: String
    public let position: String

    public init?(_ json: JSON) {
        guard
            let name = json["name"] as? String,
            let position = json["position"] as? String
        else {
            return nil
        }
        self.name = name
        self.position = position
    }
}

public struct SSBoardSummaryExecutive: SSBoardSummary {

    public var executives = [SSBoardSummaryExecutiveModel]()

    public var type: SSBoardSummaryType = .executive

    public init?(_ json: [SSBoardSummaryExecutiveModel]) {

        if json.isEmpty {
            return nil
        }

        executives.append(contentsOf: json)

        let preLabel = "ticker.board.summary.executive."
        let labels: JSON = [
            "name": i18n(preLabel + "name"),
            "position": i18n(preLabel + "position"),
        ]
        if let label = SSBoardSummaryExecutiveModel(labels) {
            executives.insert(label, at: 0)
        }
    }
}
