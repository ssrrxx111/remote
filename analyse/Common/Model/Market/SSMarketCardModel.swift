//
//  SSMarketCardModel.swift
//  stocks-ios
//
//  Created by Hugo on 16/6/22.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit
import Networking

open class SSMarketCardModel: JSONMappable {

	public var id: Int = 0
	public var name: String = ""
	public var type: Int = 0
	public var stockList: [SSMarketStockModel] = []

    required public init?(_ json: JSON) {
        self.id = json["id"] as? Int ?? 0
        if self.id == 0 {
            // 兼容全球指数
            self.id = json["labelId"] as? Int ?? 0
        }
        self.name = json["name"] as? String ?? ""
        if self.name == "" {
            self.name = json["regionLabelName"] as? String ?? ""
        }
        self.type = json["type"] as? Int ?? 0
        self.stockList = getStockList(list: json["tickerTupleArrayList"])
        if self.stockList.count == 0 {
            // 兼容商品
            self.stockList = getStockList(list: json["tickerTupleList"])
        }
        if self.stockList.count == 0 {
            // 兼容全球指数
            self.stockList = getStockList(list: json["marketIndexList"])
        }
    }
    
    fileprivate func getStockList(list: Any?) -> [SSMarketStockModel] {
        var stocks = [SSMarketStockModel]()
        guard let array = list as? [JSON] else {
            return stocks
        }
        
        for json in array {
            if let stock = SSMarketStockModel(json) {
                stocks.append(stock)
            }
        }
        return stocks
    }
}
