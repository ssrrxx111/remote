//
//  SSHUDManager.swift
//  Common
//
//  Created by Eason Lee on 19/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit
import MBProgressHUD

public enum SSHudIcon {
    case loading
    case success
    case failure
    case caution
    
    var icon: UIImage? {
        switch self {
        case .success:
            return SSImage.name("hud_success")
        case .failure:
            return SSImage.name("hud_failure")
        case .caution:
            return SSImage.name("hud_caution")
        default:
            return UIImage()
        }
    }
    
    case none
}

public let HUD = SSHUDManager()

public struct SSHUDManager {
    
    public init() {
        
    }
    
    public func toast(_ text: String, delay: TimeInterval = 1.2) {
        
        let hud = self.hud()
        
        hud.mode = .text
        hud.label.text = text
        hud.label.textColor = SSColor.c301.color
        
        hud.show(animated: true)
        
        if delay > 0.0 {
            hud.hide(animated: true, afterDelay: delay)
        }
    }
    
    public func show(_ title: String? = nil, detail: String? = nil, delay: TimeInterval = 0, view: UIView = CommonDispatcher.topVC?.view ?? UIView()) {
        
        self.show(.loading, title: title, detail: detail, delay: delay, view: view)
    }
    
    public func show(_ icon: SSHudIcon, title: String? = nil, detail: String? = nil, delay: TimeInterval = 1.0, view: UIView =  CommonDispatcher.topVC?.view ?? UIView()) {
        
        let closure = {

            let hud = self.hud(view)
            
            switch icon {
            case .loading:
                hud.mode = .indeterminate
            default:
                hud.mode = .customView
                
                hud.customView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30))).ss.customize({ (view) in
                    view.image = icon.icon
                })
                hud.label.textColor = SSColor.c301.color
                hud.detailsLabel.textColor = SSColor.c301.color
            }
            
            hud.label.text = title
            hud.detailsLabel.text = detail
            
            hud.show(animated: true)
            
            if delay > 0.0 {
                hud.hide(animated: true, afterDelay: delay)
            }
        }
        
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    
    public func hide(_ delay: TimeInterval = 0.0, view: UIView =  CommonDispatcher.topVC?.view ?? UIView()) {
        
        let closure = {
            
            guard let hud = MBProgressHUD(for: view) else {
                return
            }
            
            hud.hide(animated: true, afterDelay: delay)
        }
        
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    
    public func hud(_ view: UIView =  CommonDispatcher.topVC?.view ?? UIView()) -> MBProgressHUD {
        
        var hud: MBProgressHUD!
        if let h = MBProgressHUD(for: view) {
            hud = h
        } else {
            hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.bezelView.style = .blur
            hud.bezelView.backgroundColor = SSColor.c403.color
            hud.minShowTime = 0.5
            hud.animationType = .fade
            hud.label.font = SSFont.t06.font
            hud.detailsLabel.font = SSFont.t06.font
            hud.label.textColor = SSColor.c301.color
            hud.detailsLabel.textColor = SSColor.c301.color
        }
        
        return hud
    }
}
