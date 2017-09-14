//
//  SSBoardFundManager.swift
//  Common
//
//  Created by Ze乐 on 2017/5/27.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import Foundation
import Networking

public struct SSBoardFundManagerDetailModel: JSONMappable {
    
    public var name: String = String.nilValue
    public var resume: String = String.nilValue
    public var mfunds: [SSBoardFundManagerDetail] = []
    public var mfundsHis: [SSBoardFundManagerDetail] = []
    
    public init?(_ json: JSON) {
        
        self.name = json["name"] as? String ?? String.nilValue
        self.resume = json["resume"] as? String ?? String.nilValue
        if let mfunds = json["mfunds"] as? [JSON] {
            for element in mfunds {
                if let entry = SSBoardFundManagerDetail(element) {
                    self.mfunds.append(entry)
                }
            }
        }
        if let mfundsHis = json["mfundsHis"] as? [JSON] {
            for element in mfundsHis {
                if let entry = SSBoardFundManagerDetail(element) {
                    self.mfundsHis.append(entry)
                }
            }
        }
    }

}

public struct SSBoardFundManagerDetail: JSONMappable {
    
    public var fundId: Int64 = 0
    public var name: String = String.nilValue
    public var period: String = String.nilValue
    public var duration: String = String.nilValue
    public var data: JSON = [:]
    
    
    public init?(_ json: JSON) {
        
        self.fundId = json["fundId"] as? Int64 ?? 0
        self.name = json["fundName"] as? String ?? String.nilValue
        
        var string = ""
        var Start: String?
        var End: String?
        if let startString = json["start"] as? String {
            let startTime = startString.gmtDate() ?? Date()
            if Date().timeIntervalSince1970 - startTime.timeIntervalSince1970 > 10 {
                //判断取到了时间
                string = string + startTime.ymdFormat()
                Start = startString
            }
            string = string + " - "
            if let endString = json["end"] as? String {
                let endTime = endString.gmtDate() ?? Date()
                if Date().timeIntervalSince1970 - endTime.timeIntervalSince1970 > 10 {
                    //判断取到了时间
                    string = string + endTime.ymdFormat()
                    End = endString
                }
            }
        }
        if string.characters.count > 3 {
            self.period = string
        } else {
            self.period = String.nilValue
        }
        
        if let start = Start {
            var date: Date = Date()
            if let end = End {
                date = end.gmtDate() ?? Date()
            }
            
            self.duration = Date.yearDayFormatter(start: start.gmtDate() ?? Date(), end: date)
            
        } else {
            self.duration = String.nilValue
        }
        
        self.data = json
        
    }
    
}


public struct SSBoardFundManager: JSONMappable {
    
    public var managerId: Int64 = 0
    public var name: String = String.nilValue
    public var period: String = String.nilValue
    public var duration: String = String.nilValue
    public var data: JSON = [:]
    
    public init?(_ json: JSON) {
        
        self.managerId = json["managerId"] as? Int64 ?? 0
        self.name = json["name"] as? String ?? String.nilValue
        if let data = json["fundterm"] as? JSON {
            
            self.data = data
            
            var string = ""
            var Start: String?
            var End: String?
            if let startString = data["start"] as? String {
                let startTime = startString.gmtDate() ?? Date()
                if Date().timeIntervalSince1970 - startTime.timeIntervalSince1970 > 10 {
                    //判断取到了时间
                    string = string + startTime.ymdFormat()
                    Start = startString
                }
                string = string + " - "
                if let endString = data["end"] as? String {
                    let endTime = endString.gmtDate() ?? Date()
                    if Date().timeIntervalSince1970 - endTime.timeIntervalSince1970 > 10 {
                        //判断取到了时间
                        string = string + endTime.ymdFormat()
                        End = endString
                    }
                }
            }
            if string.characters.count > 3 {
                self.period = string
            } else {
                self.period = String.nilValue
            }
            
            if let start = Start {
                var date: Date = Date()
                if let end = End {
                    date = end.gmtDate() ?? Date()
                }
                
                self.duration = Date.yearDayFormatter(start: start.gmtDate() ?? Date(), end: date)
                
            } else {
                self.duration = String.nilValue
            }
        }
    }
}
