//
//  StringUtils.swift
//  Common
//
//  Created by JunrenHuang on 1/3/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

public class StringUtils: NSObject {

    public class func getCurrencyDisplayName(id: Int) -> String? {
        return getCurrencyDisplay(id, key: NSLocale.Key.currencyCode)
    }

    public class func getCurrencyDisplayName(currenySymbol: String) -> String? {
        let locale = StocksConfig.language.locale as NSLocale
        return locale.displayName(forKey: NSLocale.Key.currencyCode, value: currenySymbol)
    }

    public class func getCurrencyDisplaySymbol(_ id: Int) -> String? {
        return getCurrencyDisplay(id, key: NSLocale.Key.currencySymbol)
    }

    public class func getCurrencyDisplayCode(_ id: Int) -> String? {
        return nil
    }

    public class func getCurrencyDisplay(_ id: Int, key: NSLocale.Key) -> String? {

        return nil
    }
}
