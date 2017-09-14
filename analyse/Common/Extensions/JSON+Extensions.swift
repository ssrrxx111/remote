//
//  DictExtensions.swift
//  Common
//
//  Created by JunrenHuang on 6/2/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

extension Dictionary {

    public func rawString() -> String? {
        return Common.stringify(self)
    }
}

extension Array {

    public func rawString() -> String? {
        return Common.stringify(self)
    }
}

fileprivate func stringify(_ obj: Any) -> String? {

    guard JSONSerialization.isValidJSONObject(obj),
        let data = try? JSONSerialization.data(
            withJSONObject: obj,
            options: JSONSerialization.WritingOptions(rawValue: 0)
        ),
        let str = String(data: data, encoding: String.Encoding.utf8) else {
            return nil
    }

    return str
}
