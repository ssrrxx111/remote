//
//  SSFont.swift
//  stocks-ios
//
//  Created by Eason Lee on 03/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit

public enum SSFont {

    case t00
    case t01 //重要的展示数字
    case t02 //新闻标题
    case t03 //
    case t04 //常规列表数字
    case t05 //代码&名称
    case t06 //辅助信息
    case t07 //辅助信息
    case t08 //提示
    case t09 //

    var fontSize: CGFloat {

        var size: CGFloat

        switch self {
        case .t00:
            size = 48
        case .t01:
            size = 36
        case .t02:
            size = 24
        case .t03:
            size = 20
        case .t04:
            size = 18
        case .t05:
            size = 16
        case .t06:
            size = 14
        case .t07:
            size = 12
        case .t08:
            size = 10
        case .t09:
            size = 8
        }

        return size
    }

    public var font: UIFont {
        return UIFont.systemFont(ofSize: fontSize)
    }

    public var bold: UIFont {
        return UIFont.boldSystemFont(ofSize: fontSize)
    }

    public var digit: UIFont {
        guard let font = UIFont(name: "DINAlternate-Bold", size: fontSize) else {
            return UIFont.systemFont(ofSize: fontSize)
        }
        return font
    }
    
    public var lcd: UIFont {
        guard let font = UIFont(name: "Quartz-Regular", size: fontSize) else {
            return UIFont.systemFont(ofSize: fontSize)
        }
        return font
    }

    public static var georgia: UIFont {

        let fontSize: CGFloat = 14
        if StocksConfig.language.isChinese {
            return UIFont.systemFont(ofSize: fontSize)
        }

        guard let font = UIFont(name: "Georgia", size: fontSize) else {
            return UIFont.systemFont(ofSize: fontSize)
        }
        return font
    }

}
