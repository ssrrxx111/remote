//
//  SSBaseTabBarViewController.swift
//  Common
//
//  Created by Hugo on 2017/5/9.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import UIKit

open class SSBaseTabBarViewController: UITabBarController {
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setup() {
        
        _ = UIView().ss.customize { (view) in
            
            self.tabBar.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.left.top.right.equalToSuperview()
                make.height.equalTo(UIUtils.seperatorWidth)
            }
            
            view.ss.themeHandler({ (view) in
                view.backgroundColor = SSColor.c413.color
            })
        }
        
    }

    public func hideTabbar(_ animate: Bool) {
        var frame = self.tabBar.frame
        frame.origin.y += frame.height
        UIView.animate(withDuration: 0.3,
                       animations: { 
                        //
                        self.tabBar.frame = frame
        },
                       completion: { _ in
                        //
                        self.tabBar.isHidden = true
        })
    }

    public func showTabbar(_ animate: Bool) {
        self.tabBar.isHidden = false
        var frame = self.tabBar.frame
        frame.origin.y -= frame.height
        UIView.animate(withDuration: 0.3,
                       animations: {
                        //
                        self.tabBar.frame = frame
        },
                       completion: { _ in
                        //
        })
    }

    open override var prefersStatusBarHidden: Bool {
        return self.selectedViewController!.prefersStatusBarHidden
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.selectedViewController!.preferredStatusBarStyle
    }
    
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return self.selectedViewController!.preferredStatusBarUpdateAnimation
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.selectedViewController!.supportedInterfaceOrientations
    }
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.selectedViewController!.preferredInterfaceOrientationForPresentation
    }
    
}
