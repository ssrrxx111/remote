//
//  SSTickerStatus.swift
//  stocks-ios
//
//  Created by JunrenHuang on 13/1/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

public enum SSTickerStatus: String {
    /// ‘S’表示启动(开市前)时段 (已废弃)
    case S = "S"
    /// ‘W’表示等待开盘时段
    case W = "W"
    /// ‘C’表示集合竞价时段
    case C = "C"
    /// ‘T’表示连续交易时段
    case T = "T"
    /// ‘F’表示盘前交易时段
    case F = "F"
    /// ‘A’表示盘后交易时段
    case A = "A"
    /// ‘M’表示午间休市时段
    case M = "M"
    /// ‘B’表示休市时段
    case B = "B"
    /// ‘E’表示闭市时段 (已废弃)
    case E = "E"
    /// ‘P’表示产品停牌
    case P = "P"
    /// ‘D’表示已收盘
    case D = "D"
    /// ‘H’表示未开市
    case H = "H"

    case none

    public var i18nNormal: String {

        switch self {
        case .S:
            return i18n("ticker.status.S")
        case .W:
            return i18n("ticker.status.W")
        case .C:
            return i18n("ticker.status.C")
        case .T:
            return i18n("ticker.status.T")
        case .F:
            return i18n("ticker.status.F")
        case .A:
            return i18n("ticker.status.A")
        case .M:
            return i18n("ticker.status.M")
        case .B:
            return i18n("ticker.status.B")
        case .E:
            return i18n("ticker.status.E")
        case .P:
            return i18n("ticker.status.P")
        case .D:
            return i18n("ticker.status.D")
        case .H:
            return i18n("ticker.status.H")

        default:
            return ""
        }
    }

    public var faStatus: String? {
        switch self {
        case .F:
            return i18n("ticker.faStatus.F")
        case .A, .B, .D, .H:
            return i18n("ticker.faStatus.A")
        default:
            return nil
        }
    }
    
    // 用于组合列表的盘前盘后数据展示
    public var portfolioStatus: String? {
        switch self {
        case .F:
            return i18n("ticker.portfolio.faStatus.F")
        case .A, .B, .D, .H:
            return i18n("ticker.portfolio.faStatus.A")
        default:
            return nil
        }
    }

    public var needShowPrice: Bool {
        switch self {
        case .F, .A, .B, .D, .H:
            return true
        default:
            return false
        }
    }
}
