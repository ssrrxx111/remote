//
//  GCD.swift
//  stocks-ios
//
//  Created by Eason Lee on 11/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

public struct GCD {

    private static var lock = NSLock()
    private static var tracker = Set<String>()

    public static func delay(_ delay: Double, closure: @escaping () -> Void) {

        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime(floatLiteral: delay),
            execute: closure
        )
    }

    public static func once(token: String, closure: @escaping () -> Void) {

        lock.lock()
        defer {
            lock.unlock()
        }

        guard !tracker.contains(token) else {
            return
        }

        tracker.insert(token)

        closure()
    }
}
