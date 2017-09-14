
//
//  SSLabel.swift
//  Common
//
//  Created by Hugo on 2017/5/23.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import UIKit
import YYText

open class SSLabel: YYLabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.displaysAsynchronously = true
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup() {
        self.isUserInteractionEnabled = false
    }
    
}
