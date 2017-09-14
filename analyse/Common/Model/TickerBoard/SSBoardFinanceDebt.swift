//
//  SSBoardFinanceDebt.swift
//  Common
//
//  Created by JunrenHuang on 14/2/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

public class SSBoardFinanceDebt: SSBoardFinanceModel {

    public override init?(_ json: [JSON], type: Any?) {

        super.init(json, type: type)

        var xLabel = [String]()

        let chartLabel: [SSBoardDebtList] = [
            .totalAssets,
            .totalDebt,
            .margin
        ]
        var chartData = [[Double?]](repeating: [], count: chartLabel.count)

        let count = json.count

        var currentCount = 0

        for i in 0..<count {
            let value = json[i]

//            if i == count - 1 {
//                setupRows(value)
//            }
            if let annual = value["annual"] as? Bool, annual == true {
                continue
            }

            if currentCount == 4 {
                break
            }

            for (j, label) in chartLabel.enumerated() {
                chartData[j].insert(getDouble(value[label.rawValue]), at: 0)
            }
            var date: String = ""
            if let time = value[SSBoardDebtList.date.rawValue] as? String {
                date = time.seasonFormat()
            }
            xLabel.insert(date, at: 0)

            currentCount += 1
        }
        
        if currentCount == 0 {
            return nil
        }

        let legends = chartLabel.map {
            i18n("ticker.board.finance.debt.chart.legend." + $0.rawValue)
        }

        let colors: [UIColor] = [
            SSColor.c601.color,
            SSColor.c602.color,
            SSColor.c603.color
        ]

        let barData: [[String : Any]] = [
            ["values": chartData[0],
             "legend": legends[0],
             "color": colors[0],
             "valueType": 0],

            ["values": chartData[1],
             "legend": legends[1],
             "color": colors[1],
             "valueType": 0]
        ]

        let lineData: [[String : Any]] = [
            ["values": chartData[2],
             "legend": legends[2],
             "color": colors[2],
             "valueType": 1,
             "barDependency": 1]
        ]
        
        let barUnit = SSBoardFinanceModel.getUnit(chartData[0] + chartData[1])

        self.mainChartData = [
            "barData": barData,
            "lineData": lineData,
            "xLabel": xLabel,
            "barUnit": barUnit
        ]

        self.barUnit = barUnit
    }

    // 生成下面的row value
    func setupRows(_ json: JSON) {

        let labels: [SSBoardDebtList] = [
            .date,
            .CSTI,
            .totalAssets,
            .totalDebt,
            .totalLiabilities,
            .totalEquity
        ]

        for key in labels {
            let value = json[key.rawValue]
            rowValues.append(formatRowValue(value, key: key))
            rowLabels.append(key.i18N)
        }
    }

    func formatRowValue(_ value: Any?, key: SSBoardDebtList) -> String {
        // 并不是每个在为nil时都返回了String.nilValue，比如date
        switch key {
        case .date:
            return SSFormatter.formatTimeYMD(value)
        default:
            return SSFormatter.formatBig(value)
        }
    }
}

public enum SSBoardDebtList: String {
    case date = "reportTime"
    case CSTI = "csti"
    case totalAssets = "totalAssets"
    case totalDebt = "totalDebt"
    case totalEquity = "totalEquity"
    case margin = "debtMargin"
    case totalLiabilities = "totalLiabilities"
    case none
    
    var i18N: String {
        return i18n("ticker.board.finance.debt.row." + self.rawValue)
    }
}
