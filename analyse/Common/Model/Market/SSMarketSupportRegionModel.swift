

//
//  SSMarketSupportRegionModel.swift
//  Common
//
//  Created by Hugo on 2017/7/24.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import UIKit
import Networking

public class SSMarketSupportRegionModel: JSONMappable, Copying {
    
    public var labelId: Int64 = 0
    public var label: String = ""
    public var regions: [SSRegion] = []
    
    
    required public init?(_ json: JSON) {
        guard let labelId = json["labelId"] as? Int64,
              let label = json["label"] as? String else {
            return nil
        }
        self.labelId = labelId
        self.label = label
        
        guard let jsons = json["regions"] as? [JSON] else {
            return
        }
        
        for regionJson in jsons {
            if let region = SSRegion(regionJson) {
                self.regions.append(region)
            }
        }
    }
    
    required public init(original: SSMarketSupportRegionModel) {
        self.labelId = original.labelId
        self.label = original.label
        self.regions = original.regions.clone()
    }
}
