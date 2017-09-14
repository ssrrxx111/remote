//
//  SSTickerTuple.swift
//  stocks-ios
//
//  Created by Eason Lee on 05/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

public struct SSTickerTuple: JSONMappable {

    public var json: JSON = [:]
    
    public var id: Int64
    public var type: Int64

    public var name = ""
    public var symbol = ""

    public var showCode = ""
    public var exchangeID: Int64 = 0
    public var exchangeCode = ""
    public var exchangeName = ""
    
    public var currencyID: Int64? = 0

    public var regionAreaCode = ""
    public var regionAlias = ""
    public var regionID: Int64 = 0
    public var regionName = ""

    /// 1正常 3退市
    public var listStatus: Int64 = 0
    public var secType = [Int64]()
    public var fundSecType = [Int64]()

    /// 历史记录时间
    public var updateTime: Double?

    public var exchangeTrade: Bool?
    
    /// 期货状态,0正常,1已过期,2无行情数据
    public var futuresStatus: Int64 = -1
    /// 期货字段,2商品月份合约 3商品c1 4商品c2 5商品c3 6商品c4 63商品v1
    public var futuresType: Int64 = 0
    /// 期货字段,所属群组id
    public var futuresGroupsId: Int64 = 0
    /// 期货字段,到期日
    public var futuresExpireDate: String = ""
    
    /// 商品品类有的字段
    public var groupsId: Int64 = 0
    public var countryISOCode: String = ""
    /// etf相关字段
    public var sort: Int64 = 0
    
    public init(
        name: String,
        type: Int64,
        symbol: String,
        id: Int64,
        showCode: String?,
        currencyID: Int64?,
        exchangeTrade: Bool? = nil)
    {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.type = type

        if let showCode = showCode {
            self.showCode = showCode
        }

        if let currency = currencyID {
            self.currencyID = currency
        }
        
        self.exchangeTrade = exchangeTrade
    }

    public init?(messageJson json: JSON) {
        guard
            let id = json["tickerId"] as? Int64,
            let type = json["type"] as? Int64
            else { return nil }
        
        self.json = json
        
        self.id = id
        self.type = type
        
        self.name = json["name"] as? String ?? ""
        if self.name.isEmptyOrNil() {
            self.name = json["tickerName"] as? String ?? ""
        }
        self.symbol = json["disSymbol"] as? String ?? json["symbol"] as? String ?? ""
        self.exchangeCode = json["exchangeCode"] as? String ?? ""
        self.currencyID = json["currencyId"] as? Int64 ?? 0
    }
    
    public init?(_ json: JSON) {

        guard
            let id = json["tickerId"] as? Int64,
            let type = json["tickerType"] as? Int64
            else { return nil }

        self.id = id
        self.type = type

        self.convertJSONData(json)
    }
    
    public init? (marketJson json: JSON) {
        guard let id = json["tickerId"] as? Int64 else {
            return nil
        }
        self.id = id
        self.type = json["type"] as? Int64 ?? (json["tickerType"] as? Int64 ?? 0)

        self.convertJSONData(json)
    }
    

    public var showTitle: String {
        if StocksConfig.appearance.titleStyle == .name {
            return name
        } else {
            return symbol + " " + showCode
        }
    }

    public var showSubTitle: String {
        if StocksConfig.appearance.titleStyle == .name {
            return symbol + " " + showCode
        } else {
            return name
        }
    }

    public init(_ ticker: SSTickerSummaryInfo) {
        self.id = ticker.id
        self.type = ticker.type
        self.name = ticker.name
        self.symbol = ticker.symbol
    }

    public mutating func update(_ ticker: SSTickerSummaryInfo) {
        self.id = ticker.id
        self.type = ticker.type
        self.name = ticker.name
        self.symbol = ticker.symbol
    }
    
    private mutating func convertJSONData(_ json: JSON) {
        self.name = json["name"] as? String ?? (json["tickerName"] as? String ?? "")
        self.symbol = json["disSymbol"] as? String ?? json["tickerSymbol"] as? String ?? (json["symbol"] as? String ?? "")
        self.showCode = json["disExchangeCode"] as? String ?? json["showCode"] as? String ?? ""
        self.exchangeID = json["exchangeId"] as? Int64 ?? 0
        self.exchangeCode = json["exchangeCode"] as? String ?? (json["exChangeCode"] as? String ?? "")
        self.exchangeName = json["exchangeName"] as? String ?? ""
        self.currencyID = json["currencyId"] as? Int64
        
        self.regionAreaCode = json["regionAreaCode"] as? String ?? ""
        self.regionAlias = json["regionAlias"] as? String ?? ""
        self.regionID = json["regionId"] as? Int64 ?? 0
        self.regionName = json["regionName"] as? String ?? ""
        
        self.countryISOCode = json["countryISOCode"] as? String ?? (json["countryIsoCode"] as? String ?? (json["regionIsoCode"] as? String ?? ""))
        
        self.listStatus = json["listStatus"] as? Int64 ?? 0
        self.secType = json["secType"] as? [Int64] ?? []
        self.fundSecType = json["fundSecType"] as? [Int64] ?? []
        
        self.updateTime = json["updateTime"] as? Double
        
        if let exchangeTrade = json["exchangeTrade"] as? Bool {
            self.exchangeTrade = exchangeTrade
        }
        
        self.futuresStatus = json["futuresStatus"] as? Int64 ?? -1
        self.futuresType = json["futuresType"] as? Int64 ?? 0
        self.futuresGroupsId = json["futuresGroupsId"] as? Int64 ?? 0
        self.futuresExpireDate = json["futuresExpireDate"] as? String ?? ""
        
        self.groupsId = json["groupsId"] as? Int64 ?? 0
        self.sort = json["sort"] as? Int64 ?? 0
        
        // code显示的既往规则: 有showCode 显示showCode,否则exChangeCode,现更新为优先展示disExchangeCode
        self.showCode = self.showCode.isEmptyOrNil() ? self.exchangeCode : self.showCode
    }
}

public extension SSTickerTuple {
    public var canTrade: Bool {
        guard
            let tickerType = SSTickerType(rawValue: Int(self.type))
            else {
                return false
        }

        if tickerType == .stock || fundType == .ETF || fundType == .NonMUTF {
            return true
        }

        return false
    }

//    public var hasTradeDetail: Bool {
//        return canTrade &&
//            (showCode == "BOM" || showCode == "NSE" || showCode == "SHE" || showCode == "SHA")
//    }

    public var canAddShare: Bool {
        guard
            let tickerType = SSTickerType(rawValue: Int(self.type))
            else {
                return false
        }

        if tickerType == .stock {
            return true
        }

        if tickerType == .fund {
            for index in [1, 2, 4] {
                if secType.contains(Int64(index)) {
                    return true
                }
            }
        }

        return false
    }

    public var hasTimeShare: Bool {
        guard
            let tickerType = SSTickerType(rawValue: Int(self.type))
            else {
                return false
        }

        if tickerType == .fund {
            let type = fundType
            if type == .MUTF {
                return false
            }
        }
        return true
    }

    public func isCN() -> Bool {
        
        // 国内商品按海外模版展示
        if type == 4 {
            for sec in secType {
                let secs = [40, 41, 42]
                return !secs.contains(Int(sec))
            }
        }
        
        if countryISOCode == "CN" { return true }
        
        let exs = ["SHH", "SHZ", "IDXSHE", "IDXSSE", "MUTF_CN"]
        return exs.contains(exchangeCode)
    }
    
    public var displayName: Bool {
        //中文下A股、港股详情页展示股票名称，股指期货展示名称，否则展示symbol
        return (StocksConfig.language.isChinese && [1, 2].contains(self.regionID)) || self.type == Int64(SSTickerType.future.rawValue)
    }
    
    public var fundType: SSTickerFundType {

        guard
            let tickerType = SSTickerType(rawValue: Int(self.type)),
            tickerType == .fund
            else {
                return .none
        }

        if self.secType.contains(34) {
            return .ETF
        }

        if let exchangeTrade = self.exchangeTrade, exchangeTrade {
            return .NonMUTF
        }
        
        return .MUTF
    }
}



