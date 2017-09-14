//
//  USRequestEncoding.swift
//  NewUstock
//
//  Created by zjl on 16/11/10.
//  Copyright © 2016年 ustock. All rights reserved.
//

import Moya
import Alamofire

public struct JsonArrayEncoding: Moya.ParameterEncoding {

    public static var `default`: JsonArrayEncoding { return JsonArrayEncoding() }

    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {

        var request = try urlRequest.asURLRequest()
        let json = try JSONSerialization.data(withJSONObject: parameters!["array"]!, options: JSONSerialization.WritingOptions.prettyPrinted)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = json

        return request
    }
}
