//
//  XXAlertView.swift
//
//
//  Created by adad184 on 7/12/16.
//  Copyright © 2016 adad184. All rights reserved.
//

import SnapKit

open class XXAlertView: XXPopupView {

    fileprivate(set) var actionItems: [XXActionItem] = [XXActionItem]()
    fileprivate(set) var title: String = ""
    fileprivate(set) var detail: String = ""

    fileprivate let titleLabel = UILabel()
    fileprivate let detailLabel = UILabel()
    fileprivate let buttonView = UIView()
    fileprivate var buttons = [UIButton]()

    typealias Config = XXAlertViewConfig

    fileprivate override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    convenience public init(confirmTitle: String, detail: String, action: (() -> Void)? = { () in }) {
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

    convenience public init(okCancelTitle: String, detail: String, okActionTitle: String? = nil, action: @escaping () -> Void) {
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

    convenience public init(title: String, detail: String, actionItems: [XXActionItem]) {
        self.init(frame: CGRect.zero)

        self.actionItems = actionItems
        self.title = title
        self.detail = detail

        self.buildUI()
    }

    fileprivate func buildUI() {

        assert(self.actionItems.count > 0, "Need at least 1 action")

        self.targetView = XXAlertWindow

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
                make.width.equalTo(Config.width - 2*Config.innerMargin)
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

                    if i == self.actionItems.count
                        - 1 {
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
    
    open override func showAnimation(completion closure: ((XXPopupView, Bool) -> Void)?) {
        super.showAnimation(completion: closure)
        
        //记录xxAlertView弹出状态
        stackDepthRecordOfXXAlertView.show()
        
        self.snp.remakeConstraints({ (make) in
            let y = self.withKeyboard ? (-216 / 2 ) : 0
            make.centerY.equalTo(self.targetView!).offset(y)
            make.centerX.equalTo(self.targetView!)
            make.width.equalTo(Config.width)
        })
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}

public struct XXAlertViewConfig {

    public static var width: CGFloat = 290
    public static var buttonHeight: CGFloat = 45.0
    public static var innerMargin: CGFloat = 25.0
    public static var innerPadding: CGFloat = 17.0
    public static var cornerRadius: CGFloat = 8.0
    public static var splitWidth: CGFloat = 1.0 / UIScreen.main.scale

    public static var titleFont: UIFont = SSFont.t04.bold // UIFont.boldSystemFont(ofSize: 18)
    public static var detailFont: UIFont = SSFont.t05.bold // UIFont.boldSystemFont(ofSize: 14)
    public static var buttonFont: UIFont = SSFont.t04.bold // UIFont.boldSystemFont(ofSize: 17)
    public static var cancelFont: UIFont = SSFont.t04.font

    public static var backgroundColor: UIColor = UIColor.xx_hexColor(0xFFFFFFFF)
    public static var titleColor: UIColor = SSColor.c301.color // UIColor.xx_hexColor(0x333333FF)
    public static var detailColor: UIColor = SSColor.c301.color //UIColor.xx_hexColor(0x333333FF)
    public static var splitColor: UIColor = UIColor.xx_hexColor(0xCCCCCCFF)

    public static var buttonTitleNormalColor: UIColor = SSColor.c301.color // UIColor.xx_hexColor(0x000000FF)
    public static var buttonTitleHighlightedColor: UIColor = SSColor.c302.color // UIColor.xx_hexColor(0x0000FFFF)
    public static var buttonTitleDisabledColor: UIColor = SSColor.c302.color // UIColor.xx_hexColor(0x999999FF)

    public static var buttonBackgroundNormalColor: UIColor = UIColor.xx_hexColor(0xFFFFFFFF)
    public static var buttonBackgroundHighlightedColor: UIColor = SSColor.debug.color
    public static var buttonBackgroundDisabledColor: UIColor = UIColor.xx_hexColor(0xAAAAAAFF)

    public static var defaultTextOK: String = i18n("common.ok")
    public static var defaultTextCancel: String = i18n("common.cancel")
    public static var defaultTextConfirm: String = i18n("common.confirm")
}
