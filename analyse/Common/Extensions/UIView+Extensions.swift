//
//  UIView+Extensions.swift
//  Common
//
//  Created by Ze乐 on 2017/6/22.
//  Copyright © 2017年 Stocks. All rights reserved.
//
import Foundation

extension UIView {
    public var top: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }
    
    public var left: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }
    
    public var right: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
        get {
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    public var bottom: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
        get {
            return self.frame.origin.y + self.frame.size.height
        }
    }
    
    public var height: CGFloat {
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: newValue)
        }
        get {
            return self.frame.height
        }
    }
    
    public var width: CGFloat {
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newValue, height: self.frame.height)
        }
        get {
            return self.frame.width
        }
    }
    
    public var x: CGFloat {
        set {
            self.frame = CGRect(x: newValue, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
        }
        get {
            return self.frame.origin.x
        }
    }
    
    public var y: CGFloat {
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: newValue, width: self.frame.width, height: self.frame.height)
        }
        get {
            return self.frame.origin.y
        }
    }
    
    public func removeAllSubviews() {
        while let lastSubview = self.subviews.last {
            lastSubview.removeFromSuperview()
        }
    }
    
    public var centerY: CGFloat {
        set {
            self.center = CGPoint(x: self.center.x, y: newValue);
        }
        get {
            return self.center.y
        }
    }
    
    public var centerX: CGFloat {
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
        get {
            return self.center.x
        }
    }
    
    /**
     Returns the UIViewController object that manages the receiver.
     返回当前view的viewController
     */
    public func viewController() -> UIViewController? {
        
        var nextResponder: UIResponder? = self
        
        repeat {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            
        } while nextResponder != nil
        
        return nil
    }
    
    public func drawDashLine() {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        
        shapeLayer.bounds = self.bounds
        shapeLayer.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = SSColor.c302.cgColor
        
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [NSNumber(value: 2), NSNumber(value: 2)]
        
        let path:CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        shapeLayer.path = path
        
        self.layer.addSublayer(shapeLayer)
    }
}
