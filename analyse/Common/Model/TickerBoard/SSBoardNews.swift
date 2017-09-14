//
//  SSBoardNews.swift
//  stocks-ios
//
//  Created by JunrenHuang on 11/1/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import Networking

public struct SSBoardNewsModel: JSONMappable {

    public var boardNews = [SSBoardNews]()
    public init?(_ json: JSON) {
        guard
            let code = json["code"] as? String,
            code == "succ",
            let allNews = json["news"] as? [JSON]
        else {
            return nil
        }
        for news in allNews {
            if let element = SSBoardNews(news) {
                boardNews.append(element)
            }
        }
    }
}

public struct SSBoardNews: JSONMappable, SSBoardURLBase {

    public var id: Int64
    public let newsTitle: String
    public var url: String

    public let sourceName: String
    public let time: String

    public var siteType: Int

    public var mainPic: String?

    public var subtitle: String {
        return self.sourceName + " · " + self.time
    }

    public var title: String {
        return self.newsTitle
    }

    public init?(_ json: JSON) {
        guard
        let id = json["id"] as? Int64,
        let newsTitle = json["title"] as? String,
        let url = json["newsUrl"] as? String
            else {
                return nil
        }
        self.id = id
        self.newsTitle = newsTitle
        self.url = url

        if let type = json["siteType"] as? Int {
            self.siteType = type
        } else {
            self.siteType = 0
        }

        self.sourceName = SSFormatter.formatString(json["sourceName"], ret: "")
        self.time = SSFormatter.formatTimeYMDNews(json["newsTime"])

        if let pic = json["mainPic"] as? String {

            self.mainPic = pic

        }
    }
}
