//
//  SSBoardFinanceDetail.swift
//  Common
//
//  Created by JunrenHuang on 22/3/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

public class SSBoardFinanceDetail: JSONMappable {

    public let isAnnual: Bool
    public let date: Date
    public let type: SSBoardFinanceType

    // 将来可能需要通过attr字段对titles和values整体排序
    public var values = [String]()
    public var titles = [String]()
    public var yoyValues = [String]()

    public required init?(_ json: JSON) {
        guard
            let annual = json["annual"] as? Bool,
            let reportDate = json["reportDate"] as? String,
            let date = reportDate.gmtDate(),
            let type = json["type"] as? Int,
            let financeType = SSBoardFinanceType(rawValue: type - 1)
            else {
                return nil
        }
        self.isAnnual = annual
        self.type = financeType
        self.date = date

        guard let struts = json["struts"] as? [JSON] else {
            return
        }

        let attrs = getAttrsByType(financeType)

        for attr in attrs {
            guard let json = struts.first(where: {
                if let value = $0["attr"] as? String, value == attr {
                    return true
                }
                return false
            }) else {
                continue
            }

            if let title = json["title"] as? String {
                titles.append(title)
            }

            let format: String
            if let fmat = json["fmat"] as? String {
                format = fmat
            } else {
                format = ""
            }

            let value: String
            if let v = json["value"] as? String {
                value = formatValue(v, format: format)
            } else {
                value = "-"
            }
            values.append(value)

            var yoyValue: String = ""
            if let yoy = json["yoyValue"] as? String {
                yoyValue = yoy.ss_percent()
            }
            yoyValues.append(yoyValue)
        }

        let pre = "ticker.finance.header."

        // 3 5 8 2 5
        let headers = getHeadersByType(financeType)
        let headerIndexes = SSBoardFinanceDetail.getHeaderIndexesByType(financeType)

        for (i, index) in headerIndexes.enumerated() {

            if values.count > index {
                values.insert("", at: index)
            }

            if !titles.isEmpty {
                let headerTitle = i18n(pre + headers[i])
                if titles.count > index {
                    titles.insert(headerTitle, at: index)
                }
            }
        }
    }

    func formatValue(_ value: String, format: String) -> String {
        switch format {
        case "d":
            return value.ymdFormat()
        case "ln":
            return value.financeFormat()
        default:
            return value
        }
    }

    public static func getHeaderIndexesByType(_ type: SSBoardFinanceType) -> [Int] {
        switch type {
        case .profit:

            // 3 5 8 2 5
            return [0, 4, 10, 19, 22]
        case .debt:

            // 16, 13, 9
            return [0, 17, 31]
        case .cash:

            // 8, 2, 6
            return [1, 10, 13]
        }
    }

    fileprivate func getHeadersByType(_ type: SSBoardFinanceType) -> [String] {
        switch type {
        case .profit:
            return [
                "revenue",
                "operating",
                "income",
                "net",
                "dilution"
            ]
        case .debt:
            return [
                "assets",
                "liabilities",
                "stockholders"
            ]
        case .cash:
            return [
                "operatingActivities",
                "investingActivities",
                "financingActivities"
            ]
        }
    }

    fileprivate func getAttrsByType(_ type: SSBoardFinanceType) -> [String] {
        switch type {
        case .profit:

            // 3 5 8 2 5
            return [
                //Revenue
                "totalRevenue",
                "costOfRevenue",
                "grossProfit",

                //Operating Expenses
                "sellingGeneralAdmin",
                "unusualExpense",
                "totalOperating",
                "otherOperating",
                "operatingIncome",

                //Income from Continuing Operations
                "interest-Operating",
                "saleOfAssets",
                "netBeforeTaxes",
                "incomeAfterTaxes",
                "incomeBeforeExtraItems",
                "provisionforIncome",
                "minorityInterest",
                "otherNet",

                //Net Income
                "netIncome",
                "availableToComExcl",

                //Dilution Adjustment
                "dilutedNormalizedEPS",
                "dilutedNetIncome",
                "dilutedWeightedAverage",
                "dilutedEpsExtraOrd",
                "dPSStockPrimaryIssue"
            ]

        case .debt:
            return [

                // 16, 13, 9
                "cashShortInvest",
                "cash",
                "totalReceivables",
                "accountsReceivable",
                "totalInventory",
                "prepaidExpenses",
                "otherCurrentAssets",
                "totalCurrentAssets",
                "longInvestments",
                "Property_Plant_Equipment_NET",
                "propertyPlantEquipment",
                "goodwillNet",
                "intangiblesNet",
                "accumulatedDepreciation",
                "otherLongAssets",
                "totalAssets",

                "accountsPayable",
                "accruedExpenses",
                "notesPayableShort",
                "currentPortCapital",
                "otherCurrentLiabili",
                "totalCurrentLiabili",
                "totalLongDebt",
                "longTermDebt",
                "totalDebt",
                "deferredIncomeTax",
                "minorityInterest",
                "otherLiabiliTotal",
                "totalLiabilities",

                "commonStockTotal",
                "additionalPaid",
                "retainedEarnings",
                "treasuryStock",
                "otherEquityTotal",
                "totalLiabiliEquity",
                "totalSharesOutst",
                "tangibleValuePer",
                "totalEquity"
            ]
            
        case .cash:
            return [
                "income_Starting",
                
                // 8, 2, 6
                "depreciationDepletion",
                "amortization",
                "nonCashItems",
                "cashTaxesPaid",
                "changesWorkCapital",
                "cashFromOper",
                "cashFromInvest",
                "cashFromFinance",
                
                "capitalExpend",
                "otherInvestCashTotal",
                
                "financingCash",
                "cashDividPaid",
                "retirementStockNet",
                "issuanceOfNet",
                "foreignEffects",
                "netChangeCash"
            ]
        }
    }
}
