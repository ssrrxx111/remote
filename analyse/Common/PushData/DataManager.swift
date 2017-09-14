//
//  SSTickerViewController.swift
//  stocks-ios
//
//  Created by JunrenHuang on 10/1/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import ReachabilitySwift
import CocoaMQTT
import Networking

private struct SSDataConnnectionConfig {

    static var host: String {
        return SSAPI.push.host
    }
    //static let host = "push.webull.com"
    static let port: UInt16 = 9018

    static let username = RequestHeader.deviceUUID
    static let password = "MmVA5yKL\(RequestHeader.deviceUUID)".md5()
    static let keepalive = 10
    
}

public class SSDataManager: NSObject {

    public static let DATA = SSDataManager()

    private static let queue = DispatchQueue(label: "com.stocks666.pushdata", attributes: [])

    //监听网络状态改变
    let reachability = ReachabilitySwift.Reachability()
    var justEnteredFore: Bool = true

    fileprivate var MQTT = CocoaMQTT(clientID: RequestHeader.deviceUUID, host: SSDataConnnectionConfig.host, port: SSDataConnnectionConfig.port)

    let queue = DispatchQueue(label: "SSDataManager", attributes: [])

    fileprivate override init() {
        super.init()
    }

    public func setup() {

        self.queue.async {
            typealias Config = SSDataConnnectionConfig

            //self.MQTT = CocoaMQTT(clientID: self.UDID, host: Config.host, port: Config.port)
            self.MQTT.delegate = self
            self.MQTT.username = Config.username
            self.MQTT.password = Config.password
            self.MQTT.backgroundOnSocket = true

            _ = self.MQTT.connect()

            NotificationCenter.default.addObserver(self, selector: #selector(self.enterBackground(_:)), name: .UIApplicationDidEnterBackground, object: nil)

            NotificationCenter.default.addObserver(self, selector: #selector(self.enterForeground(_:)), name: .UIApplicationWillEnterForeground, object: nil)

            //如果需要推送，注册通知监听网络状态改变
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.reachabilityChanged(_:)),
                name: NSNotification.Name.reachabilityChanged,
                object: nil
            )

            do {
                try self.reachability?.startNotifier()
            } catch {
                SSLog("could not start reachability notifier")
            }
        }

    }

    func enterBackground(_ notice: Notification) {
        if self.MQTT.connState == .connecting || self.MQTT.connState == .connected {
            self.MQTT.disconnect()
        }
    }
    func enterForeground(_ notice: Notification) {
        if self.MQTT.connState == .disconnected {
            _ = self.MQTT.connect()
        }
    }

    func reachabilityChanged(_ notice: Notification) {
        guard let reachabdility = notice.object as? Reachability else {
            return
        }

        if reachabdility.isReachable {
            if reachabdility.isReachableViaWiFi {
                self.netStateChangedToChangeConnectingState(state: 0)
            } else {
                self.netStateChangedToChangeConnectingState(state: 0)
            }
        } else {

            self.netStateChangedToChangeConnectingState(state: 1)
        }
    }
    //根据网络改变去改变连接状态
    func netStateChangedToChangeConnectingState(state: Int) {
        if self.justEnteredFore == true {
            self.justEnteredFore = false
            return
        }

        if state == 0 {
            //变成蜂窝网络或者wifi

            if self.MQTT.connState == .connecting {

                self.MQTT.connState = .disconnected

                self.MQTT.disconnect()
            } else if self.MQTT.connState == .disconnected {
                _ = self.MQTT.connect()
            }

        } else {
            //断网
            if self.MQTT.connState == .connecting || self.MQTT.connState == .connected {
                self.MQTT.disconnect()
            }
        }
    }

    public func subscribe(_ type: SSDataType, ids: [Int64]) {

        guard self.MQTT.connState == .connected else {
            return
        }

        var json: JSON!

        switch type {
        case .Market,
             .RiseRank,
             .FallRank,
             .TurnoverRate,
             .ETF,
             .TurnOver:
            json = [
                "type": type.rawValue,
                "regionIds": ids,
                "header": RequestHeader.shared.headers
            ]
        default:
            json = [
                "type": type.rawValue,
                "tickerIds": ids,
                "header": RequestHeader.shared.headers
            ]
        }

        guard let jsonTemp = json else {
            return
        }

        guard let string = jsonTemp.rawString() else {
            return
        }
        let topic = self.minify(string)

        if topic.utf8.count > 60000 {
            self.trackMQTTFrameError(topic)
        }
        
        _ = self.MQTT.subscribe(topic, qos: .qos2)
    }

    public func unsubscribe(_ type: SSDataType) {

        self.unsubscribe([type])
    }

    public func unsubscribe(_ types: [SSDataType]) {

        guard self.MQTT.connState == .connected else {
            return
        }

        let values = types.map {
            return ($0 as SSDataType).rawValue
        }

        guard
            let string = values.rawString() else {
            return
        }

        let topic = self.minify(string)

        if topic.utf8.count > 60000 {
            self.trackMQTTFrameError(topic)
        }
        
        _ = self.MQTT.unsubscribe(topic)
    }

    func minify(_ json: String) -> String {
        let string = json.components(separatedBy: CharacterSet.whitespacesAndNewlines).joined(separator: "")

        return string
    }

    func tryAutoConnect() {

        self.queue.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) { [unowned self] in

            if self.MQTT.connState == .disconnected {
                _ = self.MQTT.connect()
            }
        }
    }
}

extension SSDataManager: CocoaMQTTDelegate {

    public func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .accept {
            NotificationCenter.default.post(name: Notification.Name(rawValue: SSDataNotifiction.Connnected), object: nil)
            //SSLog("推送连接成功")
        }
    }

    public func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {

        self.queue.async {

            guard let message = message.string else {
                return
            }

            guard
                let json = message.json(),
                let type = json["type"] as? String,
                let data = json["data"] as? [[String: Any]]
            else {
                return
            }

            let object = SSDataObject()
            object.type = SSDataType(rawValue: type)!
            object.data = data

            NotificationCenter.default.post(name: Notification.Name(rawValue: SSDataNotifiction.DataPublish), object: object)
        }

    }

    public func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        self.tryAutoConnect()
    }

    public func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {

    }

    public func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        
    }

    public func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {

    }

    public func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {

    }

    public func mqttDidPing(_ mqtt: CocoaMQTT) {

    }

    public func mqttDidReceivePong(_ mqtt: CocoaMQTT) {

    }

    public func mqtt(_ mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        //SSLog("host: \(host)")
    }

    func _console(_ info: String) {

    }
}


//mqttErrorTracker
enum SSErrorMQTT: String, SSTrackErrorPoint {
    case mqtt_bytesWithLength_overflow
}

extension SSDataManager {
    func trackMQTTFrameError(_ string: String) {
        TRACKER.error(SSErrorMQTT.mqtt_bytesWithLength_overflow, property: [
            "string": string
            ])
    }
}
