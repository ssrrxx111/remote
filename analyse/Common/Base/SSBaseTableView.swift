//
//  SSBaseTableView.swift
//  stocks-ios
//
//  Created by Eason Lee on 03/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit

open class SSBaseTableView: UITableView {

    override public init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)

        self.backgroundColor = UIColor.clear
        self.estimatedRowHeight = 100
        self.rowHeight = UITableViewAutomaticDimension
        self.separatorStyle = .none
        self.delaysContentTouches = false

        self.ss.registerCell(UITableViewCell.self)
        self.ss.registerCell(SSBaseTableViewCell.self)

        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func setup() {

    }

}

open class SSBaseSeperateTableView: SSBaseTableView {

    open override func setup() {
        super.setup()
        separatorStyle = .singleLine
        separatorColor = SSColor.c501.color
    }
    
}
