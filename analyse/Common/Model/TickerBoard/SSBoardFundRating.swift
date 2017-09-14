//
//  SSBoardFundRating.swift
//  Common
//
//  Created by Ze乐 on 2017/4/28.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import Foundation
import Networking

public struct SSBoardFundRating: JSONMappable {
    
    public var date: String?
    public var agency: String?
    public var period: String?
    public var star: Int?
    
    public init?(_ json: JSON) {
        
        self.date = json["ratingDate"] as? String ?? String.nilValue
        self.agency = json["rating"] as? String ?? String.nilValue
        self.period = json["ratingCycle"] as? String ?? String.nilValue
        self.star = json["ratingResults"] as? Int ?? 0
    }
}
