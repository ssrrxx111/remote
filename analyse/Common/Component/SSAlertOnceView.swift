//
//  SSAlertOnceView.swift
//  NewUstock
//
//  Created by srx on 16/12/7.
//  Copyright © 2016年 ustock. All rights reserved.
//

import SnapKit

open class SSAlertOnceView: XXPopupView {
    fileprivate static var isShowing = false

    fileprivate(set) var actionItems: [XXActionItem] = [XXActionItem]()
    fileprivate(set) var title: String = ""
    fileprivate(set) var detail: String = ""

    fileprivate let titleLabel = UILabel()
    fileprivate let detailLabel = UILabel()
    fileprivate let buttonView = UIView()
    fileprivate var buttons = [UIButton]()

    fileprivate override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public convenience init(confirmTitle: String, detail: String, action: (() -> Void)? = { () in }) {
        self.init(frame: CGRect.zero)

        self.actionItems = [XXActionItem(title: XXAlertViewConfig.defaultTextConfirm, action: { _ in
            if let _ = action {
                action!()
            }

        })]
        self.title = confirmTitle
        self.detail = detail

        self.buildUI()
    }

    public convenience init(okCancelTitle: String, detail: String, okActionTitle: String? = nil, action: @escaping () -> Void) {
        self.init(frame: CGRect.zero)

        let cancelAction = XXActionItem(
            title: XXAlertViewConfig.defaultTextCancel,
            action: nil
        )
        let okTitle = okActionTitle ?? XXAlertViewConfig.defaultTextConfirm
        let okAction = XXActionItem(
            title: okTitle,
            action: { _ in
                action()
        },
            status: .highlighted)

        self.actionItems = [cancelAction, okAction]
        self.title = okCancelTitle
        self.detail = detail

        self.buildUI()
    }

    public convenience init(title: String, detail: String, actionItems: [XXActionItem]) {
        self.init(frame: CGRect.zero)

        self.actionItems = actionItems
        self.title = title
        self.detail = detail

        self.buildUI()
    }

    fileprivate func buildUI() {

        assert(self.actionItems.count > 0, "Need at least 1 action")

        self.targetView = XXAlertWindow

        typealias Config = XXAlertViewConfig

        self.type = .alert

        self.clipsToBounds = true
        self.layer.cornerRadius = Config.cornerRadius
        self.backgroundColor = Config.backgroundColor
        //        self.layer.borderWidth = Config.splitWidth
        //        self.layer.borderColor = Config.splitColor.CGColor

        self.snp.makeConstraints { (make) in
            make.width.equalTo(Config.width)
        }
        self.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        self.setContentHuggingPriority(UILayoutPriorityFittingSizeLevel, for: .horizontal)

        var lastAttribute = self.snp.top

        if self.title.characters.count > 0 {
            ({ (view: UILabel) in
                view.textColor = Config.titleColor
                view.text = self.title
                view.font = Config.titleFont
                view.numberOfLines = 0
                view.backgroundColor = Config.backgroundColor
                view.textAlignment = .center

                self.addSubview(view)
                }(self.titleLabel))

            self.titleLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(lastAttribute).offset(Config.innerPadding)
                make.leading.trailing.equalTo(self).inset(UIEdgeInsets(top: 0, left: Config.innerMargin, bottom: 0, right: Config.innerMargin))
            })

            lastAttribute = self.titleLabel.snp.bottom
        }

        if self.detail.characters.count > 0 {
            ({ (view: UILabel) in
                view.textColor = Config.detailColor
                view.text = self.detail
                view.font = Config.detailFont
                view.numberOfLines = 0
                view.backgroundColor = self.backgroundColor
                view.textAlignment = .center

                self.addSubview(view)
                }(self.detailLabel))

            self.detailLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(lastAttribute).offset(Config.innerPadding)
                make.width.equalTo(Config.width - 2 * Config.innerMargin)
                make.leading.trailing.equalTo(self).inset(UIEdgeInsets(top: 0, left: Config.innerMargin, bottom: 0, right: Config.innerMargin))
            })

            lastAttribute = self.detailLabel.snp.bottom
        }

        ({ (view: UIView) in
            view.backgroundColor = self.backgroundColor
            view.backgroundColor = UIColor.blue

            self.addSubview(view)
            }(self.buttonView))

        self.buttonView.snp.makeConstraints { (make) in
            make.top.equalTo(lastAttribute).offset(Config.innerMargin)
            make.leading.bottom.trailing.equalTo(self)
        }

        for i in 0..<self.actionItems.count {
            let action = self.actionItems[i]

            let button: UIButton = {
                let btn = UIButton()
                btn.addTarget(self, action: #selector(actionTap(_:)), for: .touchUpInside)
                btn.tag = i
                btn.setBackgroundImage(UIImage.xx_image(Config.buttonBackgroundNormalColor), for: .normal)
                btn.setBackgroundImage(UIImage.xx_image(Config.buttonBackgroundHighlightedColor), for: .highlighted)
                btn.setBackgroundImage(UIImage.xx_image(Config.buttonBackgroundDisabledColor), for: .disabled)
                btn.setTitleColor(action.status == .highlighted ? Config.buttonTitleHighlightedColor : Config.buttonTitleNormalColor, for: .normal)
                btn.setTitleColor(Config.buttonTitleDisabledColor, for: .disabled)
                btn.setTitle(action.title, for: .normal)
                btn.layer.borderWidth = Config.splitWidth
                btn.layer.borderColor = Config.splitColor.cgColor
                btn.titleLabel?.font = Config.buttonFont

                btn.isEnabled = action.status != .disabled

                self.buttonView.addSubview(btn)
                return btn
            }()
            self.buttons.append(button)

            button.snp.makeConstraints({ (make) in
                make.height.equalTo(Config.buttonHeight)

                if self.actionItems.count < 3 { // horizontal
                    make.top.bottom.equalTo(self.buttonView)

                    if i == 0 {
                        make.leading.equalTo(self.buttonView.snp.leading).offset(-Config.splitWidth)
                    } else {
                        make.leading.equalTo(self.buttons[i - 1].snp.trailing).offset(-Config.splitWidth)
                        make.width.equalTo(self.buttons[i - 1])
                    }

                    if i == self.actionItems.count - 1 {
                        make.trailing.equalTo(self.buttonView.snp.trailing).offset(Config.splitWidth)
                    }

                } else { // vertical
                    make.leading.trailing.equalTo(self.buttonView).inset(UIEdgeInsets(top: 0, left: -Config.splitWidth, bottom: 0, right: -Config.splitWidth))

                    if i == 0 {
                        make.top.equalTo(self.buttonView.snp.top)
                    } else {
                        make.top.equalTo(self.buttons[i - 1].snp.bottom).offset(-Config.splitWidth)
                    }

                    if i == self.actionItems.count - 1 {
                        make.bottom.equalTo(self.buttonView.snp.bottom).offset(Config.splitWidth)
                    }
                }
            })

        }
    }

    @objc fileprivate func actionTap(_ btn: UIButton) {
        let action = self.actionItems[btn.tag]

        if action.status == .disabled {
            return
        }

        self.hide()

        if action.action != nil {
            action.action!(btn.tag)
        }
    }

    open override func show(completion closure: ((XXPopupView, Bool) -> Void)? = nil) {
        if !SSAlertOnceView.isShowing {
            super.show(completion: closure)
        }
    }

    open override func hide(completion closure: ((XXPopupView, Bool) -> Void)? = nil) {
        super.hide(completion: closure)
    }

    override open func hideAnimation(completion closure: ((XXPopupView, Bool) -> Void)? = nil) {
        super.hideAnimation(completion: closure)
        SSAlertOnceView.isShowing = false

    }

    override open func showAnimation(completion closure: ((XXPopupView, Bool) -> Void)? = nil) {
        super.showAnimation(completion: closure)
        SSAlertOnceView.isShowing = true
    }
}
