//
//  SSBoardFinanceProfit.swift
//  Common
//
//  Created by JunrenHuang on 14/2/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

public class SSBoardFinanceProfit: SSBoardFinanceModel {

    public override var chartCount: Int {
        if annualData.count > 1 && mainChartData.count > 0 {
            return 2
        } else {
            if annualData.count < 1 && mainChartData.count < 1 {
                return 0
            }
        }
        return 1
    }

    // annual
    public var annualData = [String : Any]()

    public override init?(_ json: [JSON], type: Any?) {

        super.init(json, type: type)

        var xLabel = [String]()
        var annualXLabel = [String]()

        let chartLabel: [SSBoardProfitList] = [
            .total,
            .netIncome,
            .margin,
            .operating,
            .operatingMargin,
            .riseRate
        ]
        var chartData = [[Double?]](repeating: [], count: chartLabel.count)
        var annualData = [[Double?]](repeating: [], count: chartLabel.count)

        let count = json.count

        var currentCount = 0
        var annualCount = 0
        
        var lastIncome: Double?
        
        for i in 0..<count {
            let value = json[count - i - 1]

            if let annual = value["annual"] as? Bool, annual == true {
                
                if let last = lastIncome, let newIncome = getDouble(value[SSBoardProfitList.total.rawValue]) {
                    
                    lastIncome = newIncome
                    
                    for (j, label) in chartLabel.enumerated() {
                        if annualData[j].count > 3 {
                            annualData[j].remove(at: 0)
                        }
                        if j == 5 {
                            let riseRate = (newIncome - last) / last
                            annualData[j].append(riseRate)
                        } else {
                            annualData[j].append(getDouble(value[label.rawValue]))
                        }
                    }
                    var date: String = ""
                    if let time = value[SSBoardProfitList.date.rawValue] as? String {
                        date = time.yearFormat()
                    }
                    if annualXLabel.count > 3 {
                        annualXLabel.remove(at: 0)
                    }
                    annualXLabel.append(date)
                    
                    annualCount += 1
                } else {
                    if let newIncome = getDouble(value[SSBoardProfitList.total.rawValue]) {
                        lastIncome = newIncome
                    }
                }
                
                continue
            }

//            if currentCount == 4 {
//                continue
//            }

            for (j, label) in chartLabel.enumerated() {
                if chartData[j].count > 3 {
                    chartData[j].remove(at: 0)
                }
                chartData[j].append(getDouble(value[label.rawValue]))
            }
            var date: String = ""
            if let time = value[SSBoardProfitList.date.rawValue] as? String {
                date = time.seasonFormat()
            }
            if xLabel.count > 3 {
                xLabel.remove(at: 0)
            }
            xLabel.append(date)

            currentCount += 1
        }
        
        let colors: [UIColor] = [
            SSColor.c601.color,
            SSColor.c602.color,
            SSColor.c603.color
        ]
        
        let legends = chartLabel.map {
            i18n("ticker.board.finance.profit.chart.legend." + $0.rawValue)
        }
        
        let barUnit = SSBoardFinanceModel.getUnit(chartData[0] + chartData[1])
        
        if currentCount > 0 {
            
            
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
            
            self.mainChartData = [
                "barData": barData,
                "lineData": lineData,
                "xLabel": xLabel,
                "barUnit": barUnit
            ]

        }
        
        self.barUnit = barUnit

        if annualCount > 1 {
            let barData: [[String : Any]] = [
                ["values": annualData[0],
                 "legend": legends[0],
                 "color": colors[0],
                 "valueType": 0]
            ]
            
            let lineData: [[String : Any]] = [
                ["values": annualData[5],
                 "legend": legends[5],
                 "color": colors[2],
                 "valueType": 1,
                 "barDependency": 1]
            ]
            
            self.annualData = [
                "barData": barData,
                "lineData": lineData,
                "xLabel": annualXLabel,
                "barUnit": barUnit
            ]
        }
        
        guard self.chartCount > 0 else {
            return nil
        }
 
    }

    // 生成下面的row value
    func setupRows(_ json: JSON, isBank: Bool) {

        var labels: [SSBoardProfitList]

        // isBank没有.date，是否是bug??
        if isBank {
            labels = [
                .total,
                .interest,
                .nonInterest
            ]
        } else {
            labels = [
                .date,
                .total,
                .gross,
                .operating,
                .operatingMargin
            ]
        }
        labels.append(contentsOf: [
            .netIncome,
            .margin,
            .dps,
            .dneps
        ])

        for key in labels {
            let value = json[key.rawValue]
            rowValues.append(formatRowValue(value, key: key))
            rowLabels.append(key.i18N)
        }
    }

    func formatRowValue(_ value: Any?, key: SSBoardProfitList) -> String {
        // 并不是每个在为nil时都返回了String.nilValue，比如date
        switch key {
        case .date:
            return SSFormatter.formatTimeYMD(value)
        case .margin, .operatingMargin:
            return SSFormatter.formatPercent(value, sign: false)
        default:
            return SSFormatter.formatBig(value)
        }
    }

}

public enum SSBoardProfitList: String {
    case date = "reportTime"
    case total = "totalRevenue"
    case gross = "grossProfit"
    case operating = "operatingIncome"
    case dps = "dps"
    case netIncome = "netIncome"
    case dneps = "dneps"
    case margin = "profitMargin"
    case operatingMargin = "operatingMargin"

    // 和isBank相关，目前尚未用到
    case interest = "interestIncomeBank"
    case nonInterest = "nonInterestIncomeBank"
    case none
    
    case riseRate = "riseRate" //同比增长

    var i18N: String {
        let value = "ticker.board.finance.profit.row." + self.rawValue
        return i18n(value)
    }
}
