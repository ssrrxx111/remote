//
//  USEnumable.swift
//  FMBase
//
//  Created by Tank on 2017/3/7.
//  Copyright © 2017年 fumi. All rights reserved.
//

import Foundation

public func == < E: USEnumable> (lhs: E, rhs: E) -> Bool where E.RawValue == Int {
    return lhs.rawValue == rhs.rawValue
}

public protocol SettingAsyc {
    // 同步到服务器的值
    var value: AnyObject { get }
    // 同步到服务器的键
    static var key: String { get }
}

public protocol USEnumable: RawRepresentable, Equatable, Hashable, SettingAsyc {
    
    var i18n: String { get }
    var icon: UIImage? { get }
    static var defaultValue: Self { get }
    static var allValues: [Self] { get }
    static var title: String { get }
}

extension USEnumable where RawValue == Int {
    public var hashValue: Int {
        return self.rawValue.hashValue
    }
}
