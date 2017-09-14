//
//  SSTextField.swift
//  Stocks-ios
//
//  Created by LJC on 6/30/17.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit

open class SSTextField: UITextField {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()

        self.ss.themeHandler { (field) in

            field.ss.fontHandler({ (view) in
                view.font = SSFont.t06.bold
            })
            field.ss.themeHandler({ (view) in
                view.textColor = SSColor.c301.color

                if let placeholder = view.placeholder {
                    view.placeholder = placeholder
                }
            })
        }
    }
    
    open func setup() {
    
    }
    
    public var placeholderColor: SSColor = SSColor.c302 {
        didSet {
            if let placeholder = self.placeholder {
                self.placeholder = placeholder
            }
        }
    }

    override open var placeholder: String? {
        didSet {
            if let placeholder = placeholder {
                self.attributedPlaceholder = NSAttributedString(
                    string: placeholder,
                    attributes: [
                        NSFontAttributeName: SSFont.t06.bold,
                        NSForegroundColorAttributeName: self.placeholderColor.color.withAlphaComponent(0.5)
                    ]
                )
            }
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
