//
//  UIImage+Swifty.swift
//  FMBase
//
//  Created by adad184 on 10/03/2017.
//  Copyright © 2017 fumi. All rights reserved.
//

import Foundation

extension SSSwifty where Base: UIImage {

    public static func image(
        _ color: UIColor,
        size: CGSize = CGSize(width: 10, height: 10),
        cornerRadius: CGFloat = 0.0
        ) -> UIImage {

        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))

        color.setFill()
        path.fill()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    public static func circle(
        stroke: UIColor,
        fill: UIColor,
        size: CGSize = CGSize(width: 10, height: 10),
        inset: CGFloat = 0,
        strokeWidth: CGFloat = UIUtils.seperatorWidth
        ) -> UIImage {

        let rect = CGRect(origin: CGPoint.zero, size: size).insetBy(dx: inset, dy: inset)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        let path = UIBezierPath(ovalIn: rect)

//        if let ctx = UIGraphicsGetCurrentContext() {
//            ctx.setLineWidth(<#T##width: CGFloat##CGFloat#>)
//        }
        path.lineWidth = strokeWidth * 2.0
        fill.setFill()
        stroke.setStroke()
        path.stroke()
        path.fill()
        

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    public func stretch() -> UIImage {
        return self.base.resizableImage(withCapInsets: UIEdgeInsets(top: self.base.size.height / 2.0, left: self.base.size.width / 2.0, bottom: self.base.size.height / 2.0, right: self.base.size.width / 2.0), resizingMode: .stretch)
    }
    
    public func tint(_ color: UIColor) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(self.base.size, false, self.base.scale)
        let rect = CGRect(x: 0, y: 0, width: self.base.size.width, height: self.base.size.height)
        color.set()
        UIRectFill(rect)
        self.base.draw(at: CGPoint(x: 0, y: 0), blendMode: CGBlendMode.destinationIn, alpha: 1)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? self.base
    }
    
    public func resize(_ size: CGSize) -> UIImage? {

        guard size.width > 0 && size.height > 0 else {
            return nil
        }

        UIGraphicsBeginImageContextWithOptions(size, false, self.base.scale)
        self.base.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();

        return image;
    }

    public func template() -> UIImage {
        return self.base.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    }

    public func original() -> UIImage {
        return self.base.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
}
