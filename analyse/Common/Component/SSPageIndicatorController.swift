//
//  KYPageController.swift
//  iOutdoors
//
//  Created by Kyle on 15/8/7.
//  Copyright (c) 2015年 xiaoluuu. All rights reserved.
//

import Foundation
import UIKit

open class SSPageIndicatorController: UIView {

    fileprivate func radians(_ degree: Double) -> Double {

        return degree * Double.pi / 180.0
    }

    // MARK: - ------------------
    // MARK: override property
    public var borderColor: UIColor! = UIColor.clear {

        didSet {
            self.setNeedsDisplay()
        }
    }
    public var hilightColor: UIColor? = SSColor.c102.color {

        didSet {
            self.setNeedsDisplay()
        }

    }
    public var normalColor: UIColor? = SSColor.c101.color {

        didSet(color) {
            self.setNeedsDisplay()
        }

    }

    public var hilightImage: UIImage? {

        didSet {
            self.setNeedsDisplay()
        }

    }
    public var normalImage: UIImage? {

        didSet {

            self.setNeedsDisplay()
        }

    }

    public var dotWidth: CGFloat! = 5.0 {

        didSet {
            self.setNeedsDisplay()
        }

    }

    public var dotSpace: CGFloat! = 5.0 {

        didSet {
            self.setNeedsDisplay()
        }

    }

    public var current: Int? {

        didSet(cur) {
            self.setNeedsDisplay()
        }

    }
    public var pageNumber: Int! = 0 {

        didSet {
            self.setNeedsDisplay()
        }

    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   // MARK: over write the drawRect
    override open func draw(_ rect: CGRect) {

        if pageNumber == 0 || pageNumber == 1 { //不用轮播
            return
        }

        let context: CGContext! = UIGraphicsGetCurrentContext()
        context.setAllowsAntialiasing(true)

        let currentBounds: CGRect! = self.bounds
        let dotsWidth: CGFloat = CGFloat(pageNumber) * dotWidth + CGFloat(max(0, (pageNumber-1)))*dotSpace!
        var x = currentBounds.midX - CGFloat(dotsWidth/2)
        let y = currentBounds.height/2 - CGFloat(dotWidth/2)

        for i in 0..<pageNumber {

            let circleRect = CGRect(x: x - dotWidth/2, y: y - dotWidth/2, width: dotWidth, height: dotWidth)

            context.setStrokeColor(self.borderColor.cgColor)
            let path = CGMutablePath()
            context.setLineWidth(5)
//            path.addArc(center: CGPoint(x: x+self.dotWidth/2, y: x+self.dotWidth/2), radius: self.dotWidth/2, startAngle: CGFloat(radians(0)), endAngle: CGFloat(radians(360)), clockwise: false)
            path.addRect(CGRect(x: x - dotWidth/2, y: y - dotWidth/2, width: dotWidth, height: dotWidth))
            
            context.addPath(path)
//            context.strokePath()
            context.fillPath()

            if i == current {
                if hilightImage != nil {
                    hilightImage?.draw(in: circleRect)
                } else {
                    context.setFillColor((self.hilightColor?.cgColor)!)
                    context.fill(circleRect)
                }

            } else {

                if normalImage != nil {
                    normalImage?.draw(in: circleRect)
                } else {
                    context.setFillColor((self.normalColor?.cgColor)!)
                    context.fill(circleRect)
                }

            }

            x += self.dotWidth + self.dotSpace

        }
    }

}
