//
//  NSData+JSON.swift
//  NewUstock
//
//  Created by Kyle on 16/6/13.
//  Copyright © 2016年 ustock. All rights reserved.
//

extension Data {

    public func toJSONString() -> String? {
       return NSString(data: self, encoding: String.Encoding.utf8.rawValue)! as String
    }

}
