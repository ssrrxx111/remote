//
//  SSTickerType.swift
//  Common
//
//  Created by JunrenHuang on 16/2/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

/// 个股类型
public enum SSTickerType: Int {

    /// 指数
    case index = 1
    /// 股票
    case stock
    /// 基金
    case fund
    /// 商品期货
    case future
    /// 债券
    case bond
    /// 外汇
    case currency
    /// 期权
    case option

    case none

    public func handicapLabels(fundType: SSTickerFundType) -> [String] {

        switch self {
        case .index:
            return [
                "open",
                "high",
                "fiftyTwoWkHigh",
                "preClose",
                "low",
                "fiftyTwoWkLow",
                "volume",
                "avgVol3M"
            ]
        case .fund:

            switch fundType {
            case .ETF:
                return [
                    "open",
                    "high",
                    "fiftyTwoWkHigh",
                    "preClose",
                    "low",
                    "fiftyTwoWkLow",
                    "volume",
                    "netAssets",
                    "mptBeta3Y",
                    "avgVol3M",
                    "ytdReturn",
                    "netExpenseRatio",
                    "msRating",
                    "yield1Y",
                    "inceptionDate"
                ]

            case .NonMUTF:
                return [
                    "open",
                    "high",
                    "fiftyTwoWkHigh",
                    "preClose",
                    "low",
                    "fiftyTwoWkLow",
                    "volume",
                    "netAssets",
                    "mptBeta3Y",
                    "avgVol3M",
                    "ytdReturn",
                    "pe",
                    "msRating",
                    "yield1Y",
                    "inceptionDate"
                ]
            default:
                return [
                    "preClose",
                    "netAssets",
                    "mptBeta3Y",
                    "anRepTurnRatio",
                    "return5Y",
                    "yield1Y",
                    "lerageRatio",
                    "ytdReturn",
                    "netExpenseRatio",
                    "msRating",
                    "inceptionDate"
                ]
            }
            
        case .future:
            return [
                "open",
                "high",
                "fiftyTwoWkHigh",
                "preClose",
                "low",
                "fiftyTwoWkLow",
                "settlement",
                "settlDate",
                "preSettlement"
            ]
        case .currency:
            return [
                "open",
                "high",
                "fiftyTwoWkHigh",
                "preClose",
                "low",
                "fiftyTwoWkLow"
            ]
        default:
            return [
                "open",
                "high",
                "fiftyTwoWkHigh",
                "preClose",
                "low",
                "fiftyTwoWkLow",
                "volume",
                "pe",
                "marketValue",
                "avgVol3M",
                "projPe",
                "eps",
                "beta",
                "dividend"
            ]
        }
    }
}

/// 基金类型
public enum SSTickerFundType: String {

    case ETF

    /// 场内基金
    case NonMUTF

    /// 场外基金
    case MUTF

    case none

    public var canTrade: Bool {
        return self == .NonMUTF
    }
}

/// 期货类型
public enum SSTickerFutureType: String {
    
    //商品
    case commodity
    //股指期货
    case index
    
}
