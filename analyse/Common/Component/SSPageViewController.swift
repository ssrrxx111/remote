//
//  SSPageViewController.swift
//  stocks-ios
//
//  Created by Eason Lee on 03/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit

public protocol SSPageViewControllerDelegate: class {
    func didScrollToIndex(_ index: Int)
}

open class SSPageViewController: UIPageViewController {

    open var controllers: [UIViewController]

    open weak var infiniteDelegate: SSPageViewControllerDelegate?

    fileprivate weak var _scrollView: UIScrollView?

    open var scrollEnabled: Bool {
        set {
            if _scrollView == nil {
                for subView in view.subviews {
                    if let scroll = subView as? UIScrollView {
                        _scrollView = scroll
                    }
                }
            }
            _scrollView?.isScrollEnabled = newValue
        }
        get {
            return _scrollView?.isScrollEnabled ?? true
        }
    }

    public init(frame: CGRect, viewControllers: [UIViewController]) {
        controllers = viewControllers
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollEnabled = true
    }

    override open func viewDidLoad() {
        super.viewDidLoad()


        dataSource = self
        delegate = self
        guard let first = controllers.first else { return }
        setViewControllers([first], direction: .forward, animated: true, completion: nil)
    }

    open func reset(controllers: [UIViewController], current: UIViewController) {
        self.controllers = controllers

        dataSource = nil
        dataSource = self

        setViewControllers([current], direction: .forward, animated: true, completion: nil)
    }
}

extension SSPageViewController: UIPageViewControllerDelegate {

    public func pageViewController(_ pageViewController: UIPageViewController,
                                   didFinishAnimating finished: Bool,
                                   previousViewControllers: [UIViewController],
                                   transitionCompleted completed: Bool) {
        if
            completed,
            let controller = viewControllers?.first,
            let index = controllers.index(of: controller) {
            infiniteDelegate?.didScrollToIndex(index)
        }
    }
}

extension SSPageViewController: UIPageViewControllerDataSource {

    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard controllers.count > 1, let index = controllers.index(of: viewController) else {
            return nil
        }

        if index == 0 {
            return controllers[controllers.count - 1]
        }
        let previousIndex = index - 1

        return controllers[previousIndex]
    }

    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard controllers.count > 1, let index = controllers.index(of: viewController) else {
            return nil
        }

        let nextIndex = index + 1
        if nextIndex == controllers.count {
            return controllers.first
        }

        return controllers[nextIndex]
    }
}
