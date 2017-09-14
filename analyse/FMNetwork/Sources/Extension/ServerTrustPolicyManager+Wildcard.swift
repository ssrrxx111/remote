//
//  ServerTrustPolicyManager+Wildcard.swift
//  NewUstock
//
//  Created by adad184 on 17/11/2016.
//  Copyright © 2016 ustock. All rights reserved.
//

import Alamofire

public class WildcardServerTrustPolicyManager: ServerTrustPolicyManager {

    override open func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {

//        for (key, value) in policies {
//            NSLog("--- \(key) \(value)")
//        }

        if let policy = policies.values.first {
            return policy
        }

        return nil
    }
}
