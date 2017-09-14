
//
//  SSFinanceNewsModel.swift
//  Common
//
//  Created by Hugo on 2017/5/17.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import UIKit
import Networking
import YYText

public struct SSFinanceNewsModel: JSONMappable {
    
    public var code: String = ""
    public var newsModels: [SSFinanceNewsLayoutModel] = []
    
    public init?(_ json: JSON) {
        guard
            let code = json["code"] as? String,
            code == "succ",
            let allNews = json["news"] as? [JSON]
            else {
                return nil
        }
        self.code = code
        for news in allNews {
            if let element = SSFinanceNewsLayoutModel(news) {
                newsModels.append(element)
            }
        }
    }
    
    public func toJSON() -> JSON {
        var json = [String: Any]()
        json["code"] = self.code
        let news = self.newsModels.map{ $0.toJSON()}
        json["news"] = news
        return json
    }
    

}

public class SSFinanceNewsLayoutModel: JSONMappable {
    
    public let KReadNews = DefaultsKey<[Any]>("KReadNews")
    
    public var isRead = false
    public var newsId: Int64 = 0
    
    public var mainPic: String?
    public var newsTime: String = ""
    public var newsUrl: String = ""
    public var siteType: Int = 0
    public var sourceIcon: String = ""
    public var sourceName: String = ""
    public var summary: String = ""
    public var title: String = ""
    public var titleAttrStr: NSMutableAttributedString  = NSMutableAttributedString(string: "")
    public var headerTitleAttrStr: NSMutableAttributedString = NSMutableAttributedString(string: "")
    
    public var headerTitleSize: CGSize = CGSize(width: UIUtils.screenWidth - UIUtils.UIMargin * 2, height: 90)
    public var headerTitleFont: UIFont = SSFont.t04.bold
    
    public var titleFont: UIFont = SSFont.t05.bold
    public var titleFrame: CGRect = CGRect.zero
    
    public var imageframe: CGRect = CGRect.zero
    
    public var sourceFont: UIFont = SSFont.t08.font
    public var sourceFrame: CGRect = CGRect.zero
    
    public var height: CGFloat = 0.0
    
    public let imageW: CGFloat = 140
    public var imageH: CGFloat = 90
    
    public required init?(_ json: JSON) {
        guard
            let id = json["id"] as? Int64,
            let newsTitle = json["title"] as? String,
            let url = json["newsUrl"] as? String
            else {
                return nil
        }
        self.title = newsTitle
        self.newsId = id
        
        if let ids = Defaults[KReadNews] as? [Int64] {
            self.isRead = ids.contains(newsId)
        } else {
            self.isRead = false
        }
        
        self.newsUrl = url
        self.mainPic = json["mainPic"] as? String
        self.newsTime = json["newsTime"] as? String ?? ""
        self.siteType = json["siteType"] as? Int ?? 0
        self.sourceIcon = json["sourceIcon"] as? String ?? ""
        self.sourceName = json["sourceName"] as? String ?? ""
        self.summary = json["summary"] as? String ?? ""
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = StocksConfig.language.isChinese ? 3 : 0
        let titleAttribute = [NSFontAttributeName: self.titleFont, NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: SSColor.c301.color] as [String : Any]
        let headerTitleAttribute = [NSFontAttributeName: self.headerTitleFont, NSForegroundColorAttributeName: SSColor.c303.color, NSParagraphStyleAttributeName: paragraphStyle]
        self.titleAttrStr = NSMutableAttributedString(string: self.title, attributes: titleAttribute)
        self.headerTitleAttrStr = NSMutableAttributedString(string: self.title, attributes: headerTitleAttribute)
        
        let margin = CGFloat(8)
        let yOffset = CGFloat(18)
        var rightOffSet: CGFloat = 8
        
        if let picUrl = self.mainPic, !picUrl.isEmptyOrNil() {
            rightOffSet += imageW + 8
            imageframe = CGRect(x: UIUtils.ScreenSize.SCREEN_WIDTH - margin - imageW, y: yOffset, width: imageW, height: imageH)
        } else {
            imageH -= 20
            imageframe = CGRect(x: UIUtils.ScreenSize.SCREEN_WIDTH - margin, y: yOffset, width: 0, height: imageH)
        }
        
        let titleX: CGFloat = margin
        let titleY: CGFloat = yOffset
        let titleW: CGFloat = imageframe.origin.x - margin * 2

        if let layout = YYTextLayout(containerSize: CGSize(width: titleW, height: 90), text: self.titleAttrStr) {
            self.titleFrame = CGRect(x: titleX, y: titleY, width: layout.textBoundingSize.width, height: layout.textBoundingSize.height)
        } else {
            self.titleFrame = CGRect(x: titleX, y: titleY, width: titleW, height: 90)
        }
        
        if let headerLayout = YYTextLayout(containerSize: CGSize(width: UIUtils.screenWidth - 2 * UIUtils.UIMargin, height: 90), text: self.headerTitleAttrStr) {
            self.headerTitleSize = headerLayout.textBoundingSize
        }
        
        let sourceX = titleX
        let sourceW = titleW
        let sourceH: CGFloat = 16

        if let picUrl = self.mainPic, !picUrl.isEmptyOrNil() {
            
            let sourceY = self.imageframe.maxY - sourceH
            self.sourceFrame = CGRect(x: sourceX, y: sourceY, width: sourceW, height: sourceH)
            
            self.height =  imageH + 2 * yOffset
        } else {
            
            let sourceY = self.titleFrame.origin.y + self.titleFrame.size.height + 10
            self.sourceFrame = CGRect(x: sourceX, y: sourceY, width: sourceW, height: sourceH)
            
            self.height = self.sourceFrame.origin.y + self.sourceFrame.size.height + yOffset
        }
    }
    
    public func setReadStatus() {
        guard !self.isRead && self.newsId != 0 else {
            return
        }
        self.isRead = true
        
        var ids: Array = Defaults[KReadNews] as! [Int64]
        ids.append(self.newsId)
        Defaults[KReadNews] = ids as [Any]
    }
    
    public func toJSON() -> JSON {
        var json = [String: Any]()
        json["id"] = self.newsId
        json["title"] = self.title
        json["newsUrl"] = self.newsUrl
        json["mainPic"] = self.mainPic ?? ""
        json["newsTime"] = self.newsTime
        json["siteType"] = self.siteType
        json["sourceIcon"] = self.sourceIcon
        json["sourceName"] = self.sourceName
        json["summary"] = self.summary
        return json
    }
}
