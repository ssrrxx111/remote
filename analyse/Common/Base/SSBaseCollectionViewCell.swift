//
//  SSBaseCollectionViewCell.swift
//  NewUstock
//
//  Created by adad184 on 6/21/16.
//  Copyright © 2016 ustock. All rights reserved.
//

open class SSBaseCollectionViewCell: UICollectionViewCell {

    public let innerContentView = UIView()
    public var innerInsets = UIEdgeInsets.zero {
        didSet {
            self.innerContentView.snp.updateConstraints { (make) in
                make.top.leading.bottom.trailing.equalTo(self.contentView).inset(innerInsets)
            }
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    open func setup() {
        self.buildUI()
    }

    // build interface
    open func buildUI() {
        self.clipsToBounds = true

        // config
        self.innerContentView.ss.customize { (view) in
            self.contentView.addSubview(view)
            self.contentView.sendSubview(toBack: view)
        }
        
      
        self.contentView.backgroundColor = SSColor.none.color
        self.innerContentView.backgroundColor = SSColor.c102.color

        // layout
        self.contentView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalTo(self).priority(750)
        }

        self.innerContentView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalTo(self.contentView).inset(innerInsets)
        }
    }
}
