//
//  File.swift
//  Common
//
//  Created by JunrenHuang on 27/4/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

public class SSBoardRecommendation: JSONMappable {

    public var rating: String?
    public var price: SSBoardRecommendationPrice?
    public var measures = [SSBoardRecommendationMeasure]()
    public var trends = [SSBoardRecommendationTrend]()
    public var invaliData: Bool = false

    public required init?(_ json: JSON) {

        if let measures = json["measures"]  as? [JSON] {
            for measure in measures {
                if let value = SSBoardRecommendationMeasure(measure) {
                    self.measures.append(value)
                }
            }
        }

        if let price = json["priceTarget"] as? JSON, let value = SSBoardRecommendationPrice(price) {
            self.price = value
        }

        self.rating = (json["rating"] as? String)

        if let trends = json["trends"] as? [JSON] {

            for trend in trends {
                if let value = SSBoardRecommendationTrend(trend) {
                    self.trends.insert(value, at: 0)
                }
            }
        }

    }

}

public class SSBoardRecommendationMeasure: JSONMappable {

    public let title: String
    public let value: String
    public required init?(_ json: JSON) {
        guard
            let title = json["title"] as? String,
            let value = json["value"] as? String,
            let number = json["numberOfAnalysts"] as? Int
        else {
            return nil
        }

        self.title = title + "(\(number))"
        self.value = value
    }
}
