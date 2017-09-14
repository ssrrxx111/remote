//
//  USHost.swift
//  FMNetwork
//
//  Created by adad184 on 22/03/2017.
//  Copyright © 2017 fumi. All rights reserved.
//

import Foundation
import Common

public enum USHostMode: Int, USEnumable {

    case production = 0
    case staging = 1
    case testing = 2
    case development = 3

    public static var allValues: [USHostMode] {
        return [
            .production,
            .staging,
            .testing,
            .development,
        ]
    }

    public var type: String {
        switch self {
        case .production:
            return "online"
        case .staging:
            return "pre"
        case .testing:
            return "test"
        case .development:
            return "dev"
        }
    }

    public var i18n: String {
        switch self {
        case .production:
            return "正式环境"
        case .staging:
            return "预演环境"
        case .testing:
            return "测试环境"
        case .development:
            return "开发环境"
        }
    }

    public var icon: UIImage? {
        return nil
    }

    public var value: AnyObject {
        return rawValue as AnyObject
    }

    public static var title: String {
        return "连接环境"
    }

    public static var defaultValue: USHostMode {
        return .production
    }

    public static var key: String {
        return "host"
    }

    public var needSSLPinning: Bool {
        switch self {
        case .production, .staging:
            return true
        case .testing, .development:
            return false
        }
    }
}


fileprivate struct USHostModeKey {
    static var currentMode = "USHostMode.currentMode"
}

public enum USHost: String {

    case zhuzhuxia
    case none
    
    public var baseURL: String {
        return "http://120.76.27.207:888/Default.aspx"
    }
}
