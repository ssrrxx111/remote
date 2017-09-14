//
//  UICollectionView+Swifty.swift
//  NewUstock
//
//  Created by adad184 on 8/22/16.
//  Copyright © 2016 ustock. All rights reserved.
//

import Foundation

extension SSSwifty where Base: UICollectionView {

    public func registerCell<T: UICollectionViewCell>(_: T.Type) {
        self.base.register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
    }

    public func dequeueCell<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T {
        return self.base.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }

    public func registerView<T: UICollectionReusableView>(_: T.Type, kind: String) {
        self.base.register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: T.self))
    }

    public func dequeueView<T: UICollectionReusableView>(_ indexPath: IndexPath, kind: String) -> T {
        return self.base.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }
}
