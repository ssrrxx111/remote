//
//  USRequestError.swift
//  FMNetwork
//
//  Created by adad184 on 09/03/2017.
//  Copyright © 2017 fumi. All rights reserved.
//

import Common
import Foundation
import SwiftyJSON
import ObjectMapper

// MARK: 错误种类
public enum USError: Error {
    case unknown
    case networkError(Int, String)
    case responseValidate(String, String, JSON?)
    
    public var normalInfo: String {
        switch self {
        case .networkError(_, let info):
            return "\(info)"
        case .responseValidate(let code, _, _):
            return code
        default:
            return "未知错误"
        }
    }
    
    public var serverErrorMsg: String {
        switch self {
        case .networkError(_, let info):
            return "\(info)"
        case .responseValidate(_, let msg, _):
            return msg
        default:
            return "未知错误"
        }
    }
    
    public var serverErrorCode: String {
        switch self {
        case .responseValidate(let code, _, _):
            return code
        default:
            return "未知错误"
        }
    }
    
    public var serverErrorToDisplay: String {
        switch self {
        case .networkError(_, let info):
            return info
        case .responseValidate(let code, let msg, _):
            var result = msg
            return result
        default:
            return "未知错误"
        }
    }
    
    public var errorData: JSON? {
        switch self {
        case .responseValidate(_, _, let json):
            return json
        default:
            return nil
        }
    }
    
    /// 处理错误tracker
    ///
    /// - Parameters:
    ///   - tp: 埋点key
    ///   - error: 错误数据
    public static func track(_ tp: String, error: Error) {
//        if let error = error as? USError {
//            SharedTracker.track(event: tp, properties: ["code": error.serverErrorCode, "msg" : error.serverErrorToDisplay])
//        } else {
//            SharedTracker.track(event: I18n("common.error.network"))
//        }
    }
}

open class ErrorMsg: BaseObjectModel {

    var code: String = ""
    var msg: String = ""

    required public init?(map: Map) {
        super.init(map: map)

    }

    override open func mapping(map: Map) {
        super.mapping(map: map)
        code <- map["code"]
        msg <- map["msg"]
    }

}

open class SuccessMsg: BaseObjectModel {

}

extension ErrorMsg: Error {
    
}
