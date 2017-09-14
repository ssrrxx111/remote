//
//  InfinitescrollView.swift
//  iOutdoors
//
//  Created by Kyle on 15/8/7.
//  Copyright (c) 2015年 xiaoluuu. All rights reserved.
//

import iCarousel
import UIKit

private let pageControlHeight: CGFloat = 29.0 // pagecontroller height
private var timer: Timer!
private var timerDuration: TimeInterval = 5.0
private var currentIndex = 1
private let defualtIdentifier: String = "defaultidentifier"

// MARK: InfinitscrollViewDelegate
@objc public protocol SSInfinitPageViewDelegate: NSObjectProtocol {

    func numberOfCellInInfinitPageView(_ scrollView: SSInfinitePageView) -> Int
    func infinitPageView(_ scrollView: SSInfinitePageView, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView

    @objc optional func infinitPageView(_ scrollView: SSInfinitePageView, didTapIndex index: Int)
    @objc optional func infinitPageView(_ scrollView: SSInfinitePageView, currentIndex index: Int)
}

// MARK: InfinitPageViewCell
open class SSInfinitPageViewCell: UIView {

    var cellTag: Int?
    var identifier: String! = "InfinitPageViewCell"

    // MARK: init method like UITableViewCell
    public init(frame: CGRect, identifier: String) {
        super.init(frame: frame)
        self.identifier = identifier

    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

  // MARK: - -----------------
    // MARK: Method for override
    func viewWillAppear() {

    }

    func viewDidAppear() {
    }

    func viewWillDisappear() {

    }

    func viewDidDisappear() {

    }

}

// MARK: InfinitePageView
open class SSInfinitePageView: UIView, UIScrollViewDelegate {

    fileprivate var totalNumber: Int = 0
    public weak var delegate: SSInfinitPageViewDelegate? {

        didSet {
            self.reloadData()
        }
    }

    public var interval: TimeInterval? {
        didSet {
            if let time = interval, time != 0.0 {
                scrollView.autoscroll = CGFloat(time)
            } else {
                scrollView.autoscroll = 0.0
            }
        }
    }

    public var scrollView: iCarousel = iCarousel(frame: CGRect.zero)
    public var pageControl: SSPageIndicatorController = SSPageIndicatorController()

    // shadow
    public var titleLabel: UILabel = UILabel()
    public var shadowView: UIView = UIView()

    fileprivate var timer: Timer?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()

    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupViews()
    }

    // MARK: public method

    public func reloadData() {

        self.scrollView.reloadData()
    }

    // MARK: - Timer function
    func updatePictureView() {
        if !scrollView.isDragging {
            currentIndex += 1
            self.scrollView.scrollToItem(at: currentIndex, animated: true)
            // self.scrollView.reloadItemAtIndex(currentIndex, animated: false)
        }

    }

    public func setTimer() {
        if timer == nil {
            timer = Timer(timeInterval: timerDuration, target: self, selector: #selector(updatePictureView), userInfo: nil, repeats: true)
            timer!.tolerance = timerDuration * 0.1
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        }
    }

    public func invalidateTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }

    open func setupViews() {

        self.scrollView.ss.customize { (view) in

            view.delegate = self
            view.dataSource = self
            view.backgroundColor = UIColor.clear
            view.clipsToBounds = true
            view.isPagingEnabled = true
            view.isScrollEnabled = true

            self.addSubview(view)
        }

        self.pageControl.ss.customize { (view) in
            view.dotWidth = 5
            view.hilightColor = SSColor.c102.light
            view.normalColor = UIColor.darkGray
            self.addSubview(view)
        }

        // init shadow
        self.shadowView.ss.customize { (view) in

            view.backgroundColor = UIColor.black
            view.alpha = 0.5
            view.isHidden = true

            self.addSubview(view)
        }

        self.titleLabel.ss.customize { (view) in

            view.backgroundColor = UIColor.clear
            view.textColor = UIColor.white

            self.addSubview(view)
        }

        self.scrollView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalTo(self)
        }

        self.pageControl.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(-3)
            make.height.equalTo(10)
        }

        self.shadowView.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalTo(self)
            make.height.equalTo(44)
        }

        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalTo(self)
            make.height.equalTo(44)
        }

    }
// MARK: hand tap gesture
}

extension SSInfinitePageView: iCarouselDataSource, iCarouselDelegate {

    public func numberOfItems(in carousel: iCarousel) -> Int {
        totalNumber = self.delegate?.numberOfCellInInfinitPageView(self) ?? 0
        pageControl.pageNumber = totalNumber
        pageControl.current = 0
        return totalNumber
    }

    public func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {

        return self.delegate?.infinitPageView(self, viewForItemAtIndex: index, reusingView: view) ?? UIView()
    }

    public func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        pageControl.current = carousel.currentItemIndex
        currentIndex = carousel.currentItemIndex
        self.delegate?.infinitPageView?(self, currentIndex: carousel.currentItemIndex)
    }

    public func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {

        switch option {
        case .wrap:
            if totalNumber <= 1 {
                if totalNumber == 1 {
                    carousel.currentItemIndex = 0
                }
                return 0.0
            }
            return 1.0
        default:
            break
        }

        return value
    }

    public func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        self.delegate?.infinitPageView?(self, didTapIndex: index)
    }

}
