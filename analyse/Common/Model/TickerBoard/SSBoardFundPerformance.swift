//
//  SSBoardFundPerformance.swift
//  Common
//
//  Created by Ze乐 on 2017/4/28.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import Foundation
import Networking

public struct SSBoardFundPerformanceModel: JSONMappable {
    
    public var fundDuring: String = ""
    public var boardFundPerformance = [SSBoardFundPerformance]()
    public init?(_ json: JSON) {
        guard
            let allFundPerformance = json["fundPerforms"] as? [JSON]
            else {
                return nil
        }
        
        fundDuring = json["during"] as? String ?? ""
        
        for FundPerformance in allFundPerformance {
            if let element = SSBoardFundPerformance(FundPerformance) {
                boardFundPerformance.append(element)
            }
        }
    }
}

public struct SSBoardFundPerformance: JSONMappable {
    
    public var time: String?
    public var ratio: String?
    public var ratioColor: UIColor?
    public var rank: String?
    
    public init?(_ json: JSON) {
        
        self.time = json["during"] as? String ?? String.nilValue
        let ratioString = json["applies"] as? String ?? String.nilValue
        self.ratio = ratioString.ss_signPercent()
        self.ratioColor = ratioString.ss_textColor
        self.rank = json["ranking"] as? String ?? String.nilValue
        if self.rank == "" {
            self.rank = String.nilValue
        }
    }
}
