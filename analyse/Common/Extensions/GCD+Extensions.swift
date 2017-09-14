//
//  GCDExtensions.swift
//  Common
//
//  Created by Eason Lee on 2017/3/6.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import Foundation

extension DispatchTime: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }

}

extension DispatchTime: ExpressibleByFloatLiteral {

    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }

}
