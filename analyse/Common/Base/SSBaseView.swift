//
//  SSBaseView.swift
//  stocks-ios
//
//  Created by Eason Lee on 03/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit

open class SSBaseView: UIView {

    convenience public init() {
        self.init(frame: CGRect.zero)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    open func setup() {

        self.layer.ss.themeHandler { (layer) in
            layer.shadowColor = SSColor.c404.cgColor
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()

        if self.layer.shadowRadius > 0 {
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        }
    }

}
