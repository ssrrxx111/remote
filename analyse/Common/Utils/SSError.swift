//
//  SSError.swift
//  stocks-ios
//
//  Created by Eason Lee on 11/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

public protocol ErrorType: Error {

    var code: String { get }
    var message: String { get }
}

public struct BaseError: ErrorType {

    public var code: String
    public var message: String
}

public enum SSError: ErrorType {

    case storage(code: Int, message: String)
    case unknow

    public var code: String {
        switch self {
        case .storage(let code, _):
            return "\(code)"
        default:
            return "-86000"
        }
    }

    public var message: String {
        switch self {
        case .storage(_, let message):
            return message
        default:
            return "null"
        }
    }
}
