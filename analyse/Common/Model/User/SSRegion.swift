//
//  USRegion.swift
//  用户中心
//
//  Created by xw yin on 16/6/16.
//  Copyright © 2016年 WeBull. All rights reserved.
//

import Foundation
import Networking

public class SSRegion: NSObject, JSONMappable, Copying {

    public var id: Int = 0
    public var name = ""
    public var countryCallingCode = ""

    public var isoCode = ""

    public var mainCurrencyId: Int = 0
    public var selected = false

    public var latin: String = ""
    public var sysName: String = ""

    required override public init() {
        super.init()
    }

    public required init?(_ json: JSON) {

        super.init()
        guard let id = json["id"] as? Int else {
            return nil
        }

        self.id = id
        self.name = json["name"] as? String ?? ""
        self.countryCallingCode = json["countryCallingCode"] as? String ?? ""
        self.isoCode = json["isoCode"] as? String ?? ""
        self.mainCurrencyId = json["mainCurrencyId"] as? Int ?? 0
    }

    override public var description: String {
        return self.sysName
    }
    
    func update(_ region: SSRegion) {
        self.name = region.name
        self.countryCallingCode = region.countryCallingCode
        self.isoCode = region.isoCode
        self.mainCurrencyId = region.mainCurrencyId
        self.selected = region.selected
        self.sysName = region.sysName
    }

    func setupLatin() {
        
        guard let name = StocksConfig.language.locale.localizedString(forRegionCode: isoCode) else {
            return
        }

        self.sysName = name
        // 启动的时候这里调用了，因此要用异步做处理
        self.latin = name.ss_latinize()
    }
    
    public func toJSON() -> JSON {
        var json: JSON = [:]
        json["id"] = self.id
        json["name"] = self.name
        json["countryCallingCode"] = self.countryCallingCode
        json["isoCode"] = self.isoCode
        json["mainCurrencyId"] = self.mainCurrencyId
        return json
    }
    
    required public init(original: SSRegion) {
        self.id = original.id
        self.name = original.name
        self.countryCallingCode = original.countryCallingCode
        self.isoCode = original.isoCode
        self.mainCurrencyId = original.mainCurrencyId
    }
}

//Protocal that copyable class should conform
public protocol Copying {
    init(original: Self)
}

//Concrete class extension
public extension Copying {
    public func copy() -> Self {
        return Self.init(original: self)
    }
}

//Array extension for elements conforms the Copying protocol
public extension Array where Element: Copying {
    public func clone() -> Array {
        var copiedArray = Array<Element>()
        for element in self {
            copiedArray.append(element.copy())
        }
        return copiedArray
    }
}
