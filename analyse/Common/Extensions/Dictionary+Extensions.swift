//
//  Dictionary+Extensions.swift
//  Common
//
//  Created by LJC on 2017/08/09.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    public func toString() -> String? {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            
            return String(data: jsonData, encoding: String.Encoding.utf8)
            
        } catch {
            return nil
        }
        
        return nil
    }
}
