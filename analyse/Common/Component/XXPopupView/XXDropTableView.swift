//
//  XXDropTableView.swift
//  demoMQTT
//
//  Created by adad184 on 7/12/16.
//  Copyright © 2016 adad184. All rights reserved.
//

import UIKit

public protocol XXDropTableViewDelegate: class {

    func willShow(_ view: XXDropTableView)

    func willHide(_ view: XXDropTableView)

}

open class XXDropTableView: XXPopupView {

    public var isShow = false
    public var viewHeight: CGFloat = 0
    public var maxCellCount = 5

    public weak var delegate: XXDropTableViewDelegate?

    public var cellAction: [XXActionItem] = [XXActionItem]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    public var footerActions: [XXActionItem] = []

    public var footerButtons = [UIButton]()
    public var buttonView = UIView()
    public let tableView = UITableView()

    public var selectedIndex: Int? {
        didSet {
            if let index = selectedIndex {
                tableView.selectRow(at: IndexPath(row: index, section: 0),
                                    animated: false,
                                    scrollPosition: .none)
            }
        }
    }

    open var selectString: String? {
        didSet {
            guard let string = selectString else {
                return
            }

            for (index, element) in cellAction.enumerated() {
                if element.title == string {
                    self.selectedIndex = index
                    break
                }
            }
        }
    }

    fileprivate override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public init(cellAction: [XXActionItem], footerActions: [XXActionItem]) {
        super.init(frame: CGRect.zero)

        self.cellAction = cellAction
        self.footerActions = footerActions

        self.buildUI()
    }

    open func buildUI() {

        assert(self.cellAction.count > 0, "Need at least 1 action")

        typealias Config = XXDropTableViewConfig
        self.type = .drop

        self.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        self.setContentHuggingPriority(UILayoutPriorityFittingSizeLevel, for: .horizontal)

        ({ (view: UITableView) in
            view.delegate = self
            view.dataSource = self
            view.separatorStyle = .none
            view.register(XXDropTableViewCell.self, forCellReuseIdentifier: "XXDropTableViewCell")
            view.isScrollEnabled = self.cellAction.count > Config.maxNumberOfItems
            view.canCancelContentTouches = false
            view.delaysContentTouches = false
            view.backgroundColor = Config.cellBackgroundNormalColor

            self.addSubview(view)
            }(self.tableView))

        let gapView: UIView = UIView()
        gapView.backgroundColor = SSColor.c101.color
        addSubview(gapView)

        buttonView = UIView()
        buttonView.backgroundColor = SSColor.c102.color
        addSubview(buttonView)

        let height = CGFloat(min(maxCellCount, cellAction.count)) * Config.cellHeight
        self.tableView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(self)
            make.height.equalTo(height).priority(750)
            if self.footerActions.isEmpty {
                make.bottom.equalTo(self.snp.bottom)
            }
        }

        gapView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(self.tableView.snp.bottom).offset(-Config.splitWidth)
            make.height.equalTo(0.5)
        }

        self.buttonView.snp.makeConstraints { (make) in
            make.top.equalTo(gapView.snp.bottom)
            make.leading.bottom.trailing.equalTo(self)
            make.height.equalTo(Config.cellHeight)
        }

        // let offset = 0.0 / (UIScreen.main.bounds.width / 375.0)
        for (index, footAction) in self.footerActions.enumerated() {

            let button: UIButton = {
                let btn = SSImageButton(position: .left, spacing: 8)
                btn.addTarget(self, action: #selector(actionFooter(_:)), for: .touchUpInside)
                btn.backgroundColor = SSColor.c101.color
                btn.setTitleColor(SSColor.c302.color, for: .normal)
                btn.setTitle(footAction.title, for: .normal)
                btn.titleLabel?.font = SSFont.t04.font
                btn.setImage(footAction.image, for: .normal)
                btn.clipsToBounds = false
                btn.tag = index
                self.buttonView.addSubview(btn)
                return btn
            }()
            self.footerButtons.append(button)

            button.snp.makeConstraints({ (make) in
                make.width.equalTo(self.buttonView.snp.width).multipliedBy(0.5)
                make.top.bottom.equalTo(self.buttonView)
                if index == 0 {
                    make.leading.equalTo(self.buttonView.snp.leading)
                } else {
                    make.trailing.equalTo(self.buttonView.snp.trailing)
                }
            })
        }

        viewHeight = height + Config.cellHeight + 10.0
    }

    @objc fileprivate func actionFooter(_ btn: UIButton) {

        guard btn.tag < self.footerActions.count else {
            self.hide()
            return
        }

        let footAction = self.footerActions[btn.tag]

        if footAction.status == .disabled {
            return
        }

        self.hide()

        footAction.action?(btn.tag)
    }

    override open func showAnimation(completion closure: ((XXPopupView, Bool) -> Void)?) {

        if self.superview == nil {
            self.targetView!.xx_dimBackgroundView.addSubview(self)
        }

        self.snp.remakeConstraints ({ (make) in
            make.centerX.equalTo(self.targetView!)
            make.width.equalTo(XXDropTableViewConfig.width)
            make.top.equalTo(self.targetView!.snp.top)
        })

        self.layoutIfNeeded()
        self.transform = CGAffineTransform(translationX: 0, y: -self.viewHeight)

        delegate?.willShow(self)
        UIView.animate(
            withDuration: self.duration,
            delay: 0.0,
            options: [
                UIViewAnimationOptions.curveEaseOut,
                UIViewAnimationOptions.beginFromCurrentState
            ],
            animations: {
                self.transform = CGAffineTransform.identity
        },
            completion: { (finished: Bool) in
                if let completionClosure = closure {
                    completionClosure(self, finished)
                }
                self.isShow = true
        })
    }

    override open func hideAnimation(completion closure: ((XXPopupView, Bool) -> Void)?) {

        delegate?.willHide(self)
        UIView.animate(
            withDuration: self.duration,
            delay: 0.0,
            options: [
                UIViewAnimationOptions.curveEaseIn,
                UIViewAnimationOptions.beginFromCurrentState
            ],
            animations: {
                self.transform = CGAffineTransform(translationX: 0, y: -self.viewHeight)
        },
            completion: { (finished: Bool) in
                if finished {
                    self.isShow = false
                    self.removeFromSuperview()
                }
                if let completionClosure = closure {
                    completionClosure(self, finished)
                }
        })

    }
}

extension XXDropTableView: UITableViewDelegate, UITableViewDataSource {

    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellAction.count
    }

    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return XXDropTableViewConfig.cellHeight
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "XXDropTableViewCell", for: indexPath) as! XXDropTableViewCell

        let item = self.cellAction[indexPath.row]
        cell.titleLabel.text = item.title

        return cell
    }

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let item = self.cellAction[indexPath.row]

        if let action = item.action {
            action(indexPath.row)
        }

        self.hide()
    }
}

open class XXDropTableViewCell: UITableViewCell {

    public let titleLabel: UILabel = UILabel()

    public let bottomLine: UIView = UIView()

    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    open func setup() {

        typealias Config = XXDropTableViewConfig

        selectionStyle = .none
        contentView.backgroundColor = SSColor.c101.color

        contentView.addSubview(titleLabel)
        contentView.addSubview(bottomLine)

        titleLabel.font = SSFont.t04.font
        titleLabel.textColor = SSColor.c302.color

        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.trailing.lessThanOrEqualTo(self.contentView.snp.trailing).offset(-30)
        }

        bottomLine.backgroundColor = SSColor.c101.color
        bottomLine.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self.contentView)
            make.height.equalTo(0.5)
        }
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            titleLabel.textColor = SSColor.c306.color
        } else {
            titleLabel.textColor = SSColor.c302.color
        }
    }
}

public struct XXDropTableViewConfig {

    static var maxNumberOfItems = 5
    static var width: CGFloat = UIScreen.main.bounds.width
    static var cellHeight: CGFloat = 44.0
    static var innerPadding: CGFloat = 10.0
    static var footViewPadding: CGFloat = 8.0
    static var splitWidth: CGFloat = 1.0 / UIScreen.main.scale
    static var gapWidth: CGFloat = 8
    static var footViewGap: CGFloat = 2.0

    static var cellTitleAlignment: NSTextAlignment = .center
    static var cellTitleFont: UIFont = UIFont.systemFont(ofSize: 14)
    static var footerTitleFont: UIFont = UIFont.systemFont(ofSize: 14)

    static var cellTitleNormalColor: UIColor = UIColor.xx_hexColor(0x333333FF)
    static var cellTitleSelectedColor: UIColor = UIColor.xx_hexColor(0x333333FF)
    static var cellSplitColor: UIColor = UIColor.xx_hexColor(0xCCCCCCFF)
    static var cellBackgroundNormalColor: UIColor = UIColor.xx_hexColor(0xCCCCCCFF)
    static var cellBackgroundHighlightedColor: UIColor = UIColor.xx_hexColor(0xCCCCCCFF)

    static var footerTitleColor: UIColor = UIColor.xx_hexColor(0x333333FF)
    static var footerBackgroundNormalColor: UIColor = UIColor.xx_hexColor(0xFFFFFFFF)
    static var footerBackgroundHighlightedColor: UIColor = UIColor.xx_hexColor(0xCCCCCCFF)
    static var gapColor: UIColor = UIColor.xx_hexColor(0xEEEEEEFF)
    static var splitColor: UIColor = UIColor.xx_hexColor(0xCCCCCCFF)

}
