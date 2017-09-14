//
//  USPageController.swift
//  PageController
//
//  Created by Tank on 2016/9/29.
//  Copyright © 2016年 ustock. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

/// 导航条高度
public let segmentControlHeight: CGFloat = 36.0

public protocol SSPageControllerDelegate: class {
    func didScrollToIndex(_ index: Int)
}

open class SSPageController: SSBaseViewController {

    open weak var delegate: SSPageControllerDelegate?
    
    private var segmentHeight: Constraint? = nil

    //是否允许左右滑动
    open var isScrollEnable: Bool = true {
        didSet {
            self.scrollView.isScrollEnabled = self.isScrollEnable

            self.scrollView.layoutIfNeeded()
        }
    }
    open var isbouncesEnable: Bool = true {
        didSet {
            self.scrollView.bounces = isbouncesEnable
        }
    }
    
    public let lineHeight: CGFloat = UIUtils.seperatorWidth

    /// 是否显示导航条
    open var isSegmentShow: Bool = true {
        didSet {
            self.segmentControl.isHidden = !isSegmentShow
            
            self.segmentHeight?.update(offset: isSegmentShow ? segmentControlHeight : 0)
        }
    }
    
    open let segmentControl: HMSegmentedControl = HMSegmentedControl(sectionTitles: [""])
    open let line: UIView = UIView()
    /// 滚动视图
    public let scrollView: UIScrollView = UIScrollView()
    /// 是否在手动滑动
    open var isDragging: Bool = false
    /// 所有子Controller
    open var subViewControllers: [UIViewController] = [UIViewController]() {
        didSet {
            calculateLayout()
            for vc in childViewControllers.filter({ !subViewControllers.contains($0) }) {
                vc.view.removeFromSuperview()
                vc.willMove(toParentViewController: nil)
                vc.removeFromParentViewController()
            }
            guard subViewControllers.count > 0 else {
                return
            }

            //Title
            segmentControl.sectionTitles = subViewControllers.map {
                $0.title ?? ""
            }
            segmentControl.setNeedsDisplay()

            //当前显示的ViewController
            if oldValue.count > currentIndex, let index = subViewControllers.index(of: oldValue[currentIndex]) {
                currentIndex = index
            } else {
                currentIndex = 0
            }
            for (index, _) in subViewControllers.enumerated() {
                displayControllerWithIndex(index, needLayout: true)
            }
//            segmentControl.setSelectedSegmentIndex(UInt(currentIndex), animated: false)
            segmentControl.setSelectedSegmentIndex(UInt(currentIndex), animated: false)
        }
    }
    
    /// 当前页
    open var currentIndex: Int = 0 {
        didSet {
            guard currentIndex >= 0, subViewControllers.count > currentIndex else {
                currentIndex = 0
                scrollView.contentOffset = CGPoint(x: 0, y: 0)
                return
            }
            if currentIndex != Int(scrollView.contentOffset.x / viewWidth) {
                scrollView.setContentOffset(CGPoint(x: viewWidth * CGFloat(currentIndex), y:0), animated: self.isScrollEnable)
            }

            displayControllerWithIndex(currentIndex, force: true, needLayout: true)
            
            self.didScrollToIndex(currentIndex)
        }
    }
    /// 将要显示的页
    fileprivate var willToIndex: Int = 0
    /// 选中页
    open var selectIndex: Int {
        get {
            return currentIndex
        }
        set {
            currentIndex = newValue
        }
    }
    /// 当前VC
    open var currentViewController: UIViewController? {
        if self.subViewControllers.count > currentIndex {
            return self.subViewControllers[currentIndex]
        } else {
            return nil
        }
    }
    /// 总页数
    open var totalPages: Int {
        get {
            return subViewControllers.count
        }
    }
    /// 页面宽度
    public var viewWidth: CGFloat = 1.0 {
        didSet {
            if viewWidth == 0.0 {
                viewWidth = 1.0
            }
        }
    }
    
    fileprivate let disposeBag: DisposeBag = DisposeBag()

    open override func buildUI() {
        super.buildUI()
        
        self.scrollView.ss.customize { (view) in
            view.isPagingEnabled = true
            view.showsHorizontalScrollIndicator = false
            view.showsVerticalScrollIndicator = false
            view.delegate = self
            self.contentView.addSubview(view)
        }

        self.segmentControl.ss.customize { (view) in
            view.selectionIndicatorEdgeInsets = FixedSegmentControlSelectionIndicatorEdgeInsets
            view.selectionIndicatorHeight = 3.0
            view.selectionIndicatorLocation = .up
            view.selectionStyle = .textWidthStripe
            
            self.contentView.addSubview(view)
        }
        
        self.segmentControl.ss.themeHandler { (seg) in
            seg.backgroundColor = SSColor.c303.color
            seg.selectionIndicatorColor = SSColor.c303.color
            seg.titleTextAttributes = [
                NSForegroundColorAttributeName: SSColor.c303.color.withAlphaComponent(0.65),
                NSFontAttributeName: SSFont.t05.bold
            ]
            seg.selectedTitleTextAttributes = [
                NSForegroundColorAttributeName: SSColor.c303.color,
                NSFontAttributeName: SSFont.t05.bold,
                NSParagraphStyleAttributeName: NSMutableParagraphStyle().ss.customize { (style) in
                    style.lineSpacing = 1
                }]
            seg.setNeedsDisplay()
        }
        
        self.segmentControl.indexChangeBlock = {  [weak self] (seletedIndexPage) in
            guard let `self` = self else {
                return
            }
            self.selectIndex = seletedIndexPage
        }

        self.line.ss.customize { (view) in
//            view.isHidden = true
            self.segmentControl.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.left.equalTo(self.segmentControl.snp.left)
                make.right.equalTo(self.segmentControl.snp.right)
                make.bottom.equalTo(self.segmentControl.snp.bottom)
                make.height.equalTo(lineHeight)
            }
            
            view.ss.themeHandler({ (view) in
                view.backgroundColor = SSColor.c413.color
            })
        }
        
        // add segmentcontroller

        //layout
        viewWidth = self.view.bounds.width
        self.scrollView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.segmentControl.snp.bottom)
        }
        self.segmentControl.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            self.segmentHeight = make.height.equalTo(segmentControlHeight).constraint
        }

        self.calculateLayout()

        self.view.layoutIfNeeded()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        viewWidth = self.view.bounds.width
        self.calculateLayout()
    }

    private func calculateLayout() {
        scrollView.contentSize = CGSize(width: viewWidth*CGFloat(subViewControllers.count), height: 0)
    }

    fileprivate func didLoadControllerForIndex(_ index: Int) -> UIViewController? {
        if subViewControllers.count > index, index >= 0 {
            let vc = subViewControllers[index]
            if childViewControllers.contains(vc) {
                return vc
            }
        }
        return nil
    }

    public func displayControllerWithIndex(_ index: Int, force: Bool = false, needLayout: Bool = false) {
        
        guard index >= 0 && index <= self.subViewControllers.count - 1 else {
            return
        }
        var isNeedLayout = needLayout
        if let vc = didLoadControllerForIndex(index) {
            if vc.view.superview == nil {
                scrollView.addSubview(vc.view)
                isNeedLayout = true
            }
            if isNeedLayout {
                vc.view.snp.remakeConstraints({ (make) in
                    make.leading.equalTo(scrollView.snp.leading).offset(CGFloat(index)*viewWidth)
                    make.top.equalTo(scrollView)
                    make.width.height.equalTo(scrollView)
                })
            }
        } else if force {
            let currentVC = subViewControllers[index]
            if !childViewControllers.contains(currentVC) {
                scrollView.addSubview(currentVC.view)
                addChildViewController(currentVC)
                currentVC.didMove(toParentViewController: self)
                isNeedLayout = true
            }
            if isNeedLayout {
                currentVC.view.snp.makeConstraints({ (make) in
                    make.leading.equalTo(scrollView.snp.leading).offset(CGFloat(index)*viewWidth)
                    make.top.equalTo(scrollView)
                    make.width.height.equalTo(scrollView)
                })
            }
        }
    }

    fileprivate func removeControllerWithIndex(_ index: Int) {
        if let vc = didLoadControllerForIndex(index) {
            if let _ = vc.view.superview {
                vc.view.removeFromSuperview()
            }
        }
    }

    open func didScrollToIndex(_ index: Int) {
        if didLoadControllerForIndex(index - 1) == nil {
            self.displayControllerWithIndex(index - 1, force: true)
        }
        if didLoadControllerForIndex(index + 1) == nil {
            self.displayControllerWithIndex(index + 1, force: true)
        }
        delegate?.didScrollToIndex(index)
    }
    
    open func willScrollToIndex(_ index: Int) {
        //
    }
}

extension SSPageController : UIScrollViewDelegate {
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isDragging = false
        let offsetCurrentIndex = Int(scrollView.contentOffset.x / viewWidth)

        for index in 0..<subViewControllers.count {
            if index != offsetCurrentIndex {
                removeControllerWithIndex(index)
            }
        }
        self.currentIndex = offsetCurrentIndex
        if let vc = currentViewController {
            vc.viewWillDisappear(true)
            vc.viewDidAppear(true)
        }
    }

    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let offsetCurrentIndex = Int(scrollView.contentOffset.x / viewWidth)

        for index in 0..<subViewControllers.count {
            if index != offsetCurrentIndex {
                removeControllerWithIndex(index)
            }
        }
        self.currentIndex = offsetCurrentIndex
        if let vc = currentViewController {
            vc.viewWillDisappear(true)
            vc.viewDidAppear(true)
        }
    }

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isDragging {
            let willToPage = Int((scrollView.contentOffset.x / viewWidth) + 0.5)
            if willToPage < self.subViewControllers.count && willToPage != self.willToIndex {
                self.willToIndex = willToPage
                self.willScrollToIndex(willToPage)
                segmentControl.setSelectedSegmentIndex(UInt(willToPage), animated: true)
            }
            
            let currentScrollPage = Int(scrollView.contentOffset.x / viewWidth)

            for index in 0..<subViewControllers.count {
                if index <= currentScrollPage+1 && index >= currentScrollPage-1 {
                    displayControllerWithIndex(index)
                } else {
                    removeControllerWithIndex(index)
                }
            }
        }
    }
    
    open func hideOtherVCs() {
        for vc in self.subViewControllers {
            if vc != currentViewController {
                vc.view.removeFromSuperview()
            }
        }
    }
}
