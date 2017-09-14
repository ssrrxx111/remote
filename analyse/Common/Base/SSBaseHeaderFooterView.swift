//
//  SSBaseHeaderFooterView.swift
//  stocks-ios
//
//  Created by Eason Lee on 07/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit

open class SSBaseHeaderFooterView: UITableViewHeaderFooterView {

    public var topLine: UIView = UIView()
    public var btmLine: UIView = UIView()
    
    public convenience init() {
        self.init(reuseIdentifier: "nonreusable")
    }

    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    open func setup() {
        self.clipsToBounds = true
        
        self.contentView.ss.themeHandler { (view) in
            view.backgroundColor = SSColor.c102.color
        }

        self.topLine.ss.customize { (line) in
            self.contentView.addSubview(line)
            line.isHidden = true
            line.ss.themeHandler { (view) in
                view.backgroundColor = SSColor.c404.color
            }
            line.snp.makeConstraints { (make) in
                make.leading.top.trailing.equalToSuperview()
                make.height.equalTo(UIUtils.seperatorWidth)
            }
        }
        self.btmLine.ss.customize { (line) in
            self.contentView.addSubview(line)
            line.isHidden = true
            line.ss.themeHandler { (view) in
                view.backgroundColor = SSColor.c404.color
            }
            line.snp.makeConstraints { (make) in
                make.leading.bottom.trailing.equalToSuperview()
                make.height.equalTo(UIUtils.seperatorWidth)
            }
        }
    }
}
