//
//  ArrayExtensions.swift
//  stocks-ios
//
//  Created by Eason Lee on 06/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

extension Array where Element: CustomStringConvertible {

    public func toString() -> String {
        return self.map{ e in
            return "\(e)"
            }.joined(separator: ",")
    }
}
