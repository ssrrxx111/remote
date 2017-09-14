//
//  SSDevice.swift
//  Common
//
//  Created by JunrenHuang on 22/1/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation

public class SSDevice {

    public static var orientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }

    public static func isLandscape() -> Bool {
        return orientation.isLandscape
    }

    public static func rotate() {
        let value: UIInterfaceOrientation = isLandscape() ? .portrait : .landscapeRight
        UIDevice.current.setValue(value.rawValue, forKey: "orientation")
    }
}
