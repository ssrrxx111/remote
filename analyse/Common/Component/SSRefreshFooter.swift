//
//  SSRefreshFooter.swift
//  Stocks-ios
//
//  Created by adad184 on 13/06/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit
import MJRefresh

public class SSRefreshFooter: MJRefreshAutoNormalFooter {

    public class func customFooter(refreshingBlock: @escaping MJRefreshComponentRefreshingBlock) -> MJRefreshAutoNormalFooter? {
        guard let footer = MJRefreshAutoNormalFooter(refreshingBlock: refreshingBlock) else {
            return nil
        }

        footer.ss.languageHandler { (view) in
            view.setTitle(i18n("MJRefreshAutoFooterIdleText"), for: MJRefreshState.idle)
            view.setTitle(i18n("MJRefreshAutoFooterRefreshingText"), for: MJRefreshState.refreshing)
            view.setTitle(i18n("MJRefreshAutoFooterIdleText"), for: MJRefreshState.willRefresh)
            view.setTitle(i18n("MJRefreshAutoFooterNoMoreDataText"), for: MJRefreshState.noMoreData)
        }

        footer.stateLabel.font = SSFont.t07.bold
        footer.stateLabel.textColor = SSColor.c302.color
        footer.isAutomaticallyHidden = true
        
        footer.ss.themeHandler { (footer) in
            if StocksConfig.appearance.theme == .black {
                footer.activityIndicatorViewStyle = .white
            } else {
                footer.activityIndicatorViewStyle = .gray
            }
        }

        return footer
    }
}

