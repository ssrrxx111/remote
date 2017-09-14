//
//  SSConstant.swift
//  Common
//
//  Created by JunrenHuang on 4/3/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

let kExchangeRatePathFile: String = "/exchanges/foreignExchangesRates.json"

public let FixedSegmentControlSelectionIndicatorEdgeInsets: UIEdgeInsets = UIEdgeInsetsMake(31, 0, 0, 0)
public let DynamicSegmentControlSelectionIndicatorEdgeInsets: UIEdgeInsets = UIEdgeInsetsMake(31, 6, 0, 6 * 2)

/// 在线客服
public let urlTradeCustomerService = "/mgt/redirect/tradeim"
/// 客服电话
public let kCustomerServerNumber = "400-058-0188"

/// 帮助页
public let urlHelp = "/mgt/redirect/apphelp"
/// 佣金方案
public let urlTradeCommission = "/mgt/redirect/trademi"
/// cfd帮助
public let urlTradeCfdHelp = "/mgt/redirect/cfdHelp"

// MARK: 用户登录注册用户名以及类型
public let KSignInUsername = "KSignInUsername"
public let KSignInAccountType = "KSignInAccountType"

public let kCustomerPhone: String = "400-058-0188"
public let kCustomerEmail: String = "customerservice@webull.com"

public let kTradeAccountRefresh = Notification.Name(rawValue: "ustock.trade.account.refresh")               // 无网络点击按钮刷新

public let kNotificationAssetsOperate = Notification.Name(rawValue: "notification.trade.assets.operate")    // 交易首页资产隐藏切换按钮

public let kTradeSaxoLoginSuccuss = Notification.Name(rawValue: "kTradeSaxoLoginSuccuss")

public let kTradeAccountAliAppCode = "kTradeAccountAliAppCode"

// MARK: Saxo
public let kSaxoSAMLRequstInfo = "kSaxoSAMLRequstInfo"
public let KSaxoBaseUrlInfo = "KSaxoBaseUrlInfo"
public let kSaxoRequestUrlInfo = "kSaxoRequestUrlInfo"

public let kNotificationTradeTabDisplay = "kNotificationTradeTabDisplay"
public let kDidFirstDisplayTradeTab = "kDidFirstDisplayTradeTab"

public let UserIsNotFirstInstalled = "UserHasGuideView"
public let NotificationToggle = "NotificationToggle"











