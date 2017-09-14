//
//  SSTabButtonView.swift
//  NewUstock
//
//  Created by adad184 on 6/21/16.
//  Copyright © 2016 ustock. All rights reserved.
//

import RxSwift

public enum segmentLayoutMode: Int {
    case equalFill = 0
    case sizeFit = 1
}

class SSTabButtonView: UICollectionView {

    /// tab标题数组
    var titles: [String] = [] {
        didSet {
            self.reloadData()
        }
    }
    /// 当前选中的序号
    var selectedTabIndex = Variable(0) {
        didSet {
            self.reloadData()

        }
    }
    /// tab高
    var tabHeight: CGFloat = 40 {
        didSet {
            self.reloadData()
        }
    }
    
    var layoutMode: segmentLayoutMode = .sizeFit

    fileprivate let sizingCell = SSTabButtonCell()
    
    fileprivate let disposeBag: DisposeBag = DisposeBag()

    convenience init() {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.init(frame: CGRect.zero, collectionViewLayout: layout)

        self.delegate = self
        self.dataSource = self
        self.showsHorizontalScrollIndicator = false

        self.register(SSTabButtonCell.self, forCellWithReuseIdentifier: SSTabButtonCell.ss.className)

        self.selectedTabIndex
        .asObservable()
        .subscribe(onNext: { [weak self] _ in
            guard let `self` = self else {
                return
            }
            self.reloadData()
            if self.titles.count>0 {
                let indexPath: IndexPath = IndexPath(row: self.selectedTabIndex.value, section: 0)
                self.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        })
        .addDisposableTo(self.disposeBag)
    }
}

extension SSTabButtonView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    override var numberOfSections: Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SSTabButtonCell.ss.className, for: indexPath) as! SSTabButtonCell
        cell.title = self.titles[indexPath.row]
        cell.isSelected = (self.selectedTabIndex.value == indexPath.row)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        self.selectedTabIndex.value = indexPath.row
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.sizingCell.title = self.titles[indexPath.row]

        var size = self.sizingCell.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        size.height = self.tabHeight
        
        if layoutMode == .equalFill {
            size.width = (self.frame.width - 20) / CGFloat(self.titles.count)
        }
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}

class SSTabButtonCell: SSBaseCollectionViewCell {

    var title: String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }

    override var isSelected: Bool {
        didSet {
            self.titleLabel.textColor = isSelected ? SSColor.c306.color : SSColor.c302.color
            self.titleLabel.layer.transform = CATransform3DScale(CATransform3DIdentity, isSelected ? 1.05 : 1.0, isSelected ? 1.05 : 1.0, 1.0)
            self.selectedBar.isHidden = !isSelected
        }
    }
 
    fileprivate let titleLabel = UILabel()
    fileprivate let selectedBar = UIView()

    override func setup() {

        // config
        self.titleLabel.ss.customize { (view) in
            view.font = SSFont.t05.font
            view.textAlignment = .center
            self.contentView.addSubview(view)
        }
        
        self.selectedBar.ss.customize { (view) in
            self.contentView.addSubview(view)
        }
        
        ss.themeHandler { [weak self] (cell) in
            guard let `self` = self else {
                return
            }
            self.titleLabel.textColor = self.isSelected ? SSColor.c306.color : SSColor.c302.color
            self.selectedBar.backgroundColor = SSColor.c306.color
        }

        // layout
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalTo(self.contentView).inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            make.width.greaterThanOrEqualTo(40)
        }
        
        self.selectedBar.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.titleLabel)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-2)
            make.height.equalTo(2)
            make.width.equalTo(18)
        }
    }
}
