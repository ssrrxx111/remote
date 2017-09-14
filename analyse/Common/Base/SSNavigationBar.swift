//
//  SSNavigationBar.swift
//  Common
//
//  Created by adad184 on 29/05/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit

public class SSNavigationBar: UINavigationBar {
    
    public let line: UIView = UIView()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.setup()
    }

    public var isTranslucentBackground: Bool = false {
        didSet {
            self.updateBackgroundImage()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setup() {
        
        self.isTranslucent = true
        self.shadowImage = UIImage()
        self.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: .default)
        
        self.line.ss.customize { (view) in
            //            view.isHidden = true
            self.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.left.equalTo(self.snp.left)
                make.right.equalTo(self.snp.right)
                make.bottom.equalTo(self.snp.bottom)
                make.height.equalTo(UIUtils.seperatorWidth)
            }
            
            view.ss.themeHandler({ (view) in
                view.backgroundColor = SSColor.c413.color
            })
        }
    }

    public func updateBackgroundImage() {

        if self.isTranslucentBackground {
            self.backgroundColor = nil
        } else {
            
            self.backgroundColor = UIUtils.navigatinBarBackgroundColor()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if #available(iOS 11, *) {
            for view in self.subviews {
                if view.ss.className == "_UINavigationBarContentView" {
                    var frame = view.frame
                    frame.origin.y = 20
                    view.frame = frame
                    
                    return
                }
            }
        }
    }
}
