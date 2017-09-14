//
//  FMNetwork.swift
//  FMNetwork
//
//  Created by adad184 on 09/03/2017.
//  Copyright © 2017 fumi. All rights reserved.
//

import Foundation
import SwiftyJSON
import Common

public let ShareNetwork = FMNetwork()

public class FMNetwork {
    var interceptionNetworkErrorCode: ((JSON?, USError?, Bool) -> Void)?
    
    public func doInterceptionNectWorkErrorCode(_ json: JSON?, error: USError?, isTrade: Bool = true) {
        guard let block = self.interceptionNetworkErrorCode else {
            return
        }
        block(json, error, isTrade)
    }
    
    public func configInterceptionNetworkErrorCode(_ block: @escaping ((JSON?, USError?, Bool) -> Void)) {
        self.interceptionNetworkErrorCode = block
    }

    public func initialize() {

        SharedRequest.header = [String: String]()
    }
    
    
    /// 带参数初始化header
    ///
    /// - Parameter header: header
    public func initiallize(_ header: [String: String]) {
        self.initialize()
        SharedRequest.header = header
    }
    
    public func updateHeader(key: String, value: String?) {
        SharedRequest.header[key] = value
    }
    
    /// 获取header中key对应的value
    ///
    /// - Parameter key: key
    /// - Returns: value
    public func getHeader(key: String) -> String? {
        return SharedRequest.header[key]
    }
        
    /// 更新header中的accessToken
    ///
    /// - Parameter token: accessToken
    public func updateAccessToken(token: String?) {
        guard let token = token else {
            return
        }
        self.updateHeader(key: "access_token", value: token)
    }
    
    public func getAccessToken() -> String {
        return SharedRequest.header["access_token"] ?? ""
    }
    
    /// 更新header中的tradeToken
    ///
    /// - Parameter token: tradeToken
    public func updateTradeToken(token: String?, needNoty: Bool = true) {
        
    }
    
    public func getTradeToken() -> String? {
        return SharedRequest.header["t_token"]
    }
    
    public func updateLanguage(_ language: SSLanguage) {
        self.updateHeader(key: "hl", value: (language.value as! String))
    }
    
    
//    header["access_token"] = USAuthInfo.shared.accessToken
//    header["did"] = Utils.getDeviceUUID()
//    header["local"] = Utils.getCurrentLocale()
//    header["os"] = "iOS"
//    header["osv"] = Utils.getSystemVersion()
//    header["ph"] = Utils.getPhoneType()
//    header["tz"] = Utils.getTimeZone()
//    header["ver"] = Utils.getAppVersion()
//    header["app"] = VERSION.code
//    header["hl"] = "\(SharedBase.language.value as! String)"
//    header["t_time"] = "\(Date().timeIntervalSince1970)"

}
