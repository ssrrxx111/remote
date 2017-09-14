//
//  XXSheetTableView.swift
//  Stocks-ios
//
//  Created by adad184 on 12/06/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit

public enum XXSheetTableViewCellAlign {
    case center
    case separated
}

open class XXSheetTableView: XXPopupView {

    public var cellAction: [XXActionItem] = [XXActionItem]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    public var align: XXSheetTableViewCellAlign = .center
    public var tableView: UITableView = UITableView()
    public var cancelButton: UIButton = UIButton(type: .custom)

    public convenience init(cellAction: [XXActionItem], align: XXSheetTableViewCellAlign = .center) {
        self.init(frame: CGRect.zero)

        self.cellAction = cellAction

        self.buildUI()
    }

    open func buildUI() {

        assert(self.cellAction.count > 0, "Need at least 1 action")

        typealias Config = XXSheetTableViewConfig
        self.type = .sheet

        self.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        self.setContentHuggingPriority(UILayoutPriorityFittingSizeLevel, for: .horizontal)

        self.backgroundColor = Config.cellSplitColor

        ({ (view: UITableView) in
            view.delegate = self
            view.dataSource = self
            view.separatorStyle = .none
            view.register(XXSheetTableViewCell.self, forCellReuseIdentifier: "XXSheetTableViewCell")
            view.register(XXSheetTableViewSeparatedCell.self, forCellReuseIdentifier: "XXSheetTableViewSeparatedCell")
            view.isScrollEnabled = self.cellAction.count > Config.maxNumberOfItems
            view.backgroundColor = Config.cellBackgroundNormalColor

            self.addSubview(view)
            }(self.tableView))

        ({ (view: UIButton) in
            view.addTarget(self, action: #selector(actionCancel), for: .touchUpInside)
            view.setBackgroundImage(UIImage.xx_image(Config.cellBackgroundNormalColor), for: .normal)
            view.setBackgroundImage(UIImage.xx_image(Config.cellBackgroundHighlightedColor), for: .highlighted)
            view.setTitleColor(Config.cancelTitleNormalColor, for: .normal)
            view.setTitleColor(Config.cancelTitleHighlightedColor, for: .highlighted)
            view.setTitle(Config.defaultTextCancel, for: .normal)
            view.titleLabel?.font = Config.cancelFont

            self.addSubview(view)
            }(self.cancelButton))

        let height = min(CGFloat(Config.maxNumberOfItems) + 0.5, CGFloat(self.cellAction.count)) * Config.cellHeight
        self.tableView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(self)
            make.height.equalTo(height).priority(750)
        }

        self.cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.tableView.snp.bottom).offset(Config.innerPadding)
            make.leading.bottom.trailing.equalTo(self)
            make.height.equalTo(Config.buttonHeight)
        }
    }

    func actionCancel(_ btn: UIButton) {

        self.hide()
    }

}


extension XXSheetTableView: UITableViewDelegate, UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellAction.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return XXSheetTableViewConfig.cellHeight
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = self.align == .center
            ? tableView.dequeueReusableCell(withIdentifier: "XXSheetTableViewCell", for: indexPath) as! XXSheetTableViewCell
            : tableView.dequeueReusableCell(withIdentifier: "XXSheetTableViewSeparatedCell", for: indexPath) as! XXSheetTableViewSeparatedCell

        let item = self.cellAction[indexPath.row]
        cell.titleLabel.text = item.title
        cell.highlightView.backgroundColor = XXSheetTableViewConfig.cellBackgroundHighlightedColor

        switch item.status {
        case .selected:
            cell.titleLabel.textColor = XXSheetTableViewConfig.cellTitleHighlightedColor
            cell.selectedView.isHidden = false
        case .disabled:
            cell.titleLabel.textColor = XXSheetTableViewConfig.cellTitleDisabledColor
            cell.selectedView.isHidden = true
        case .normal:
            cell.titleLabel.textColor = XXSheetTableViewConfig.cellTitleNormalColor
            cell.selectedView.isHidden = true
        default:
            break
        }

        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let item = self.cellAction[indexPath.row]

        if let action = item.action {
            action(indexPath.row)
        }

        self.hide()
    }
}

class XXSheetTableViewCell: SSBaseTableViewCell {

    let titleLabel: UILabel = UILabel()
    let iconView: UIImageView = UIImageView()
    let selectedView: UIImageView = UIImageView()
    let split: UIView = UIView()

    override func setup() {
        super.setup()

        typealias Config = XXSheetTableViewConfig

        self.contentView.backgroundColor = Config.cellBackgroundNormalColor

        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.selectedView)
        self.contentView.addSubview(self.split)

        self.titleLabel.font = Config.cellTitleFont
        self.titleLabel.textColor = Config.cellTitleNormalColor
        self.titleLabel.textAlignment = .center

        self.selectedView.image = Config.cellHighlightedImage
        self.selectedView.tintColor = Config.cellTitleHighlightedColor
        self.selectedView.isHidden = true

        self.split.backgroundColor = Config.cellSplitColor

        self.titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50))
        }

        self.selectedView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-18)
        }

        self.btmLine.isHidden = false
    }
}

class XXSheetTableViewSeparatedCell: XXSheetTableViewCell {

    override func setup() {
        super.setup()

        self.titleLabel.textAlignment = .left
        self.titleLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.contentView.snp.leading).offset(8)
        }

        self.selectedView.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.titleLabel.snp.trailing).offset(8)
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-8)
        }
    }
}

public struct XXSheetTableViewConfig {

    public static var maxNumberOfItems: Int = 4
    public static var cellHeight: CGFloat = 50.0
    public static var buttonHeight: CGFloat = 45.0
    public static var innerPadding: CGFloat = 8.0
    public static var splitWidth: CGFloat = 1.0 / UIScreen.main.scale

    public static var cellTitleFont: UIFont = UIFont.systemFont(ofSize: 14)
    public static var cancelFont: UIFont = UIFont.systemFont(ofSize: 14)

    public static var cellHighlightedImage: UIImage? = nil

    public static var cellTitleNormalColor: UIColor = UIColor.xx_hexColor(0x333333FF)
    public static var cellTitleSelectedColor: UIColor = UIColor.xx_hexColor(0x333333FF)
    public static var cellTitleHighlightedColor: UIColor = UIColor.xx_hexColor(0x333333FF)
    public static var cellTitleDisabledColor: UIColor = UIColor.xx_hexColor(0x333333FF)
    public static var cellSplitColor: UIColor = UIColor.xx_hexColor(0xCCCCCCFF)
    public static var cellBackgroundNormalColor: UIColor = UIColor.xx_hexColor(0xCCCCCCFF)
    public static var cellBackgroundHighlightedColor: UIColor = UIColor.xx_hexColor(0xCCCCCCFF)

    public static var cancelTitleNormalColor: UIColor = UIColor.xx_hexColor(0x333333FF)
    public static var cancelTitleHighlightedColor: UIColor = UIColor.xx_hexColor(0x333333FF)

    public static var defaultTextCancel: String = i18n("common.cancel")
}
