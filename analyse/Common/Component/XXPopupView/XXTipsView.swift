//
//  XXTipsView.swift
//  Stocks-ios
//
//  Created by Ze乐 on 2017/5/21.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import UIKit
import MBProgressHUD

public class XXTipsView: XXPopupView {
    
    var anchorView: UIView
    
    var arrowView: UIImageView = UIImageView()
    
    var contentView: UIView = UIView()
    var tipsLabel: UILabel = UILabel()
    
    weak var nav: UINavigationController?

    init(anchorView: UIView, text: String) {
        self.anchorView = anchorView
        self.tipsLabel.text = text
        
        super.init(frame: CGRect.zero)
        
        buildUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func buildUI() {
        
        targetView = XXBubbleWindow
        type = .custom
        
        if superview == nil {
            targetView!.xx_dimBackgroundView.addSubview(self)
            
            self.snp.makeConstraints({ (make) in
                make.leading.trailing.equalTo(targetView!)
                make.top.equalTo(targetView!)
            })
            targetView!.xx_dimBackgroundAnimatingDuration = 0.15
            duration = self.targetView!.xx_dimBackgroundAnimatingDuration
        }
        
        arrowView.contentMode = .center
        let size = CGSize(width: 15, height: 15)
        let color = SSColor.c101.color
        arrowView.image = UIImage.xx_rhombusWithSize(size, color: color)
        addSubview(arrowView)
        
        self.contentView.ss.customize { (view) in
            view.ss.themeHandler { (view) in
                view.backgroundColor = SSColor.c101.color
            }
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 4
            self.addSubview(view)
        }
        
        self.tipsLabel.ss.customize { (view) in
            view.font = SSFont.t05.font
            view.numberOfLines = 0
            view.lineBreakMode = NSLineBreakMode.byWordWrapping
            view.ss.themeHandler { (view) in
                view.backgroundColor = SSColor.c101.color
                view.textColor = SSColor.c301.color
            }
            self.contentView.addSubview(view)
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(self).offset(-16)
            make.top.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-10)
        }
        
        self.tipsLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(self.contentView).inset(UIEdgeInsetsMake(10, 10, 10, 10))
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        targetView!.addGestureRecognizer(tap)
        
        layoutIfNeeded()
    }
    
    @objc func tapAction(_ gesture: UITapGestureRecognizer) {
        hide()
    }

    
    override public func showAnimation(completion closure: ((XXPopupView, Bool) -> Void)?) {
        
        targetView!.xx_dimBackgroundView.layoutIfNeeded()
        targetView!.xx_dimBackgroundAnimatingDuration = 0.15
        
        typealias Config = XXBubbleViewConfig
        
        let center = getAnchorPosition(self.anchorView)
        let heightOffset = anchorView.frame.size.height
//        let arrowOffset = Config.arrowWidth * 2 + Config.cornerRadius
//        let xOffsetRatio = arrowOffset / frame.width
        
        layer.anchorPoint = CGPoint(x: layer.anchorPoint.x, y: 0.0)
        layer.position = CGPoint(x: layer.position.x, y: center.y + heightOffset)
        
        arrowView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.centerY.equalTo(self.contentView.snp.top)
            make.left.equalTo(self.contentView.snp.left)
        }
        
        layer.transform = CATransform3DMakeScale(0.01, 0.01, 1.0)
        anchorView.isHidden = true
        if let control = anchorView as? UIControl {
            control.isEnabled = false
        }
        
        UIView.animate(
            withDuration: self.duration,
            delay: 0.0,
            options: [
                UIViewAnimationOptions.curveEaseOut,
                UIViewAnimationOptions.beginFromCurrentState
            ],
            animations: {
                self.layer.transform = CATransform3DIdentity
        },
            completion: { (finished: Bool) in
                if let completionClosure = closure {
                    completionClosure(self, finished)
                }
        })
    }
    
    override public func hideAnimation(completion closure: ((_ popupView: XXPopupView, _ finished: Bool) -> Void)?) {
        
        anchorView.isHidden = false
        if let control = anchorView as? UIControl {
            control.isEnabled = true
        }
        // anchorImageView.isHidden = true
        
        UIView.animate(
            withDuration: self.duration,
            delay: 0.0,
            options: [
                UIViewAnimationOptions.curveEaseIn,
                UIViewAnimationOptions.beginFromCurrentState
            ],
            animations: {
                self.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1.0)
        },
            completion: { (finished: Bool) in
                if finished {
                    self.removeFromSuperview()
                }
                if let completionClosure = closure {
                    completionClosure(self, finished)
                }
        })
    }
    
    func getAnchorPosition(_ anchorView: UIView) -> CGPoint {
        
        let window = self.getAnchorWindow(anchorView)
        
        let center = CGPoint(x: anchorView.frame.width / 2.0, y: anchorView.frame.height / 2.0)
        
        return anchorView.convert(center, to: window)
    }
    
    func getAnchorWindow(_ anchorView: UIView) -> UIWindow {
        
        var sv = anchorView.superview
        
        while sv != nil {
            if sv!.isKind(of: UIWindow.self) {
                break
            }
            
            sv = sv!.superview
        }
        
        assert(sv != nil, "fatal: anchorView should be on some window")
        
        let window = sv as! UIWindow
        
        return window
    }
}
