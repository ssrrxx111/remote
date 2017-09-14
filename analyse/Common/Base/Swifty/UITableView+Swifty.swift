//
//  UITableView+Swifty.swift
//  NewUstock
//
//  Created by adad184 on 8/22/16.
//  Copyright © 2016 ustock. All rights reserved.
//

import Foundation

extension SSSwifty where Base: UITableView {

    public func registerCell<T: UITableViewCell>(_: T.Type) {
        self.base.register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }

    public func dequeueCell<T: UITableViewCell>(_ indexPath: IndexPath) -> T {
        return self.base.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }

    public func registerView<T: UIView>(_: T.Type) {
        self.base.register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: T.self))
    }

    public func dequeueView<T: UIView>() -> T {
        return self.base.dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as! T
    }

    public func reloadRow(at indexPath: IndexPath, with: UITableViewRowAnimation) {
        self.base.reloadRows(at: [indexPath], with: with)
    }

    public func reloadData(_ completion: @escaping (_ complete: Bool ) -> Void) {
        UIView.animate(
            withDuration: 0,
            animations: {
                self.base.reloadData()
        },
            completion: { complete in
                completion(complete)
        })
    }
}
