//
//  SSRefreshHeader.swift
//  Stocks-ios
//
//  Created by adad184 on 13/06/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit
import MJRefresh

open class SSRefreshHeader: MJRefreshHeader {

    public var longBackView: UIImageView = UIImageView()
    public var shapeView: SSRefreshAnimationView = SSRefreshAnimationView(frame: CGRect(x: 0, y:0, width:15, height:15))
    fileprivate var _usState: MJRefreshState = .idle

    override open func prepare() {
        super.prepare()
        // 设置高度
        self.mj_h = 35;
        self.isAutomaticallyChangeAlpha = false
        
        self.backgroundColor = SSColor.none.color
        
//        self.longBackView.backgroundColor = SSColor.debug.color

        self.addSubview(self.shapeView)
        
        self.insertSubview(self.longBackView, belowSubview: self.shapeView)
    }
    override open func placeSubviews() {
        super.placeSubviews()
        
        self.shapeView.center = CGPoint(x: self.mj_w / 2, y: self.mj_h / 2)
        self.longBackView.frame = CGRect(x: 0, y: -2.0*Utils.screenHeight + self.mj_h, width: Utils.screenWidth, height: 2.0*Utils.screenHeight)
    }

    // 拉拽的百分比, 0-0.5不进行动画，0.5-1渐变动画  1-1.5旋转动画 >1.5停止动画
    override open var pullingPercent: CGFloat {
        didSet {
            if self.scrollView.isDragging {
                self.shapeView.updatePercent(pullingPercent)
            }
        }
    }

    private func defaultSet(_ newValue: MJRefreshState) {
        _usState =  newValue
        // 加入主队列的目的是等setState:方法调用完毕、设置完文字后再去布局子控件
        DispatchQueue.main.async {
            self.setNeedsLayout()
        }
    }

    override open var state: MJRefreshState {
        get {
            return _usState
        }
        set {
            switch newValue {
            case .refreshing:
                self.defaultSet(newValue)
                
                DispatchQueue.main.async {
                    UIView.animate(
                        withDuration: TimeInterval(MJRefreshFastAnimationDuration),
                        animations: { [weak self] (_) in
                            guard let `self` = self else {
                                return
                            }
                            
                            let top = self.scrollViewOriginalInset.top + self.mj_h
                            // 增加滚动区域top
                            self.scrollView.mj_insetT = top
                            // 设置滚动位置
                            self.scrollView.setContentOffset(CGPoint(x:0, y: -top), animated: false)
                            
                        },
                        completion: { [weak self] (_) in
                            
                            guard let `self` = self else {
                                return
                            }
                            
                            self.shapeView.startAnimation()
                            self.executeRefreshingCallback()
                    })
                }
            case .idle:
                
                guard state == .refreshing else {
                    self.defaultSet(newValue)
                    return
                }
                
                DispatchQueue.main.async {
                    self.shapeView.stopAnimation{ [weak self] in
                        
                        guard let `self` = self else {
                            return
                        }
                        
                        if self.endRefreshingCompletionBlock != nil {
                            self.endRefreshingCompletionBlock()
                        }
                        
                    }
                    
                    UIView.animate(
                        withDuration: TimeInterval(MJRefreshFastAnimationDuration),
                        animations: { [weak self] (_) in
                            
                            guard let `self` = self else {
                                return
                            }
                            
                            guard let scrollView = self.scrollView else {
                                    return
                            }
                            
                            scrollView.mj_insetT = self.scrollViewOriginalInset.top
                            // 自动调整透明度
                            
                            if (self.isAutomaticallyChangeAlpha){
                                self.alpha = 0.0
                            }
                            
                        },
                        completion: { [weak self] (_) in
                            
                            guard let `self` = self else {
                                return
                            }
                            
                            guard let scrollView = self.scrollView else {
                                return
                            }
                            
                            //测试发现，动画设置contentinset有可能失败，所以结束动画之后重新设置
                            scrollView.mj_insetT = self.scrollViewOriginalInset.top
                            self.defaultSet(newValue)
                            self.pullingPercent = 0.0;
                    })
                    
                }
            case .pulling:
                self.defaultSet(newValue)
                break
            default:
                self.defaultSet(newValue)
                break
            }

        }
    }

}

