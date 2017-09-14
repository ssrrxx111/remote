//
//  UIView+Swifty.swift
//  Common
//
//  Created by adad184 on 09/05/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import Foundation
import SnapKit

public enum SSLayoutAlignment {
    case top
    case bottom
    case left
    case right
    case leading
    case trailing
    case center
    case fill
    case equal
    case none
}

public enum SSLayoutDistribution {
    case fill
    case fillEqually
    case none
}

public enum SSLayoutAxis {
    case horizontal
    case vertical
}

public enum SSShadowType: Int {
    case none
    case top
    case left
    case bottom
    case right

    fileprivate var radius: CGFloat {

        return self == .none ? 0 : 3
    }

    fileprivate var offset: CGSize {

        switch self {
        case .top:
            return CGSize(width: 0, height: -self.radius)
        case .left:
            return CGSize(width: -self.radius, height: 0)
        case .bottom:
            return CGSize(width: 0, height: self.radius)
        case .right:
            return CGSize(width: self.radius, height: 0)
        default:
            return CGSize.zero
        }
    }
}

fileprivate struct SSSwiftyKey {
    static var shadow = 0
}

fileprivate struct USViewUnderlineKey {
    static fileprivate var width = 0
    static fileprivate var color = 0
    static fileprivate var view = 0
}

extension SSSwifty where Base: UIView {
    

    public func applyShadow(_ type: SSShadowType = .bottom) {
        self.base.layer.shadowOpacity = 0.05
        self.base.layer.masksToBounds = type == .none
        self.base.layer.shadowRadius = type.radius
        self.base.layer.shadowOffset = type.offset
        
        self.base.layer.ss.themeHandler { (layer) in
            layer.shadowColor = SSColor.c414.cgColor
        }
    }
    
    public var underlineWidth: CGFloat {
        get {
            guard let number = objc_getAssociatedObject(self, &USViewUnderlineKey.width) as? NSNumber else {
                return 0
            }
            return CGFloat(number)
        }
        set {
            
            let number = NSNumber(value: Float(newValue) as Float)
            objc_setAssociatedObject(self, &USViewUnderlineKey.width, number, .OBJC_ASSOCIATION_RETAIN)
            self.underlineView.snp.updateConstraints { (make) in
                make.height.equalTo(newValue)
            }
        }
    }
    
    public var underlineColor: UIColor {
        get {
            guard let color = objc_getAssociatedObject(self.base, &USViewUnderlineKey.color) as? UIColor else {
                return UIColor.clear
            }
            return color
        }
        set {
            objc_setAssociatedObject(self, &USViewUnderlineKey.color, newValue, .OBJC_ASSOCIATION_RETAIN)
            self.underlineView.backgroundColor = newValue
        }
    }
    
    private var underlineView: UIView {
        get {
            guard let view = objc_getAssociatedObject(self.base, &USViewUnderlineKey.view) as? UIView else {
                
                let newView = UIView()
                newView.backgroundColor = SSColor.c501.color
                self.base.addSubview(newView)
                
                newView.snp.makeConstraints({ (make) in
                    make.left.bottom.right.equalToSuperview()
                    make.height.equalTo(0)
                })
                
                objc_setAssociatedObject(self, &USViewUnderlineKey.view, newView, .OBJC_ASSOCIATION_RETAIN)
                
                return newView
            }
            return view
        }
    }

    public func layout( _ subViews: [UIView], distribution: SSLayoutDistribution, alignment: SSLayoutAlignment, axis: SSLayoutAxis ) {

        guard let firstView = subViews.first else { return }
        guard let lastView  = subViews.last else { return }

        self.base.translatesAutoresizingMaskIntoConstraints = false

        // 确保subView都添加到了当前view上
        for view in subViews {
            self.base.addSubview(view)
        }

        // 添加第一条约束
        firstView.snp.makeConstraints { (make) in
            if axis == .horizontal {
                make.leading.equalTo(self.base.snp.leading)
            } else {
                make.top.equalTo(self.base.snp.top)
            }
        }

        // 添加最后一条约束
        lastView.snp.makeConstraints { (make) in
            if axis == .horizontal {
                make.trailing.equalTo(self.base.snp.trailing)
            } else {
                make.bottom.equalTo(self.base.snp.bottom)
            }
        }

        // 根据参数设置dirstribution
        for i in 1 ..< subViews.count {
            let preView = subViews[i-1]
            let view = subViews[i]

            view.snp.makeConstraints({ (make) in
                switch distribution {
                case .fillEqually:
                    if axis == .horizontal {
                        make.width.equalTo(preView)
                    } else {
                        make.height.equalTo(preView)
                    }
                    fallthrough
                case .fill:
                    if axis == .horizontal {
                        make.leading.equalTo(preView.snp.trailing)
                    } else {
                        make.top.equalTo(preView.snp.bottom)
                    }
                default:
                    break
                }
            })
        }

        for i in 0 ..< subViews.count {
            let view = subViews[i]

            view.snp.makeConstraints({ (make) in
                switch alignment {
                case .top:
                    if axis == .horizontal {
                        make.top.equalTo(self.base.snp.top)
                    }
                case .bottom:
                    if axis == .horizontal {
                        make.bottom.equalTo(self.base.snp.bottom)
                    }
                case .left:
                    if axis == .vertical {
                        make.left.equalTo(self.base.snp.left)
                    }
                case .right:
                    if axis == .vertical {
                        make.right.equalTo(self.base.snp.right)
                    }
                case .leading:
                    if axis == .vertical {
                        make.leading.equalTo(self.base.snp.leading)
                    }
                case .trailing:
                    if axis == .vertical {
                        make.trailing.equalTo(self.base.snp.trailing)
                    }
                case .center:
                    if axis == .horizontal {
                        make.centerY.equalTo(self.base.snp.centerY)
                    } else if axis == .vertical {
                        make.centerX.equalTo(self.base.snp.centerX)
                    }
                case .fill:
                    if axis == .horizontal {
                        make.top.bottom.equalToSuperview()
                    } else if axis == .vertical {
                        make.leading.trailing.equalToSuperview()
                    }
                case .equal:
                    if i == 0 {
                        break
                    }
                    if axis == .horizontal {
                        make.top.bottom.equalTo(firstView)
                    } else if axis == .vertical {
                        make.leading.trailing.equalTo(firstView)
                    }
                default:
                    break
                }
            })
        }
    }
}
