//
//  SSRefreshAnimationView.swift
//  Stocks-ios
//
//  Created by adad184 on 13/06/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit

public class SSRefreshAnimationView: SSBaseView {

    private var maxColumn: Int = 3

    private var backShapes: [CAShapeLayer] = []
    private var frontShapes: [CAShapeLayer] = []

    private var backShape: CAShapeLayer = CAShapeLayer()
    private var frontShape: CAShapeLayer = CAShapeLayer()

    public var hidesWhenStopped: Bool = false

    public var backColor: UIColor = SSColor.c302.color.withAlphaComponent(0.3) {
        didSet {
            self.backShape.ss.themeHandler { [weak self] (layer) in
                guard let `self` = self else {
                    return
                }
                layer.strokeColor = self.backColor.cgColor
            }
        }
    }

    public var frontColor: UIColor = SSColor.c401.color {
        didSet {
            self.frontShape.ss.themeHandler { [weak self] (layer) in
                guard let `self` = self else {
                    return
                }
                layer.strokeColor = self.frontColor.cgColor
            }
        }
    }

    override public func setup() {

        self.contentMode = .center

        let slicesCount = self.maxColumn * 2 - 1
        let width = self.frame.width / CGFloat(slicesCount)
        let path = UIBezierPath().ss.customize { (path) in
            for i in 0..<self.maxColumn {

                let x = width * CGFloat(i * 2)
                let y = self.frame.height / 2.0 - (self.frame.height / 2.0) / CGFloat(maxColumn - 1) * CGFloat(i)
                let rect = CGRect(x: x, y: y, width: width, height: self.frame.height - y)

//                SSLog(rect)
                path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            }
        }

        self.backShape.ss.customize { (layer) in
            layer.frame = self.layer.bounds
            layer.path = path.cgPath
            layer.strokeStart = 0.0
            layer.strokeEnd = 0.0
            layer.lineWidth = width

            layer.ss.themeHandler({ (layer) in
                layer.strokeColor = SSColor.c302.color.withAlphaComponent(0.3).cgColor
            })

            self.layer.addSublayer(layer)
        }

        self.frontShape.ss.customize { (layer) in
            layer.frame = self.layer.bounds
            layer.path = path.cgPath
            layer.strokeStart = 0.0
            layer.strokeEnd = 0.0
            layer.lineWidth = width

            layer.ss.themeHandler({ (layer) in
                layer.strokeColor = SSColor.c401.cgColor
            })

            self.layer.addSublayer(layer)
        }
    }

    public func updatePercent(_ percent: CGFloat) {

        self.backShape.strokeEnd = max(0, min(1, percent))

    }

    public func startAnimation() {

        if self.hidesWhenStopped {
            self.isHidden = false
        }

        self.updatePercent(1)

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1.8
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        self.frontShape.add(animation, forKey: "strokeEndAnimation")
    }

    public func stopAnimation(completion: (() -> Void)? = nil) {

        if self.hidesWhenStopped {
            self.isHidden = true
        }

        self.frontShape.removeAllAnimations()
        self.updatePercent(0)

        completion?()
    }
}
