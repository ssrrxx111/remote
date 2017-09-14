//
//  SSImage.swift
//  Common
//
//  Created by Eason Lee on 17/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit

public struct SSImage {

    public static func name(_ name: String) -> UIImage? {
        return UIImage(named: name)
    }

    public static func color(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {

        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }

        return UIImage(cgImage: cgImage)
    }
}
