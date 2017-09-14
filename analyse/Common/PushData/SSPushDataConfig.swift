//
//  SSPushDataConfig.swift
//  Common
//
//  Created by JunrenHuang on 7/2/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

public enum SSDataType: String {

    case All = "ALL"
    /// 市场板块
    case Market = "1"
    /// 涨幅榜
    case RiseRank = "2"
    /// 跌幅榜
    case FallRank = "3"
    /// 换手率
    case TurnoverRate = "4"
    /// 标的物
    case Portfolio = "5"
    /// 个股详情
    case TickerInfo = "6"
    /// 个股分笔成交明细
    case TickerDetail = "7"

    /// 指数
    case Index = "8"
    /// 商品
    case Commodity = "9"
    /// 外汇
    case Currency = "10"
    /// 成交量
    case TurnOver = "11"

    /// 个股状态(拆分)
    case TickerStatus = "12"
    /// 个股盘口(拆分)
    case TickerHandicap = "13"
    /// 个股档口(拆分)
    case TickerStall = "14"
    /// 个股成交明细(拆分)
    case TickerDetails = "15"
    /// ETF基金
    case ETF = "16"

}

public struct SSDataNotifiction {
    /// 重连上mqtt之后 需要重新订阅
    public static let Data = "SSDataNotifiction.Data"
    public static let Connnected = "SSDataNotifiction.Connnected"
    public static let DataPublish = "SSDataNotifiction.DataPublish"
}

public class SSDataObject: NSObject {
    public var type: SSDataType = .Market
    public var data: [[String: Any]] = [[String: Any]]()
}

public class SSPushDataUtil {

    public class func animation() -> CAAnimation {
//        let animation: CATransition = CATransition()
//        animation.duration = 0.6
//        animation.autoreverses = true
//
//        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        let animation: CATransition = CATransition()

        //animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 0
        opacity.toValue = 1.2

        let group = CAAnimationGroup()
        group.animations = [animation, opacity]
        group.duration = 0.8
        group.autoreverses = true

        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)

        return group
    }

    public class func getAttributedString(
        newPrice: String?,
        oldPrice: String?,
        attr: [String: Any],
        decimal: Int? = nil
        ) -> NSAttributedString?
    {
        if
            let oldPrice = oldPrice,
            let newPrice = newPrice,
            newPrice != oldPrice,
            oldPrice != String.nilValue,
            oldPrice != ""
//            let oldValue = Double(oldPrice),
//            let newValue = Double(newPrice)
        {
            var attr = attr
            let color = newPrice > oldPrice ? SSColor.riseText.color : SSColor.fallText.color

            // 比如 "12345.01"变成"12,345.01"
            var newPrice = newPrice
            var oldPrice = oldPrice
            if let oldValue = Double(oldPrice),
                let newValue = Double(newPrice),
                let decimal = decimal {
                newPrice = newValue.decimalFormat(decimal)
                oldPrice = oldValue.decimalFormat(decimal)
            }

            let newCount = newPrice.characters.count
            let oldCount = oldPrice.characters.count

            if newCount != oldCount {
                attr[NSForegroundColorAttributeName] = color
                return NSAttributedString(string: newPrice, attributes: attr)
            }

            for i in 0..<newCount {
                let oldChar = oldPrice[i]
                let newChar = newPrice[i]

                if oldChar != newChar {

                    let string = NSMutableAttributedString()

                    let index = newPrice.index(newPrice.startIndex, offsetBy: i)

                    string.append(NSAttributedString(string: newPrice.substring(to: index), attributes: attr))

                    attr[NSForegroundColorAttributeName] = color

                    string.append(NSAttributedString(string: newPrice.substring(from: index), attributes: attr))
                    
                    return string
                }
            }
        }
        return nil
    }
}
