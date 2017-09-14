//
//  USApiService.swift
//  FMNetwork
//
//  Created by adad184 on 09/03/2017.
//  Copyright © 2017 fumi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON
import CoreTelephony

public let SharedApi = USApiService()

fileprivate enum USApiTarget: USTargetType {
    case router(registerAddress: String, mnc: String, ip: String, mcc: String)

    fileprivate var request: USRequest {
        switch self {
        case .router(let registerAddress, let mnc, let ip, let mcc):
            var parameters: [String: Any] = [
                "mnc": mnc,
                "ip": ip,
                "mcc": mcc
            ]
            if registerAddress != "-1" {
                parameters["registerAddress"] = registerAddress
            }
            return USRequest(
                host: .router,
                path: "/api/domain/route",
                method: .post,
                parameters: parameters
            )
        }
    }
}

public class USApiService: NSObject {

    fileprivate override init() {
        super.init()
    }

    public struct notification {
        public static let routerUpdated = Notification.Name(rawValue: "USApiService.routerUpdated")
    }


    private var cache = [String: String]()

    private let isFirstRouterKey = "isFirstRouter"      // 是否第一次登录

    public func get(host: USApiHost) -> String {

        if let value = self.cache[host.key] {
            return value
        }

        let defaults = UserDefaults.standard

        if let value = defaults.string(forKey: host.key) {
            return value
        } else {
            self.set(host: host, value: host.default)
            return host.default
        }
    }

    fileprivate func set(host: USApiHost, value: String) {
        self.cache[host.key] = value

        let defaults = UserDefaults.standard

        defaults.set(value, forKey: host.key)
        defaults.synchronize()
    }

    public func setup() {

        let defaults = UserDefaults.standard

        // 是否已同步过服务端的数据
        let settled = defaults.bool(forKey: self.isFirstRouterKey)

        if !settled {
            for host in USApiHost.allValues {
                self.set(host: host, value: host.default)
            }

            defaults.set(true, forKey: self.isFirstRouterKey)
            defaults.synchronize()
        } else {
            for host in USApiHost.allValues {
                self.cache[host.key] = self.get(host: host)
            }
        }

        self.asynHostRouter()
    }

    /**
     更新内存中的hostRouter
     */
    fileprivate func updateRouter(_ json: JSON) {

        for host in USApiHost.allValues {
            if let value = json[host.key].string {
                self.set(host: host, value: value)
            }
        }

        NotificationCenter.default.post(name: USApiService.notification.routerUpdated, object: nil)
    }

    func asynHostRouter() {

        //let targetRequest = USUserAPI.hostRouter(registerAddress: registerAddress, mnc: MNC, ip: IP, mcc: MCC)
        let target = USApiTarget.router(registerAddress: "", mnc: "", ip: "", mcc: "")

        SharedRequest
            .default
            .requestJSON(USRequestTarget(target))
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { (json) in

                guard let array = json["domains"].array else {
                    return
                }

                var map = [String: String]()

                for domain in array {
                    if let url = domain["domain"].string, let key = domain["key"].string {
                        map[key] = url
                    }
                }
                let json = JSON(map)
                
                self.updateRouter(json)
            }) {
                NSLog("dealloced")
        }
    }
}

public enum USApiHost: String {
    case user
    case passport
    case securities
    case search
    case info
    case portfolio
    case watchlist
    case push
    case magt
    case web
    case pic
    case news
    case html5
    case quote
    case trade
    case purchase
    case activity
    case suggestion
    case router //未做下发

    fileprivate static var allValues: [USApiHost] {
        return [
            .user,
            .passport,
            .securities,
            .search,
            .info,
            .portfolio,
            .watchlist,
            .push,
            .magt,
            .web,
            .pic,
            .news,
            .html5,
            .quote,
            .trade,
            .purchase,
            .activity,
            .suggestion,
        ]
    }

    fileprivate var api: String {
        switch self {
        case .user:
            return "userapi"
        case .passport:
            return "passportapi"
        case .securities:
            return "securitiesapi"
        case .search:
            return "searchapi"
        case .info:
            return "infoapi"
        case .portfolio:
            return "portfolioapi"
        case .watchlist:
            return "watchlistapi"
        case .push:
            return "cn-push"
        case .magt:
            return "magtapi"
        case .web:
            return "webapi"
        case .pic:
            return "pic"
        case .news:
            return "news"
        case .html5:
            return "h5"
        case .quote:
            return "quoteapi"
        case .trade:
            return "tradeapi"
        case .purchase:
            return "userapi"
        case .activity:
            return "activityapi"
        case .suggestion:
            return "suggestionapi"
        case .router:
            return "routeapi"
        }
    }

    public var `default`: String {
        switch self {
        case .push:
            return "https://cn-push.webull.com:9018"
        case .trade:
            return "https://\(self.api).webulltrade.com"
        default:
            return "https://\(self.api).webull.com"
        }
    }

    fileprivate var key: String {
        switch self {
        case .purchase:
            return "purchase"
        case .html5:
            return "h5"
        default:
            return self.api
        }
    }
}
