//
//  UIColorExtensions.swift
//  Common
//
//  Created by Eason Lee on 17/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    // Mark: convenience init method
    public convenience init(hred: Int, hgreen: Int, hblue: Int, alpha: CGFloat = 1.0) {
        assert(hred >= 0 && hred <= 255, "Invalid red component")
        assert(hgreen >= 0 && hgreen <= 255, "Invalid green component")
        assert(hblue >= 0 && hblue <= 255, "Invalid blue component")
        assert(alpha >= 0.0 && alpha <= 1.0, "Invalid alpha component")

        self.init(red: CGFloat(hred) / 255.0,
                  green: CGFloat(hgreen) / 255.0,
                  blue: CGFloat(hblue) / 255.0,
                  alpha: CGFloat(alpha))
    }

    public convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(hred: (hex >> 16) & 0xff,
                  hgreen: (hex >> 8) & 0xff,
                  hblue: hex & 0xff,
                  alpha: alpha)
    }

    public convenience init(_ rgba: UInt32) {
        self.init(
            hred: Int(rgba >> 24) & 0xff,
            hgreen: Int(rgba >> 16) & 0xff,
            hblue: Int(rgba >> 8) & 0xff,
            alpha: CGFloat(rgba & 0xff) / 255.0
        )
    }
}
