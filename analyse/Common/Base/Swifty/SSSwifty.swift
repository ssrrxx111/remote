//
//  SSSwifty.swift
//  stocks-ios
//
//  Created by Eason Lee on 04/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import class Foundation.NSObject

public class SSSwifty<Base> {

    public let base: Base

    public init(_ base: Base) {
        self.base = base
    }
}

public protocol SSSwiftyCompatible {

    associatedtype CompatibleType

    static var ss: SSSwifty<CompatibleType>.Type { get set }

    var ss: SSSwifty<CompatibleType> { get set }
}

extension SSSwiftyCompatible {

    public static var ss: SSSwifty<Self>.Type {
        get {
            return SSSwifty<Self>.self
        }
        set {

        }
    }

    public var ss: SSSwifty<Self> {
        get {
            return SSSwifty(self)
        }
        set {

        }
    }
}

extension NSObject: SSSwiftyCompatible { }
