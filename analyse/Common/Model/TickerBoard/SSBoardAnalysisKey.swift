//
//  SSBoardAnalysisKey.swift
//  Common
//
//  Created by JunrenHuang on 13/4/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

public struct SSBoardAnalysisKey: JSONMappable, SSBoardAnalysis {

    public var subtitle: String? = nil

    public var titles = [String]()
    public var values = [String]()

    public let type: SSBoardAnalysisType = .key

    public init?(_ json: JSON) {
        guard let pairs = json["pairs"] as? [JSON] else {
            return nil
        }

        for value in pairs {
            guard let title = value["title"] as? String else {
                continue
            }
            titles.append(title)

            var data = String.nilValue
            if let v = value["value"] as? String {
                data = v
            }
            values.append(data)
        }
        
    }

    public let headerHeight: CGFloat = 36
    public let chartHeight: CGFloat = 256
    public let rowHeight: CGFloat = 30
    public let verticalGap: CGFloat = 10
    public let bottomHeight: CGFloat = 7

    public var cellHeight: CGFloat {
        return headerHeight + verticalGap + bottomHeight
            + CGFloat(self.titles.count) * rowHeight
    }
    
}

public struct SSBoardAnalysisMain: JSONMappable, SSBoardAnalysis {

    public var subtitle: String? = nil

    public let type: SSBoardAnalysisType = .main

    public let pieData: JSON

    public init?(_ json: JSON) {
        guard let datas = json["datas"] as? [JSON], !datas.isEmpty else {
            return nil
        }

        let colors = [
            SSColor.c601.color,
            SSColor.c602.color,
            SSColor.c604.color,
            SSColor.c606.color,
            SSColor.c608.color
        ]

        let colorCount = colors.count

        var pieData = [JSON]()

        for (i, data) in datas.enumerated() {

            guard
                let name = data["name"] as? String,
                let ratio = data["ratio"] as? String,
                let ratioValue = Double(ratio)
            else {
                continue
            }

            pieData.append([
                "color": colors[i % colorCount],
                "legend": name + " " + ratioValue.percent(sign: false),
                "value": ratioValue
            ])
        }

//        self.elementCount = pieData.count

        self.pieData = [
            "pieData": pieData
        ]
    }

//    let elementCount: Int

    public let headerHeight: CGFloat = 36
//    public let chartHeight: CGFloat = 256
//    public let rowHeight: CGFloat = 30
    public let verticalGap: CGFloat = 10
    public let bottomHeight: CGFloat = 7

    public var cellHeight: CGFloat {
        return UITableViewAutomaticDimension
            //headerHeight + verticalGap * 2 + bottomHeight + CGFloat(elementCount) * rowHeight
    }
}
