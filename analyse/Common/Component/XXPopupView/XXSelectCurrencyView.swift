//
//  XXSelectCurrencyView.swift
//  Stocks-ios
//
//  Created by JunrenHuang on 3/3/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit
import SnapKit

public class XXSelectCurrencyView: XXPopupView {

    fileprivate lazy var titleLabel: UILabel = UILabel()
    fileprivate lazy var hSeparatorLine: UIView = UIView()
    fileprivate lazy var hSeparatorBottomLine: UIView = UIView()
    fileprivate lazy var vSeparatorLine: UIView = UIView()
    fileprivate lazy var tableView: SSBaseTableView  = SSBaseTableView()

    fileprivate lazy var cancelButton: UIButton = UIButton()
    fileprivate lazy var doneButton: UIButton = UIButton()

    fileprivate let cellHeight: CGFloat = 44.0

    fileprivate var currencies: [String] = [
        "USD",
        "INR",
        "EUR",
        "GBP",
        "HKD",
        "AUD",
        "CAD",
        "CNY",
        "JPY",
        "CHF",
        "AED",
        "ARS",
        "BRL",
        "DKK",
        "IDR",
        "ILS",
        "ISK",
        "KHR",
        "KRW",
        "MXN",
        "MYR",
        "PHP",
        "RUB",
        "SEK",
        "SGD",
        "THB",
        "TRY",
        "TWD",
        "VND",
        "ZAR"
    ]
    fileprivate var selectedCurrency: String

    public typealias SelectHandler = (_ currency: String) -> Void
    fileprivate var selectHandler: SelectHandler

    public init?(_ selected: String, handler: @escaping SelectHandler) {

        guard currencies.contains(selected) else {
            return nil
        }

        if let index = currencies.index(of: selected) {
            let element = currencies.remove(at: index)
            currencies.insert(element, at: 0)
        }

        self.selectedCurrency = selected
        self.selectHandler = handler
        super.init(frame: CGRect.zero)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()

        addSubview(titleLabel)
        titleLabel.text = i18n("portfolio.changeCurrency")
        titleLabel.textColor = SSColor.c301.color
        titleLabel.font = SSFont.t04.font
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalTo(self)
            make.height.equalTo(43.5)
        }

        addSubview(hSeparatorLine)
        hSeparatorLine.backgroundColor = SSColor.c101.color
        hSeparatorLine.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(13)
            make.trailing.equalTo(self.snp.trailing).offset(-13)
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.height.equalTo(0.5)
        }

        addSubview(tableView)
        tableView.estimatedRowHeight = 0
        tableView.allowsMultipleSelection = true
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        tableView.register(XXSelectCurrencyViewCell.self, forCellReuseIdentifier: "XXSelectCurrencyViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        let height = CGFloat(min(self.currencies.count, 5)) * self.cellHeight
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(self.hSeparatorLine.snp.bottom)
            make.height.lessThanOrEqualTo(height)
        }

        addSubview(hSeparatorBottomLine)
        hSeparatorBottomLine.backgroundColor = SSColor.c101.color
        hSeparatorBottomLine.snp.makeConstraints { (make) in
            make.top.equalTo(self.tableView.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(0.5)
        }

        addSubview(vSeparatorLine)
        vSeparatorLine.backgroundColor = SSColor.c101.color
        let vSpacing: CGFloat = 10
        vSeparatorLine.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.hSeparatorBottomLine.snp.bottom).offset(vSpacing)
            make.bottom.equalTo(self.snp.bottom).offset(-vSpacing)
            make.height.equalTo(43.5 - vSpacing * 2.0)
            make.width.equalTo(0.5)
        }

        addSubview(cancelButton)
        cancelButton.setTitle(i18n("common.cancel"), for: .normal)
        cancelButton.setTitleColor(SSColor.c301.color, for: .normal)
        cancelButton.titleLabel?.font = SSFont.t04.font
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.setBackgroundImage(UIImage.xx_image(SSColor.c101.color), for: .normal)
        cancelButton.setBackgroundImage(UIImage.xx_image(SSColor.debug.color), for: .highlighted)
        cancelButton.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
        cancelButton.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.hSeparatorBottomLine.snp.bottom)
            make.bottom.equalTo(self.snp.bottom)
            make.width.equalTo(self.snp.width)
        }

        clipsToBounds = true
        backgroundColor = SSColor.c101.color
        layer.cornerRadius = 6.0
        isUserInteractionEnabled = true
        type = .alert
        targetView = XXAlertWindow

        setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        setContentHuggingPriority(UILayoutPriorityFittingSizeLevel, for: .horizontal)
    }

    @objc fileprivate func cancel(_ button: UIButton) {
        hide()
    }

    override public func showAnimation(completion closure: ((XXPopupView, Bool) -> Void)?) {

        let height = CGFloat(min(currencies.count, 5)) * self.cellHeight
        targetView!.xx_dimBackgroundView.addSubview(self)
        snp.remakeConstraints ({ (make) in
            make.center.equalTo(self.targetView!)
            make.width.equalTo(268)
            make.height.equalTo(height + 44.0 * 2)
        })

        if let index = currencies.index(of: selectedCurrency) {
            tableView.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .none)
        }

        self.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.0)
        self.alpha = 0.0

        UIView.animate(
            withDuration: self.duration,
            delay: 0.0,
            options: [
                UIViewAnimationOptions.curveEaseOut,
                UIViewAnimationOptions.beginFromCurrentState
            ],
            animations: {
                self.layer.transform = CATransform3DIdentity
                self.alpha = 1.0
        },
            completion: { (finished: Bool) in
                self.tableView.flashScrollIndicators()
                if let completionClosure = closure {
                    completionClosure(self, finished)
                }
        })
    }
}

extension XXSelectCurrencyView: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "XXSelectCurrencyViewCell", for: indexPath)
        if let _cell = cell as? XXSelectCurrencyViewCell {

            let currency = currencies[indexPath.row]

            _cell.titleLabel.text = StringUtils.getCurrencyDisplayName(currenySymbol: currency)

            _cell.subtitleLabel.text = currency

        }
        return cell
    }
}

fileprivate class XXSelectCurrencyViewCell: SSBaseTableViewCell {

    lazy var titleLabel = UILabel()
    lazy var subtitleLabel = UILabel()

    override func setup() {
        super.setup()

        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)

        titleLabel.font = SSFont.t04.font
        titleLabel.textColor = SSColor.c302.color
        titleLabel.clipsToBounds = true
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(13)
            make.trailing.lessThanOrEqualTo(subtitleLabel.snp.leading).offset(6)
            make.centerY.equalTo(contentView)
        }

        subtitleLabel.font = SSFont.t04.font
        subtitleLabel.textColor = SSColor.c302.color
        subtitleLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-13)
            make.centerY.equalTo(contentView)
        }
        subtitleLabel.setContentHuggingPriority(999, for: .vertical)
        subtitleLabel.setContentCompressionResistancePriority(999, for: .vertical)
    }

    fileprivate override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        let color = selected ? SSColor.c306.color : SSColor.c302.color
        titleLabel.textColor = color
        subtitleLabel.textColor = color

        guard
            let tableView = self.superview?.superview as? UITableView,
            let alertView = tableView.superview as? XXSelectCurrencyView,
            let indexPath = tableView.indexPath(for: self)
            else {
                return
        }

        let currencies = alertView.currencies

        if currencies.count > indexPath.row {
            alertView.hide()

            alertView.selectHandler(currencies[indexPath.row])
        }
        
    }
}
