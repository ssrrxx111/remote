//
//  BaseOjectModel.swift
//  NewUstock
//
//  Created by Kyle on 16/5/24.
//  Copyright © 2016年 ustock. All rights reserved.
//

import ObjectMapper

open class BaseObjectModel: NSObject, Mappable {

    public override init() {
        super.init()
    }

    public required init?(map: Map) {

    }

    open func mapping(map: Map) {

    }
    
    #if ForRealm
    func save() -> Object {
        fatalError("save to data base must be implement")
    }
    #endif
}
