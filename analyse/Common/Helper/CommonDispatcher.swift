//
//  CommonDispatcher.swift
//  Common
//
//  Created by Tank on 2017/7/4.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import UIKit
import SwiftyJSON

public let CommonDispatcher = MyDispatcher()

public typealias USRegionSelectHandler = ((Void) -> (Void))

public enum USShareResult {
    
    case success
    case failure(error: NSError?)
    
}

public typealias USShareHandler = ((USShareResult) -> Void)

public protocol CommonDispatcherProtocol {
    /// 当前的顶级VC
    var topVC: UIViewController? {get}
    
}

public class MyDispatcher: CommonDispatcherProtocol {
    public var dispatcher: CommonDispatcherProtocol?
    
    /// 当前的顶级VC
    public var topVC: UIViewController? {
        return self.dispatcher?.topVC
    }
    
    fileprivate init() {
        
    }

}
