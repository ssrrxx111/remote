//
//  SSBoardFinanceDebt.swift
//  Common
//
//  Created by JunrenHuang on 14/2/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

public class SSBoardFinanceCash: SSBoardFinanceModel {

    public override init?(_ json: [JSON], type: Any?) {

        super.init(json, type: type)

        var xLabel = [String]()

        let chartLabel: [SSBoardCashList] = [
            .CFOA,
            .CFIA,
            .CFFA
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
            if let time = value[SSBoardCashList.date.rawValue] as? String {
                date = time.seasonFormat()
            }
            xLabel.insert(date, at: 0)

            currentCount += 1
        }
        
        if currentCount == 0 {
            return nil
        }

        let legends = chartLabel.map {
            i18n("ticker.board.finance.cash.chart.legend." + $0.rawValue)
        }

        let colors: [UIColor] = [
            SSColor.c601.color,
            SSColor.c602.color,
            SSColor.c603.color
        ]

        let barData: [[String : Any]] = []

        var lineData = [[String : Any]]()

        var allData = [Double?]()

        for data in chartData {
            allData.append(contentsOf: data)
        }

        let barUnit = SSBoardFinanceModel.getUnit(allData)

        for i in 0..<legends.count {

            chartData[i] = chartData[i].map({ SSBoardFinanceModel.convertDouble($0, unit: barUnit) })
            let data: [String : Any] = [
                "values": chartData[i],
                "legend": legends[i],
                "color": colors[i],
                "valueType": 0
            ]
            lineData.append(data)
        }

        //let barUnit = SSBoardFinanceModel.getUnit(allData)

        self.mainChartData = [
            "barData": barData,
            "lineData": lineData,
            "xLabel": xLabel,
            "barUnit": barUnit
        ]

        self.barUnit = barUnit

//        self.mainChartData = [
//            "barData": barData,
//            "lineData": lineData,
//            "xLabel": xLabel
//        ]
    }

    // 生成下面的row value
    func setupRows(_ json: JSON) {

        let labels: [SSBoardCashList] = [
            .date,
            .CFOA,
            .CFIA,
            .CFFA,
            .NCIC
        ]

        for key in labels {
            let value = json[key.rawValue]
            rowValues.append(formatRowValue(value, key: key))
            rowLabels.append(key.i18N)
        }
    }

    func formatRowValue(_ value: Any?, key: SSBoardCashList) -> String {
        // 并不是每个在为nil时都返回了String.nilValue，比如date
        switch key {
        case .date:
            return SSFormatter.formatTimeYMD(value)
        default:
            return SSFormatter.formatBig(value)
        }
    }
}

public enum SSBoardCashList: String {
    case date = "reportTime"
    case CFOA = "cfoa"
    case CFIA = "cfia"
    case CFFA = "cffa"
    case NCIC = "ncic"
    case none
    
    var i18N: String {
        return i18n("ticker.board.finance.cash.row." + self.rawValue)
    }
}
