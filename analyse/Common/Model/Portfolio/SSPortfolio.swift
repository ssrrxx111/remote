//
//  SSPortfolio.swift
//  stocks-ios
//
//  Created by Eason Lee on 07/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

public enum PortfolioOrderType: Int64 {

    case normal = 0
    case priceUp = 1
    case priceDown = 2
    case changeUp = 3
    case changeDown = 4
    case nameSymbolUp = 5
    case nameSymbolDown = 6

}

public enum PortfolioChangeType: Int64 {

    case percent = 0
    case price = 1

}

public protocol SSPortfolioDelegate: NSObjectProtocol {

    func didAddNewTicker(_ ticker: SSTickerTuple, isHotTicker: Bool)

    func didUpdate()

}

public class SSPortfolio {

    /// user uuid
    public var owner: String = "currentDevice"

    public var isDeviceOwned: Bool {
        return owner == "currentDevice"
    }

    public var portfolioID = ""
    public var name = ""

    /// default USD
    public var currencyID: Int64 = 247 {
        didSet {
            _currency = nil
        }
    }

    private var _currency: SSCurrency?
    public var currency: SSCurrency {

        if let c = _currency {
            return c
        }

        let c = SSCurrency.defaultCurrencies.first(where: { $0.id == currencyID })
        _currency = c
        return c ?? SSCurrency.default
    }

    public var syncStatus: Int64 = 0
    public var operationTime: Date?

    /// 多组合排序标记
    public var multiSortOrder: Int64

    /// 组合内标的物排序类型
    public var sortOrder: Int64 {
        return orderType.rawValue
    }

    /// 组合内标的物涨跌类型
    public var changeValue: Int64 {
        return changeType.rawValue
    }

    /// 当前标的物名称语言
    public var languageCode: String
    
    public var orderType: PortfolioOrderType

    public var changeType: PortfolioChangeType = .percent {
        didSet {
            _orderCaches.removeValue(forKey: PortfolioOrderType.changeUp)
            _orderCaches.removeValue(forKey: PortfolioOrderType.changeDown)
        }
    }

    public var tickers = Set<SSPortfolioTicker>()

    public weak var delegate: SSPortfolioDelegate?

    /// default portfolio
    public init() {
        portfolioID = Utils.mongoObjectID()
        name = i18n("portfolio.default.empty.title")
        orderType = .normal
        // default portfolio info is english.
        languageCode = "en"
        multiSortOrder = 0
    }

    public init(name: String,
                currencyID: Int64,
                multiSortOrder: Int64,
                uuid: String?) {
        self.portfolioID = Utils.mongoObjectID()
        self.name = name
        self.currencyID = currencyID
        self.orderType = .normal
        self.languageCode = StocksConfig.language.value
        self.multiSortOrder = multiSortOrder
        if let uuid = uuid {
            self.owner = uuid
        }
    }

    // MARK: - Order cache

    private var _cacheTickers: [SSPortfolioTicker]?

    // only normal order
    public var sortedTickers: [SSPortfolioTicker] {

        if let cacheTickers = _cacheTickers {
            return cacheTickers
        }

        _cacheTickers = Array(tickers).sorted(by: { $0.order < $1.order })
        return _cacheTickers!
    }

    public var isNamePriority: Bool {
        return StocksConfig.appearance.titleStyle == .name
    }

    fileprivate lazy var _orderCaches = [PortfolioOrderType: [SSPortfolioTicker]]()

    public var isOrderinng: Bool = false

    public func clearOrderCache() {
        _cacheTickers = nil
        _orderCaches.removeAll()
    }

    public func tickers(_ type: PortfolioOrderType) -> [SSPortfolioTicker] {

        isOrderinng = true
        defer {
            isOrderinng = false
        }

        switch orderType {
        case .nameSymbolUp:
            if let cache = _orderCaches[PortfolioOrderType.nameSymbolUp] {
                return cache
            } else {
                let isChinese = languageCode.contains("zh")
                let cache = tickers.sorted(by: { t1, t2 in
                    if self.isNamePriority {
                        if isChinese {
                            return t1.tickerTuple.name.firstCharacter() > t2.tickerTuple.name.firstCharacter()
                        } else {
                            return t1.tickerTuple.name > t2.tickerTuple.name
                        }
                    } else {
                        return t1.tickerTuple.symbol > t2.tickerTuple.symbol
                    }
                })
                _orderCaches[PortfolioOrderType.nameSymbolUp] = cache
                return cache
            }
        case .nameSymbolDown:
            if let cache = _orderCaches[PortfolioOrderType.nameSymbolDown] {
                return cache
            } else {
                let isChinese = languageCode.contains("zh")
                let cache = tickers.sorted(by: { t1, t2 in
                    if self.isNamePriority {
                        if isChinese {
                            return t1.tickerTuple.name.firstCharacter() < t2.tickerTuple.name.firstCharacter()
                        } else {
                            return t1.tickerTuple.name < t2.tickerTuple.name
                        }
                    } else {
                        return t1.tickerTuple.symbol < t2.tickerTuple.symbol
                    }
                })
                _orderCaches[PortfolioOrderType.nameSymbolDown] = cache
                return cache
            }
        case .priceUp:
            let cache = tickers.sorted(by: { t1, t2 in
                if t1.realtime == nil { return false }
                if t2.realtime == nil { return true }
                return t1.realtime!.priceValue < t2.realtime!.priceValue
            })
            return cache
//            if let cache = _orderCaches[PortfolioOrderType.priceUp] {
//                return cache
//            } else {
//                let cache = tickers.sorted(by: { t1, t2 in
//                    if t1.realtime == nil { return false }
//                    if t2.realtime == nil { return true }
//                    return t1.realtime!.priceValue < t2.realtime!.priceValue
//                })
//                _orderCaches[PortfolioOrderType.priceUp] = cache
//                return cache
//            }
        case .priceDown:
            let cache = tickers.sorted(by: { t1, t2 in
                if t1.realtime == nil { return false }
                if t2.realtime == nil { return true }
                return t1.realtime!.priceValue > t2.realtime!.priceValue
            })
            return cache
//            if let cache = _orderCaches[PortfolioOrderType.priceDown] {
//                return cache
//            } else {
//                let cache = tickers.sorted(by: { t1, t2 in
//                    if t1.realtime == nil { return false }
//                    if t2.realtime == nil { return true }
//                    return t1.realtime!.priceValue > t2.realtime!.priceValue
//                })
//                _orderCaches[PortfolioOrderType.priceDown] = cache
//                return cache
//            }
        case .changeUp:
            let cache = tickers.sorted(by: { t1, t2 in
                if t1.realtime == nil { return false }
                if t2.realtime == nil { return true }
                return t1.realtime!.changeRatioValue < t2.realtime!.changeRatioValue
            })
            return cache
//            if let cache = _orderCaches[PortfolioOrderType.changeUp] {
//                return cache
//            } else {
//                let cache = tickers.sorted(by: { t1, t2 in
//                    if t1.realtime == nil { return false }
//                    if t2.realtime == nil { return true }
//                    return t1.realtime!.changeRatioValue < t2.realtime!.changeRatioValue
//                })
//                _orderCaches[PortfolioOrderType.changeUp] = cache
//                return cache
//            }
        case .changeDown:
            let cache = tickers.sorted(by: { t1, t2 in
                if t1.realtime == nil { return false }
                if t2.realtime == nil { return true }
                return t1.realtime!.changeRatioValue > t2.realtime!.changeRatioValue
            })
            return cache
//            if let cache = _orderCaches[PortfolioOrderType.changeDown] {
//                return cache
//            } else {
//                let cache = tickers.sorted(by: { t1, t2 in
//                    if t1.realtime == nil { return false }
//                    if t2.realtime == nil { return true }
//                    return t1.realtime!.changeRatioValue > t2.realtime!.changeRatioValue
//                })
//                _orderCaches[PortfolioOrderType.changeDown] = cache
//                return cache
//            }
        default:
            return sortedTickers
        }
    }

    // MARK: Server relate methods

    required public init?(_ json: [String: Any],
                          isRemote: Bool = false,
                          uuid: String? = nil) {

        guard
            let id = json["portfolioId"] as? String,
            let name = json["name"] as? String
            // let currencyId = json["currencyId"] as? Int64
            else { return nil }

        self.portfolioID = id
        self.name = name
        self.operationTime = (json["operationTime"] as? String)?.gmtDate()

        self.languageCode = json["languageCode"] as? String ?? StocksConfig.language.value

        if let currencyID = json["currencyId"] as? Int64 {
            self.currencyID = currencyID
        }

        if isRemote {
            self.multiSortOrder = json["sortOrder"] as? Int64 ?? 0
            self.orderType = .normal
            self.changeType = .percent

            if let _uuid = uuid {
                self.owner = _uuid
            }

            if let tickersData = json["tickerList"] as? [[String: Any]] {
                mapperTickers(tickersData)
            }
        } else {

            if let _owner = json["owner"] as? String {
                self.owner = _owner
            }

            self.multiSortOrder = json["multiSortOrder"] as? Int64 ?? 0
            let order = json["sortOrder"] as? Int64 ?? 0
            let change = json["changeValue"] as? Int64 ?? 0
            self.orderType = PortfolioOrderType(rawValue: order) ?? .normal
            self.changeType = PortfolioChangeType(rawValue: change) ?? .percent
        }
    }

    fileprivate func mapperTickers(_ json: [[String: Any]]) {

        var newTickers = [SSPortfolioTicker]()

        for item in json {

            guard
                let timeStr = item["operationTime"] as? String,
                let date = timeStr.gmtDate(),
                let objectID = item["id"] as? String,
                let info = SSTickerSummaryInfo(item) else {

                    SSLog("Ticker data error")
                    SSLog(item)
                    continue
            }

            let order = item["sortOrder"] as? Int64 ?? 0

            var tuple = SSTickerTuple(info)
            tuple.showCode = item["disExchangeCode"] as? String ?? item["showCode"] as? String ?? ""
            tuple.regionID = item["regionId"] as? Int64 ?? 0
            tuple.exchangeCode = item["exchangeCode"] as? String ?? ""
            tuple.currencyID = item["currencyId"] as? Int64 ?? 0
            tuple.exchangeTrade = item["exchangeTrade"] as? Bool
            tuple.secType = item["secType"] as? [Int64] ?? []
            tuple.fundSecType = item["fundSecType"] as? [Int64] ?? []

            let ticker = SSPortfolioTicker(tuple,
                                           objectID: objectID,
                                           realtime: nil,
                                           order: order,
                                           operationTime: date)
            newTickers.append(ticker)
        }

        self.tickers = Set(newTickers)
    }

    // to server json
    public func toJSON(_ order: Int64? = nil) -> [String: Any] {
        var json = [String: Any]()
        json["currencyId"] = currencyID
        json["name"] = name
        json["portfolioId"] = portfolioID

        if let _order = order {
            json["sortOrder"] = _order
        } else {
            json["sortOrder"] = multiSortOrder
        }

        json["operationTime"] = (operationTime ?? Date()).gmtFormat
        return json
    }
}

extension SSPortfolio: Hashable {

    public var hashValue: Int {
        return name.hashValue ^ portfolioID.hashValue
    }

    public static func ==(lhs: SSPortfolio, rhs: SSPortfolio) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
