//
//  SSBoardSummaryBrief.swift
//  Common
//
//  Created by JunrenHuang on 16/2/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

public struct SSBoardSummaryBriefModel: JSONMappable {

    public var contents = [String]()
    public let title: String
    public var type: SSBoardSummaryType = .brief

    public init?(_ json: JSON) {
        guard
            let items = json["items"] as? [JSON],
            let title = (json["title"] as? JSON),
            let titleContext = title["context"] as? String
            else {
                return nil
        }
        self.title = titleContext

        for item in items {
            if let content = item["context"] as? String {
                contents.append(content)
            }
        }
    }
}

public struct SSBoardSummaryBrief: SSBoardSummary {

    public var briefs = [SSBoardSummaryBriefModel]()

    public var type: SSBoardSummaryType = .brief

    public init?(_ json: [SSBoardSummaryBriefModel]) {

        if json.isEmpty {
            return nil
        }

        briefs.append(contentsOf: json)

    }
}

public protocol SSBoardSummary {
    var type: SSBoardSummaryType { get set }
}

public enum SSBoardSummaryType: Int {
    case brief = 0
    case dividend
    case shareholder
    case executive
}

