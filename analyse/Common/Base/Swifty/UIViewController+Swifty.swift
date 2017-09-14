//
//  UIViewController+Swifty.swift
//  NewUstock
//
//  Created by adad184 on 8/12/16.
//  Copyright © 2016 ustock. All rights reserved.
//

import Foundation

extension SSSwifty where Base: UIViewController {

    public func push(_ vc: UIViewController, animated: Bool = true) {

        self.base.navigationController?.pushViewController(vc, animated: animated)
    }

    public func replace(_ vc: UIViewController, animated: Bool = true) {

        if var viewControllers = self.base.navigationController?.viewControllers {
            viewControllers.removeLast()
            viewControllers.append(vc)
            self.base.navigationController?.setViewControllers(viewControllers, animated: animated)
        }
    }

    public func pop(_ vc: UIViewController? = nil, animated: Bool = true) {

        if let vc = vc {
            _ = self.base.navigationController?.popToViewController(vc, animated: animated)
        } else {
            _ = self.base.navigationController?.popViewController(animated: animated)
        }
    }
    
    public func findController(of aClass: Swift.AnyClass) -> UIViewController? {

        guard let nav = self.base.navigationController else {
            return nil
        }
        
        for i in 0..<nav.viewControllers.count {
            let vc = nav.viewControllers[i]
            if vc.isKind(of: aClass) {
                return vc
            }
        }
        return nil
    }

    public func popToRoot(_ animated: Bool = true) {

        _ = self.base.navigationController?.popToRootViewController(animated: animated)
    }

    public func present(_ vc: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {

        self.base.present(vc, animated: animated, completion: completion)
    }

    public func dismiss(_ animated: Bool = true, completion: (() -> Void)? = nil) {

        self.base.dismiss(animated: animated, completion: completion)
    }

    public var topViewController: UIViewController {
        get {

            if let vc = self.base.presentedViewController {

                return vc.ss.topViewController

            } else if self.base.isKind(of: UINavigationController.self) {

                if let vc = (self.base as! UINavigationController).visibleViewController {
                    return vc.ss.topViewController
                }

            } else if self.base.isKind(of: UITabBarController.self) {

                if let vc = (self.base as! UITabBarController).selectedViewController {
                    return vc.ss.topViewController
                }

            }
            else if self.base.isKind(of: SSPageController.self) {

                if let vc = (self.base as! SSPageController).currentViewController {
                    return vc.ss.topViewController
                }
            }

            return self.base
        }
    }
}
