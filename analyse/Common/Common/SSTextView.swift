//
//  SSTextView.swift
//  Stocks-ios
//
//  Created by LJC on 6/30/17.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit

public class SSTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.ss.themeHandler { (view) in
            
            view.textColor = SSColor.c301.color
            view.tintColor = SSColor.c401.color
            view.backgroundColor = SSColor.c102.color
            view.keyboardAppearance = (StocksConfig.appearance.theme == .black) ? .dark : .light
        }
        
        self.ss.fontHandler { (view) in
            view.font = SSFont.t05.font
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


