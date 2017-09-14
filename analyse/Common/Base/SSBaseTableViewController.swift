//
//  SSBaseTableTableViewController.swift
//  Common
//
//  Created by JunrenHuang on 3/3/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit
import SnapKit

open class SSBaseTableViewController: SSBaseViewController {

    open func tableViewStyle() -> UITableViewStyle {
        return .plain
    }
    
    public lazy var tableView: SSBaseTableView = {
        return SSBaseTableView(frame: CGRect.zero, style: self.tableViewStyle())
    }()

    override open func viewDidLoad() {
        super.viewDidLoad()
    }

    override open func setup() {
        super.setup()

        self.tableView.ss.registerCell(UITableViewCell.self)
        self.tableView.ss.registerCell(SSBaseTableViewCell.self)
    }

    open override func buildUI() {
        super.buildUI()

        self.tableView.ss.customize { (view) in
            view.delegate = self
            view.dataSource = self
            view.estimatedRowHeight = 100
            view.rowHeight = UITableViewAutomaticDimension
            view.separatorStyle = .none
//            view.delaysContentTouches = false
            if view.tableHeaderView == nil {
                view.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 0.001))
            }
            if view.tableFooterView == nil {
                view.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 0.001))
            }
            view.ss.themeHandler { (view) in
                view.backgroundColor = SSColor.c101.color
            }
            
            self.contentView.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
}

extension SSBaseTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(); view.backgroundColor = .clear
        return view
    }

    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(); view.backgroundColor = .clear
        return view
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return tableView.ss.dequeueCell(indexPath) as UITableViewCell
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}

