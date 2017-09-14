//
//  XXWindow.swift
//
//
//  Created by adad184 on 7/11/16.
//  Copyright © 2016 ustock. All rights reserved.
//

import UIKit

public let XXPopupWindow = XXWindow(level: 1.0)
public let XXBubbleWindow = XXWindow(level: 2.0)
public let XXPickerWindow = XXWindow(level: 3.0)
public let XXSheetWindow = XXWindow(level: 4.0)
public let XXAlertWindow = XXWindow(level: 5.0)

open class XXWindow: UIWindow {

    let statusBarRelativeController = XXRootViewController()

    public init(level: UIWindowLevel = 0) {
        super.init(frame: UIScreen.main.bounds)

        self.windowLevel = UIWindowLevelStatusBar + level

        self.rootViewController = self.statusBarRelativeController
        self.statusBarRelativeController.view.isUserInteractionEnabled = false
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

//    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        return super.hitTest(point, with: event)?.ss.customize({ (view) in
//
//
//            var v: UIView? = view
//
//            SSLog("=========")
//            while v != nil {
//                SSLog(" --\(v!)")
//                v = v?.superview
//            }
//
//        })
//    }
    
}

class XXRootViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return CommonDispatcher.topVC?.preferredStatusBarStyle ?? .default
    }

    override var prefersStatusBarHidden: Bool {
        return CommonDispatcher.topVC?.prefersStatusBarHidden ?? false
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return CommonDispatcher.topVC?.preferredStatusBarUpdateAnimation ?? .none
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return CommonDispatcher.topVC?.supportedInterfaceOrientations ?? .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return CommonDispatcher.topVC?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
}
