//
//  SSSearchMapper.swift
//  stocks-ios
//
//  Created by Eason Lee on 04/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

public struct SSSearchMapper: JSONMappable {

    public var hasMore: Bool
    public var clientOrder: Int64
    public var categoryID: Int64
    public var categoryName: String

    public var list: [SSTickerTuple]

    public init?(_ json: JSON) {

        self.hasMore = json["hasMore"] as? Bool ?? false
        self.clientOrder = json["clientOrder"] as? Int64 ?? 0
        self.categoryID = json["categoryId"] as? Int64 ?? 0
        self.categoryName = json["categoryName"] as? String ?? ""

        if let listJSON = json["list"] as? [JSON] {
            self.list = listJSON.flatMap({ SSTickerTuple($0) })
        } else {
            self.list = []
        }
    }
}
