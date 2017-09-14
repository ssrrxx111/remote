//
//  SSPushDataViewController.swift
//  Common
//
//  Created by JunrenHuang on 7/2/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit

open class SSPushDataViewController: SSBaseTableViewController {

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        switch StocksConfig.refreshDuration {
        case .realtime:
            self.dataSubscribe()
            NotificationCenter.default.addObserver(self, selector: #selector(dataReconnected(_:)), name: Notification.Name(rawValue: SSDataNotifiction.Connnected), object: nil)
        case .manual:
            break
        default:
            NotificationCenter.default.addObserver(self, selector: #selector(didReceiveRefreshHeartBeat), name: refreshHeartbeatNotification, object: nil)
        }
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.dataUnsubscrible()

        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: SSDataNotifiction.Connnected), object: nil)

        NotificationCenter.default.removeObserver(self, name: refreshHeartbeatNotification, object: nil)
    }

    // MARK: 数据刷新心跳。如果需要根据心跳刷新数据，重载该方法。非主线程
    open func didReceiveRefreshHeartBeat() {
        //        log.info("收到数据刷新心跳")
        NSLog("heart beat")
    }

    // MARK: 推送
    open func resubscribe() {

        guard StocksConfig.refreshDuration == .realtime else {
            return
        }

        self.dataUnsubscrible()
        self.dataSubscribe()
    }

    open func dataSubscribe() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: SSDataNotifiction.DataPublish), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(dataReceived(_:)), name: Notification.Name(rawValue: SSDataNotifiction.DataPublish), object: nil)
    }

    open func dataUnsubscrible() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: SSDataNotifiction.DataPublish), object: nil)
    }

    open func dataProcess(_ type: SSDataType, data: [[String: Any]]) {

    }

    @objc fileprivate func dataReceived(_ n: Notification) {

        guard let object: SSDataObject = n.object as? SSDataObject else {
            return
        }

        self.dataProcess(object.type, data: object.data)
    }

    @objc fileprivate func dataReconnected(_ n: Notification) {
        self.dataSubscribe()
    }
}
