//
//  XXPickerView.swift
//  demoMQTT
//
//  Created by adad184 on 7/13/16.
//  Copyright © 2016 adad184. All rights reserved.
//

import Foundation
import SnapKit

open class XXPickerView: XXPopupView {

    fileprivate(set) var actionItems: [XXActionItem] = [XXActionItem]()
    fileprivate(set) var title: String = ""

    fileprivate let baseView  = UIView()
    fileprivate let titleLabel = UILabel()
    fileprivate let pickerView = UIPickerView()
    fileprivate let datePickerView = UIDatePicker()
    fileprivate var cancelButton = UIButton()
    fileprivate var confirmButton = UIButton()
    fileprivate let spacingLine = UIView()
    fileprivate var dateHandler: ((Date) -> Void)?
    public typealias Config = XXPickerViewConfig

    public var selectedIndex: Int = 0 {

        didSet {
            self.pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
        }
    }

    fileprivate override init(frame: CGRect = CGRect.zero) {

        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }

    public convenience init(actionItems: [XXActionItem]) {
        self.init(title: "", actionItems: actionItems)
    }

    public convenience init(title: String, actionItems: [XXActionItem]) {

        self.init(frame: CGRect.zero)

        self.title = title
        self.actionItems = actionItems

        self.buildUI()
    }

    public convenience init(title: String, dateHandler: @escaping (Date) -> Void, dateMaker: ((UIDatePicker) -> Void)? = nil) {

        self.init(frame: CGRect.zero)

        self.title = title
        self.dateHandler = dateHandler

        if let maker = dateMaker {
            maker(self.datePickerView)
        }

        self.buildUI()
    }

    fileprivate func buildUI() {

        assert((!self.actionItems.isEmpty) || (self.dateHandler != nil))

        self.targetView = XXPickerWindow

        typealias Config = XXPickerViewConfig

        self.type = .sheet

        self.backgroundColor = .clear

        self.snp.makeConstraints { (make) in
            make.width.equalTo(Config.width)
        }
        self.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        self.setContentHuggingPriority(UILayoutPriorityFittingSizeLevel, for: .horizontal)
        
        self.baseView.ss.customize { (view) in
            view.ss.themeHandler({ (view) in
                view.backgroundColor = SSColor.c102.color
            })
            self.addSubview(view)
        }
        
        self.confirmButton = UIUtils.button(target: self, action: #selector(actionConfirm), image: nil, title: "确定", color: SSColor.c301, inset: nil)
        self.baseView.addSubview(self.confirmButton)
        
        self.cancelButton = UIUtils.button(target: self, action: #selector(actionCancel), image: nil, title: "取消", color: SSColor.c301, inset: nil)
        self.baseView.addSubview(self.cancelButton)
        
        self.titleLabel.ss.customize { (label) in
            label.ss.themeHandler({ (label) in
                label.textColor = SSColor.c301.color
            })
            label.font = Config.titleFont
            label.numberOfLines = 0
            label.backgroundColor = Config.backgroundColor
            label.textAlignment = .center
            self.baseView.addSubview(label)
        }
        
        self.spacingLine.ss.customize { (view) in
            view.ss.themeHandler({ (view) in
                view.backgroundColor = Config.splitColor
            })
            self.baseView.addSubview(view)
        }
        
        self.spacingLine.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.baseView)
            make.height.equalTo(UIUtils.seperatorWidth)
            make.top.equalTo(self.cancelButton.snp.bottom)
        }
        
        self.cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.baseView)
            make.leading.equalToSuperview().offset(18)
            make.height.equalTo(40)
        }
        
        self.confirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.baseView)
            make.trailing.equalToSuperview().offset(-18)
            make.height.equalTo(40)
        }
        
        self.baseView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.top.equalTo(self)
            make.height.equalTo(216 + 40)
        }
        
    
        if !self.title.characters.isEmpty {
            self.titleLabel.snp.makeConstraints({ (make) in
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
                make.width.equalTo(UIUtils.screenWidth * 0.5)
            })
        }

        if self.dateHandler == nil {
            
            self.pickerView.ss.customize({ (view) in
                view.backgroundColor = Config.backgroundColor
                view.delegate = self
                view.dataSource = self
                view.tintColor = Config.splitColor
                self.baseView.addSubview(view)
            })
        } else {
            self.datePickerView.ss.customize({ (view) in
                view.backgroundColor = Config.backgroundColor
                view.tintColor = Config.splitColor
                view.setValue(SSColor.c301.color, forKey: "textColor")
                view.perform(Selector(("_setHighlightColor:")), with:UIColor.white)
                view.perform(Selector(("_setHighlightsToday:")), with:false)
                
                self.baseView.addSubview(view)
            })
        }

        if self.dateHandler == nil {
            self.pickerView.snp.makeConstraints { (make) in
                make.top.equalTo(self.spacingLine.snp.bottom)
                make.leading.trailing.equalTo(self)
                make.height.equalTo(216)
            }
        } else {
            self.datePickerView.snp.makeConstraints { (make) in

                make.top.equalTo(self.spacingLine.snp.bottom)
                make.leading.trailing.equalTo(self)
                make.height.equalTo(216)
            }
        }
    }

    fileprivate func actionTap(_ btn: UIButton) {

        let action = self.actionItems[btn.tag]

        if action.status == .disabled {
            return
        }

        self.hide()

        if action.action != nil {
            action.action!(btn.tag)
        }
    }

    @objc fileprivate func actionConfirm() {

        if let handler = self.dateHandler {

            handler(self.datePickerView.date)
            self.hide()
            return
        }

        let selectedIndex = self.pickerView.selectedRow(inComponent: 0)

        let item = self.actionItems[selectedIndex]

        self.hide()

        if let action = item.action {
            action(selectedIndex)
        }
    }

    @objc fileprivate func actionCancel() {
        self.hide()
    }
}

extension XXPickerView: UIPickerViewDelegate, UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {

        for view in pickerView.subviews {
            if view.frame.height < 1.0 {
                view.backgroundColor = XXPickerViewConfig.splitColor
            }
        }

        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return XXPickerViewConfig.buttonHeight
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.actionItems.count
    }

    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        typealias Config = XXPickerViewConfig

        var label = view as? UILabel

        if label == nil {
            label = UILabel()
            label?.textAlignment = .center
            label?.font = Config.itemTitleFont
            label?.textColor = SSColor.c301.color
        }

        let item = self.actionItems[row]
        label?.text = item.title

        return label!
    }
}

public struct XXPickerViewConfig {

    public static var width: CGFloat = UIScreen.main.bounds.width
    public static var buttonHeight: CGFloat = 48.0
    public static var innerPadding: CGFloat = 10.0
    public static var splitWidth: CGFloat = 2.0 / UIScreen.main.scale
    public static var gapWidth: CGFloat = 8
    
    public static var titleFont: UIFont = SSFont.t05.bold
    public static var itemTitleFont: UIFont = SSFont.t06.bold
    public static var buttonFont: UIFont = SSFont.t05.bold
    
    public static var titleColor: UIColor = SSColor.c301.color
    public static var backgroundColor: UIColor = .clear
    public static var baseViewBackgroundColor: UIColor = SSColor.c102.color
    public static var confirmButtonColor: UIColor = SSColor.c401.color
    public static var cancelButtonColor: UIColor = SSColor.c302.color
    public static var splitColor: UIColor = SSColor.c101.color

    public static var defaultTextConfirm: String = i18n("FinanceCalendar.typeSelect.common.done")
    public static var defaultTextCancel: String = i18n("FinanceCalendar.typeSelect.common.cancel")
}
