//
//  TickTock.swift
//  stocks-ios
//
//  Created by Eason Lee on 10/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import CoreFoundation
import QuartzCore

public func tick(_ fname: String = #function) -> CFTimeInterval {
    #if DEBUG
        return CACurrentMediaTime()
    #else
        return 0
    #endif
}

public func tock(_ tick: CFTimeInterval, _ fileName: String = #file, _ fname: String = #function) {
    #if DEBUG
        let time = CACurrentMediaTime() - tick
        SSLog("\(fileName.components(separatedBy: "/").last!) \(fname) time: \(time)")
    #endif
}
