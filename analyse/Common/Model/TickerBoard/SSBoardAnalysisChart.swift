//
//  SSBoardAnalysisChart.swift
//  Common
//
//  Created by JunrenHuang on 13/4/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

public struct SSBoardAnalysisChart: JSONMappable {

    func createChartData(_ type: SSBoardAnalysisChartType, data: JSON) -> JSON? {
        let key = type.rawValue

        guard let json = data[key] as? JSON else {
            return nil
        }

        var xLabel = [String]()

        var lineData = [[String : Any]]()

        let colors: [UIColor] = [
            SSColor.c601.color,
            SSColor.c604.color,
            SSColor.c608.color
        ]

        var unit: String = ""

        for (i, legend) in type.legends.enumerated() {

            var chartValues = [Double?]()

            let legendName = legend.rawValue
            guard let values = json[legendName] as? [JSON], values.count > 0 else {
                continue
            }

            for value in values {

                chartValues.insert(getDouble(value["value"]), at: 0)

                if i != 0 {
                    continue
                }

                var label = ""
                if let dateString = value["date"] as? String {
                    label = dateString.seasonFormat()
                }
                xLabel.insert(label, at: 0)
            }

            if legend.hasUnit {
                let valueUnit = SSBoardFinanceModel.getUnit(chartValues)
                chartValues = chartValues.map({ SSBoardFinanceModel.convertDouble($0, unit: valueUnit) })

                unit = valueUnit
            }

            let data: [String : Any] = [
                "values": chartValues,
                "legend": i18n("ticker.board.analysis.legend." + legendName),
                "color": colors[i],
                "valueType": legend.valueType,
                "dependency": legend.axisDependency
            ]

            lineData.append(data)
        }
        
        guard lineData.count > 0 else {
            return nil
        }

        let barData: [[String : Any]] = []

        return [
            "barData": barData,
            "lineData": lineData,
            "xLabel": xLabel,
            "unit": unit
        ]
    }

    func getDouble(_ value: Any?) -> Double? {
        if let string = value as? String, let double = Double(string) {
            return double
        }
        return nil
    }

    public var chartsData = [SSBoardAnalysisModel]()

    public init?(_ json: JSON) {

        let charts: [SSBoardAnalysisChartType] = [
            .growth,
            .profit,
            .health
        ]

        for chart in charts {
            guard let chartData = self.createChartData(chart, data: json) else {
                continue
            }

            var rowLabels = [String]()
            var rowValues = [String]()
            for row in chart.rows {
                let key = row.rawValue
                rowLabels.append(i18n("ticker.analysis.row." + key))

                var value = String.nilValue

                if let v = json[key] as? String {
                    value = v
                }

                var element = value

                switch row {
                case .grossMargin, .preTaxMargin, .profitMargin:

                    if let double = Double(element) {
                        element = double.percent(sign: false)
                    }
                default:
                    break
                }
                rowValues.append(element)
            }

            var subtitle: String? = nil

            if let unit = chartData["unit"] as? String {
                subtitle = i18n("unit." + unit)
            }

            let data = SSBoardAnalysisModel(
                rowLabels: rowLabels, 
                rowValues: rowValues, 
                chartType: chart,
                subtitle: subtitle,
                chartData: chartData
            )

            chartsData.append(data)
        }

    }
}

public protocol SSBoardAnalysis {
    var type: SSBoardAnalysisType { get }
    var cellHeight: CGFloat { get }

    var subtitle: String? { get set }
}

public struct SSBoardAnalysisModel: SSBoardAnalysis {

    public let rowLabels: [String]
    public let rowValues: [String]

    public let chartType: SSBoardAnalysisChartType

    public var type: SSBoardAnalysisType {
        return chartType.indexType
    }

    public var subtitle: String?

    public let chartData: JSON

    public let headerHeight: CGFloat = 36
    public let chartHeight: CGFloat = 256
    public let rowHeight: CGFloat = 30
    public let verticalGap: CGFloat = 10
    public let bottomHeight: CGFloat = 7

    public var cellHeight: CGFloat {
        return headerHeight + verticalGap +
            (chartHeight + verticalGap) * 1 + bottomHeight
        + CGFloat(self.rowLabels.count) * rowHeight
    }

}

public enum SSBoardAnalysisType: String {
    case growth = "growth"
    case health = "health"
    case profit = "profit"

    case key = "key"
    case main = "revenue"

    public var index: Int {
        switch self {
        case .main:
            return 0
        case .key:
            return 1
        case .growth:
            return 2
        case .profit:
            return 3
        case .health:
            return 4
        }
    }

    public var title: String {
        return i18n("ticker.board.analysis." + self.rawValue)
    }
}

public enum SSBoardAnalysisChartType: String {
    case growth = "growth"
    case health = "health"
    case profit = "profit"

    var legends: [SSBoardAnalysisChartLegend] {
        switch self {
        case .growth:
            return [.eps] //.revenues, .netIncome,
        case .profit:
            return [.eibt, .profitMargin]
        case .health:
            return [.debtEquityRatio]
        }
    }

    var indexType: SSBoardAnalysisType {
        switch self {
        case .growth:
            return .growth
        case .health:
            return .health
        case .profit:
            return .profit
        }
    }

    var rows: [SSBoardAnalysisChartRow] {
        switch self {
        case .growth:
            return []//[.revenue, .netIncome]
        case .profit:
            return [.grossMargin, .preTaxMargin, .profitMargin]
        case .health:
            return [.debtEquityRatio, .currentRatio, .bookValue]
        }
    }
}

enum SSBoardAnalysisChartRow: String {
    case revenue = "revenue"
    case netIncome = "netIncome"

    case grossMargin = "grossMargin"
    case preTaxMargin = "preTaxMargin"
    case profitMargin = "profitMargin"

    case debtEquityRatio = "debtEquityRatio"
    case currentRatio = "currentRatio"
    case bookValue = "bookValue"
}

enum SSBoardAnalysisChartLegend: String {
    case revenues = "revenues"
    case netIncome = "netIncome"
    case eps = "eps"

    case eibt = "eibt"
    case profitMargin = "profitMargin"

    case debtEquityRatio = "debtEquityRatio"

    // 1是百分比，0是数值
    var valueType: Int {
        switch self {
        case .profitMargin:
            return 1
        default:
            return 0
        }
    }

    var hasUnit: Bool {
        switch self {
        case .eibt:
            return true
        default:
            return false
        }
    }

    // 0是依赖左边，1 右边。
    var axisDependency: Int {
        switch self {
        case .profitMargin: //, .eps
            return 1
        default:
            return 0
        }
    }
}
