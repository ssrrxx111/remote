//
//  SSBoardFinanceModel.swift
//  Common
//
//  Created by JunrenHuang on 16/2/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking


public enum SSBoardFinanceType: Int {
    case profit = 0
    case debt
    case cash
    
    public var name: String {
        
        let pre = "ticker.board.finance."
        switch self {
        case .profit:
            return i18n(pre + "profit")
        case .debt:
            return i18n(pre + "debt")
        case .cash:
            return i18n(pre + "cash")
        }
    }
}

public class SSBoardFinanceModel {

    public var rowLabels = [String]()
    public var rowValues = [String]()

    public var type = SSBoardFinanceType.profit

    public var barUnit: String?

    public var chartCount: Int {
        return 1
    }

    public var title = ""
    public var subtitle = ""

    public var currency = ""

    public var mainChartData = [String : Any]()

    public init?(_ json: [JSON], type: Any?) {
        if json.isEmpty {
            return nil
        }
    }
    public let headerHeight: CGFloat = 36
    public let chartHeight: CGFloat = 256
    public let rowHeight: CGFloat = 30
    public var verticalGap: CGFloat = 10
    public let bottomHeight: CGFloat = 7

    public var cellHeight: CGFloat {
        if self.type == .profit {
            return headerHeight + bottomHeight + (20.0 + chartHeight + verticalGap*2) * CGFloat(chartCount) + SSBottomShadowCellSeperatorHeight
        }
        return headerHeight + verticalGap * 2 +
            (chartHeight + verticalGap) * CGFloat(self.chartCount) + bottomHeight + SSBottomShadowCellSeperatorHeight
    }

    func getDouble(_ value: Any?) -> Double? {
        if let string = value as? String, let double = Double(string) {
            return double
        }
        return nil
    }

    static func convertDouble(_ double: Double?, unit: String) -> Double? {
        guard let value = double else {
            return nil
        }

        let units = ["", "K", "M", "B", "T"]

        guard let index = units.index(of: unit) else {
            return double
        }
        return value / pow(1000, Double(index))
        
    }

    static func getUnit(_ data: [Double?]) -> String {
        var maxValue: Double?

        var index = -1
        for (i, double) in data.enumerated() {
            if let value = double {
                let absValue = abs(value)

                if let currentMax = maxValue {

                    if currentMax < absValue {
                        maxValue = absValue
                        index = i
                    }
                } else {
                    maxValue = absValue
                    index = i
                }
            }
        }

        guard index != -1, let value = data[index] else {
            return ""
        }

        var t = value
        var unitIndex = 0
        let units = ["", "K", "M", "B", "T"]

        while t >= 100000 || t <= -100000 {
            t /= 1000
            unitIndex += 1
        }

        if units.count > unitIndex {
            return units[unitIndex]
        } else {
            return units[units.count - 1]
        }
    }
}


