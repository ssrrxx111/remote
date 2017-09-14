//
//  SSBoardBulletin.swift
//  Common
//
//  Created by JunrenHuang on 10/2/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

public struct SSBoardBulletins: JSONMappable {

    public var bulletins = [SSBoardBulletin]()

    public init?(_ json: JSON) {
        guard
            let bulletins = json["bulletins"] as? [JSON]
            else {
                return nil
        }

        for bulletin in bulletins {
            if let value = SSBoardBulletin(bulletin) {
                self.bulletins.append(value)
            }
        }
    }
}

public struct SSBoardBulletin: JSONMappable, SSBoardURLBase {

    public var id: Int64
    public let bullTitle: String
    public var url: String

    //public let sourceName: String
    public let time: String

    public var siteType: Int = 0

    public var subtitle: String {
        return self.time
    }

    public var title: String {
        return self.bullTitle
    }

    public init?(_ json: JSON) {
        guard
            let id = json["id"] as? Int64,
            let bullTitle = json["bullTitle"] as? String,
            let url = json["url"] as? String
            else {
                return nil
        }
        self.id = id
        self.bullTitle = bullTitle
        self.url = url

        //self.sourceName = SSFormatter.formatString(json["sourceName"], ret: "")
        self.time = (json["publishDate"] as? String)?.timeAgo() ?? "" //SSFormatter.formatTimeYMDNews(json["publishDate"])
    }
}
