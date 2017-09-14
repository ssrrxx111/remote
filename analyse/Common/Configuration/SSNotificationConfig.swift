//
//  SSNotificationConfig.swift
//  Common
//
//  Created by Eason Lee on 2017/2/21.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import Foundation

public struct SSNotificationConfig {

    internal static let shared = SSNotificationConfig()

    private init() {}

    /// 股价提醒
    public var stockWarning: Toggle {
        if let value = config.value(of: .stockWarning) as? Int {
            return Toggle.value(value)
        } else {
            config.set(.stockWarning, value: Toggle.on.rawValue)
            return .on
        }
    }
}
