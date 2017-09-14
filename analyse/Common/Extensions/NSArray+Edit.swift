//
//  NSArry+Extension.swift
//  YoungoSchool
//
//  Created by 杨志赟 on 15/9/15.
//  Copyright © 2015年 e-youngo.com. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    // Remove Item
    mutating public func removeObject<U: Equatable>(_ object: U) -> Bool {
        for (idx, objectToCompare) in self.enumerated() {
            if let to = objectToCompare as? U {
                if object == to {
                    self.remove(at: idx)
                    return true
                }
            }
        }
        return false
    }

    mutating public func exchange(_ first: Int, second: Int) -> Bool {

        if first >= self.count || second >= self.count {
            return false
        }
        swap(&self[first], &self[second])
        return true
    }
}
