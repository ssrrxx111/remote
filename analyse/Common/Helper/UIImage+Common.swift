//
//  UIImage+Common.swift
//  Common
//
//  Created by webull on 2017/7/10.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import Foundation

extension UIImage {
    
    public static func commonImage(_ named: String) ->UIImage? {
        let bundle = Bundle(for: StockCommon.self)
        return UIImage(named: named, in: bundle, compatibleWith: nil)
    }
}
