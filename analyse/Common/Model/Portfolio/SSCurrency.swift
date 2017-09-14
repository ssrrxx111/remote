//
//  SSCurrency.swift
//  Common
//
//  Created by Eason Lee on 2017/2/7.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import Foundation
import Networking

public struct SSCurrency: JSONMappable {

    public var id: Int64
    public var name: String
    public var symbol: String

    public var latin: String?

    public init?(_ json: JSON) {

        guard let id = json["id"] as? Int64,
            let name = json["name"] as? String,
            let symbol = json["symbol"] as? String else {
                return nil
        }

        self.id = id
        self.name = name
        self.symbol = symbol
    }

    private init() {
        self.id = 247
        self.name = "US Dollar"
        self.symbol = "USD"
    }

    public static var `default`: SSCurrency {

        return SSCurrency()
    }

    public static var defaultCurrencies: [SSCurrency] = {

        let objects = readJSON()

        var items = [SSCurrency]()
        for value in objects {
            if let item = SSCurrency(value) {
                items.append(item)
            }
        }

        return items
    }()

    private static func readJSON() -> [[String: Any]] {

        guard let path = Bundle.main.path(forResource: "DefaultCurrencies", ofType: "json"),
            let data = FileManager.default.contents(atPath: path),
            let json = try? JSONSerialization.jsonObject(with: data),
            let objects = json as? [[String: Any]] else {
                return []
        }

        return objects
    }
}
