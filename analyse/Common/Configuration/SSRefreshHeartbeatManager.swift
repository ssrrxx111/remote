//
//  File.swift
//  Common
//
//  Created by JunrenHuang on 24/2/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

public let refreshHeartbeatNotification = Notification.Name(rawValue: "SSRefreshHeartbeatManager.refreshHeartbeatNotification")

public class SSRefreshHeartbeatManager: NSObject {
    static public var sharedInstance = SSRefreshHeartbeatManager()
    var timer: DispatchSourceTimer?

    fileprivate override init() {
        super.init()
    }

    public func setup() {
        self.ss.refreshHandler({ (manager) in
            manager.startHeartBeat()
        })
    }

    func startHeartBeat() {

        timer?.cancel()
        timer = nil

        if StocksConfig.refreshDuration == .realtime || StocksConfig.refreshDuration == .manual {
            return
        }

        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())

        guard let duration = StocksConfig.refreshDuration.duration else {
            return
        }
        let interval = Int(duration)

        timer?.scheduleRepeating(deadline: .now() + Double(interval), interval: .seconds(interval), leeway: .seconds(interval))

        timer?.setEventHandler {
            NotificationCenter.default.post(name:refreshHeartbeatNotification, object: nil)
        }

        timer?.resume()
    }
}
