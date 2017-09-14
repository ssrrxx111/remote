//
//  SSNavigationController.swift
//  Common
//
//  Created by Eason Lee on 23/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit

open class SSNavigationController: UINavigationController {

    public var isPurchasing: (() -> Bool)?

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {

        if let pc = isPurchasing, pc() {
            return UIInterfaceOrientationMask.portrait
        }

        if let top = self.topViewController, top.supportedInterfaceOrientations == .all {
            if let _ = top.presentedViewController {
                return UIInterfaceOrientationMask.portrait
            }
        }
        return self.topViewController?.supportedInterfaceOrientations ?? .portrait
    }

    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
    
    open override var prefersStatusBarHidden: Bool {
        return self.topViewController?.prefersStatusBarHidden ?? false
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? .default
    }
    
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return self.topViewController?.preferredStatusBarUpdateAnimation ?? .none
    }

}
