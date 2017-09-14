//
//  SSLogger.swift
//  Common
//
//  Created by LJC on 2017/07/18.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

public let LOGGER = SSLogger()

public func SSLog(_ log: Any) {
    LOGGER.log(log)
}

public protocol SSLoggable {
    
    func log(_ log: Any)
}

public class SSLogger {
    
    public var logger: SSLoggable? = nil
    
    fileprivate init() {
        
    }
    
    func log(_ log: Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        
        if let logger = self.logger {
            logger.log(log)
        }
    }
}
