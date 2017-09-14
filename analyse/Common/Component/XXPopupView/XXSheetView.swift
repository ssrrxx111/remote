//
//  XXSheetView.swift
//
//
//  Created by adad184 on 7/12/16.
//  Copyright © 2016 adad184. All rights reserved.
//

import SnapKit

open class XXSheetView: XXPopupView {

    fileprivate(set) var actionItems: [XXActionItem] = [XXActionItem]()
    fileprivate(set) var title: String = ""

    fileprivate let titleLabel = UILabel()
    fileprivate let cancelButton = UIButton()
    fileprivate let buttonView = UIView()
    fileprivate var buttons = [UIButton]()

    fileprivate override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    convenience public init(title: String, actionItems: [XXActionItem]) {
        self.init(frame: CGRect.zero)

        self.title = title
        self.actionItems = actionItems

        self.buildUI()
    }
    convenience public init(actionItems: [XXActionItem]) {
        self.init(frame: CGRect.zero)

        self.actionItems = actionItems

        self.buildUI()
    }

    fileprivate func buildUI() {

        assert(self.actionItems.count > 0, "Need at least 1 action")

        self.targetView = XXSheetWindow

        typealias Config = XXSheetViewConfig

        self.type = .sheet

        self.snp.makeConstraints { (make) in
            make.width.equalTo(Config.width)
        }
        self.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        self.setContentHuggingPriority(UILayoutPriorityFittingSizeLevel, for: .horizontal)

        self.addSubview(self.buttonView)
        self.buttonView.clipsToBounds = true
        self.buttonView.layer.cornerRadius = 8.0
        self.buttonView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: Config.innerPadding, bottom: 0, right: Config.innerPadding))
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
                btn.setTitleColor(Config.buttonTitleNormalColor, for: .normal)
                btn.setTitleColor(Config.buttonTitleHighlightedColor, for: .highlighted)
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
                make.leading.trailing.equalTo(self.buttonView).inset(UIEdgeInsets(top: 0, left: -Config.splitWidth, bottom: 0, right: -Config.splitWidth))

                if i == 0 {
                    make.top.equalTo(self.buttonView.snp.top)
                } else {
                    make.top.equalTo(self.buttons[i - 1].snp.bottom).offset(-Config.splitWidth)
                }

                if i == self.actionItems.count - 1 {
                    make.bottom.equalTo(self.buttonView.snp.bottom).offset(Config.splitWidth)
                }
            })
        }
        
        ({ (view: UIButton) in
            view.addTarget(self, action: #selector(actionCancel), for: .touchUpInside)
            view.setBackgroundImage(UIImage.xx_image(Config.buttonBackgroundNormalColor), for: .normal)
            view.setBackgroundImage(UIImage.xx_image(Config.buttonBackgroundHighlightedColor), for: .highlighted)
            view.setTitleColor(Config.cancelTitleNormalColor, for: .normal)
            view.setTitleColor(Config.cancelTitleHighlightedColor, for: .highlighted)
            view.setTitle(Config.defaultTextCancel, for: .normal)
            view.titleLabel?.font = Config.buttonFont
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 8.0
            
            self.addSubview(view)
            }(self.cancelButton))

        self.cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.buttonView.snp.bottom).offset(Config.innerPadding)
            make.leading.bottom.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: Config.innerPadding, bottom: Config.innerPadding, right: Config.innerPadding))
            make.height.equalTo(Config.buttonHeight)
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
    
    @objc fileprivate func actionCancel() {
        self.hide()
    }
}

public struct XXSheetViewConfig {

	public static var width: CGFloat = UIScreen.main.bounds.width
	public static var buttonHeight: CGFloat = 49.0
	public static var innerPadding: CGFloat = 10.0
	public static var splitWidth: CGFloat = 1.0 / UIScreen.main.scale
	public static var gapWidth: CGFloat = 8

	public static var titleFont: UIFont = SSFont.t05.font
	public static var buttonFont: UIFont = SSFont.t04.font

	public static var titleColor: UIColor = UIColor.xx_hexColor(0x333333FF)
	public static var splitColor: UIColor = UIColor.xx_hexColor(0xCCCCCCFF)
	public static var gapColor: UIColor = UIColor.xx_hexColor(0xEEEEEEFF)

	public static var buttonTitleNormalColor: UIColor = SSColor.c301.color
	public static var buttonTitleHighlightedColor: UIColor = SSColor.c303.color
	public static var buttonTitleDisabledColor: UIColor = SSColor.c306.color

	public static var buttonBackgroundNormalColor: UIColor = UIColor.xx_hexColor(0xFFFFFFFF)
	public static var buttonBackgroundHighlightedColor: UIColor = UIColor.xx_hexColor(0xF9F9F9FF)
	public static var buttonBackgroundDisabledColor: UIColor = UIColor.xx_hexColor(0xFFFFFFFF)

	public static var cancelTitleNormalColor: UIColor = SSColor.c301.color
	public static var cancelTitleHighlightedColor: UIColor = SSColor.c303.color

	public static var defaultTextCancel: String = i18n("common.cancel")
}
