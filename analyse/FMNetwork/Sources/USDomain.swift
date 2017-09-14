//
//  USDomain.swift
//  FMNetwork
//
//  Created by adad184 on 23/03/2017.
//  Copyright © 2017 fumi. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct USDomain {

    public var domain: String = ""
    public var service: String = ""
    public var type: String = ""
    public var expire: Date = Date()
    public var ips: [String] = []

    public static func parse(_ json:JSON) -> USDomain {

        var domain = USDomain()
        domain.domain = json["domain"].stringValue
        domain.service = json["service"].stringValue
        domain.type = json["type"].stringValue
        domain.expire = json["expire"].stringValue.gmtDate() ?? Date()
        domain.ips = json["ips"].arrayValue.map({ (json) -> String in
            return json.stringValue
        })

        return domain
    }

    public static func encode(_ domain: USDomain) -> [String: Any] {
        return [
            "domain": domain.domain,
            "service": domain.service,
            "type": domain.type,
            "expire": domain.expire,
            "ips": domain.ips
        ]
    }

    public static func decode(_ data: [String: Any]) -> USDomain {

        var domain = USDomain()
        domain.domain = data["domain"] as? String ?? ""
        domain.service = data["service"] as? String ?? ""
        domain.type = data["type"] as? String ?? ""
        domain.expire = data["expire"] as? Date ?? Date()
        domain.ips = data["ips"] as? [String] ?? []

        return domain
    }
}
