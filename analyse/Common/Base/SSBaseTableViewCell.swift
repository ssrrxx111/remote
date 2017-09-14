//
//  SSBaseTableViewCell.swift
//  stocks-ios
//
//  Created by Eason Lee on 03/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit
import SnapKit

open class SSBaseTableViewCell: UITableViewCell {

    override open func awakeFromNib() {
        super.awakeFromNib()
    }

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public var topLineInset: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0) {
        didSet {
            self.topLine.snp.remakeConstraints { (make) in
                make.leading.top.trailing.equalToSuperview().inset(btmLineInset)
                make.height.equalTo(UIUtils.seperatorWidth)
            }
        }
    }
    
    public var btmLineInset: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0) {
        didSet {
            self.btmLine.snp.remakeConstraints { (make) in
                make.leading.bottom.trailing.equalToSuperview().inset(btmLineInset)
                make.height.equalTo(UIUtils.seperatorWidth)
            }
        }
    }
    
    public let contentGuide: UILayoutGuide = UILayoutGuide()
    
    public var topLine: UIView = UIView()
    public var btmLine: UIView = UIView()
    public var isHighlightEnabled: Bool = true
    public var highlightView: UIView = UIView()

    public var registeredFor3DTouch: Bool = false

//    private var shadowView: UIImageView = UIImageView()

    open func setup() {

        self.clipsToBounds = false
        self.contentView.clipsToBounds = true
        self.selectionStyle = .none
        
        self.contentView.addLayoutGuide(self.contentGuide)
        
        self.ss.themeHandler { (view) in
            view.backgroundColor = SSColor.c102.color
        }
        
        self.contentView.ss.themeHandler { (view) in
            view.backgroundColor = SSColor.c102.color
        }

        self.layer.ss.themeHandler { (layer) in
            layer.shadowColor = SSColor.c404.cgColor
        }

        self.highlightView.ss.themeHandler { (view) in
            view.backgroundColor = SSColor.c405.color
        }
        self.highlightView.isHidden = true
        self.contentView.addSubview(self.highlightView)

        self.highlightView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentGuide.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
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

    open override func layoutSubviews() {
        super.layoutSubviews()

        if self.layer.shadowRadius > 0 {
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        }
    }
    
    public func updateSelf() {
        
        var sv = self.superview
        
        while sv != nil {
            if sv is UITableView {
                break
            }
            
            sv = sv!.superview
        }
        
        guard let tableView = sv as? UITableView ,
            tableView.indexPath(for: self) != nil else {
                return
        }
        
        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

    public static var noSeperateInsets: UIEdgeInsets {
        return UIEdgeInsets(
            top: 0,
            left: -UIScreen.main.bounds.size.width,
            bottom: 0,
            right: UIScreen.main.bounds.size.width * 2.0
        )
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        if self.isHighlightEnabled {
            self.highlightView.isHidden = !highlighted
        }
    }
}

public let SSBottomShadowCellSeperatorHeight: CGFloat = 7

open class SSBottomShadowCell: SSBaseTableViewCell {
    
    public var showShadow: Bool = true {
        didSet {
            self.contentView.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(showShadow ? -SSBottomShadowCellSeperatorHeight : 0)
            }
            self.contentView.ss.applyShadow(showShadow ? .bottom : .none)
            self.setNeedsLayout()
        }
    }
    
    open override func setup() {
        super.setup()
        
        self.ss.themeHandler { (view) in
            view.backgroundColor = SSColor.c101.color
        }
        
        self.btmLine.isHidden = false
        self.contentView.ss.applyShadow(.bottom)
        
        self.contentView.snp.remakeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-SSBottomShadowCellSeperatorHeight)
        }
    }
}

open class SSSubtitleCell: SSBaseTableViewCell {

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class SSValue1Cell: SSBaseTableViewCell {

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class SSValue2Cell: SSBaseTableViewCell {

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value2, reuseIdentifier: reuseIdentifier)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

