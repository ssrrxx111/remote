//
//  XXSheetAddAlertView.swift
//  Stocks-ios
//
//  Created by JunrenHuang on 4/3/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import SnapKit

open class XXSheetAddAlertView: XXPopupView {

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

    convenience init(title: String, actionItems: [XXActionItem]) {
        self.init(frame: CGRect.zero)

        self.title = title
        self.actionItems = actionItems

        self.buildUI()
    }
    convenience init(actionItems: [XXActionItem]) {
        self.init(frame: CGRect.zero)

        self.actionItems = actionItems

        self.buildUI()
    }

    fileprivate func buildUI() {

        assert(!self.actionItems.isEmpty, "Need at least 1 action")

        self.targetView = XXSheetWindow

        typealias Config = XXSheetViewConfig

        self.type = .sheet

        self.backgroundColor = UIColor.init(white: 1, alpha: 0.95)

        self.snp.makeConstraints { (make) in
            make.width.equalTo(Config.width)
        }
        self.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        self.setContentHuggingPriority(UILayoutPriorityFittingSizeLevel, for: .horizontal)

        self.addSubview(self.buttonView)

        let count = self.actionItems.count

        let rowHeight: CGFloat = 60

        self.buttonView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.leading.trailing.equalTo(self)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(rowHeight * CGFloat(count)).priority(999)
        }

        for i in 0..<count {
            let action = self.actionItems[i]

            let container = UIView()
            buttonView.addSubview(container)

            let row = i

            container.snp.makeConstraints({ (make) in
                make.top.equalTo(buttonView).offset(CGFloat(row) * rowHeight)
                make.leading.trailing.equalTo(buttonView)
                make.height.equalTo(rowHeight)
            })

            let image = UIImageView()
            image.image = action.image
            container.addSubview(image)
            
            image.snp.makeConstraints({ (make) in
                make.leading.equalToSuperview().offset(8)
                make.width.height.equalTo(20).priority(999)
                make.centerY.equalTo(container.snp.centerY)
            })

            let label = UILabel()
            label.text = action.title
            label.textColor = SSColor.c301.color
            label.font = SSFont.t05.bold
            label.textAlignment = .left
            container.addSubview(label)
            
            label.snp.makeConstraints({ (make) in
                make.leading.equalTo(image.snp.trailing).offset(28)
                make.trailing.equalTo(container.snp.trailing)
                make.top.bottom.equalToSuperview()
            })
            
            let button = UIButton(type: .custom)
            button.setTitle("", for: .normal)
            button.addTarget(self, action: #selector(actionTap(_:)), for: .touchUpInside)
            button.tag = i
            container.addSubview(button)

            button.snp.makeConstraints({ (make) in
                make.top.leading.trailing.bottom.equalToSuperview()
            })
            
            let line = UIView()
            line.backgroundColor = SSColor.c403.color
            container.addSubview(line)
            
            line.snp.makeConstraints({ (make) in
                make.leading.trailing.bottom.equalToSuperview()
                make.height.equalTo(UIUtils.seperatorWidth)
            })

        }

        ({ (view: UIButton) in
            view.addTarget(self, action: #selector(actionCancel), for: .touchUpInside)
            view.setTitleColor(SSColor.c401.color, for: .normal)
            view.setTitle(i18n("common.cancel"), for: .normal)
            view.titleLabel?.font = SSFont.t05.bold
            self.addSubview(view)
            }(self.cancelButton))
        self.cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(buttonView.snp.bottom)
            make.leading.bottom.trailing.equalTo(self)
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
