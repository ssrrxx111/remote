//
//  SSBoardIndexFuture.swift
//  Common
//
//  Created by Hugo on 2017/5/25.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import UIKit
import Networking

public enum SSBoardIndexFutureCellType {
    case header
    case cell
}

open class SSBoardIndexFutureComponent: NSObject {
    
    public var tickerTuple: SSTickerTuple?
    public var realTime: SSTickerRealtime?
    public var showType: SSBoardIndexFutureCellType = .cell
    public var headerId: Int64?
    public var headerName: String?
    
    public init?(_ json: JSON) {
        guard let tickerTuple = SSTickerTuple(marketJson: json) else {
            return nil
        }
        let realTime = SSTickerRealtime(indexJSON: json)
        self.tickerTuple = tickerTuple
        self.realTime = realTime
    }
    
    public init(indexFutureData: SSBoardIndexFutureData) {
        self.showType = .header
        self.headerName = indexFutureData.name
        self.headerId = indexFutureData.id
    }
}


open class SSBoardIndexFutureData: JSONMappable {
    
    public var id: Int64 = 0
    public var name: String = ""
    public var tickerTupleList: [SSBoardIndexFutureComponent] = []
    
    required public init?(_ json: JSON) {
        guard let id  = json["id"] as? Int64, let name = json["name"] as? String, let list = json["tickerTupleList"] as? [JSON], list.count > 0 else {
            return nil
        }
        self.id = id
        self.name = name
        
        var indexFutures = [SSBoardIndexFutureComponent]()
        for j in list {
            if let component = SSBoardIndexFutureComponent(j) {
                indexFutures.append(component)
            }
        }
        
        self.tickerTupleList = indexFutures
    }
}

