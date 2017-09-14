//
//  SSBaseViewController.swift
//  stocks-ios
//
//  Created by Eason Lee on 03/01/2017.
//  Copyright © 2017 Stocks. All rights reserved.
//

import UIKit
import SnapKit
import FDFullscreenPopGesture
import SwiftyJSON

open class SSBaseViewController: UIViewController, UIGestureRecognizerDelegate {

    #if DEBUG
    deinit {
        SSLog("Deinit \(self.ss.className)")
    }
    #endif

    convenience public init() {
        self.init(nibName: nil, bundle: nil)
        setup()
    }

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var jsonData: SwiftyJSON.JSON = SwiftyJSON.JSON.null
    
    /// 使用url创建vc，需要参数的时候使用，参数的key请使用init方法中对应的参数名称。
    /// 如init(title:"123"),获取的时候使用self.jsonData["title"].stringValue
    /// 如果子类需要自定义init方法，请加上他，并且将自定义
    public required init(params: String) {
        self.jsonData = SwiftyJSON.JSON(params)
        super.init(nibName: nil, bundle: nil)
        self.setup()
    }

    public let navBar: SSNavigationBar = SSNavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
    public let navItem: UINavigationItem = UINavigationItem()
    public var isNavBarRenderWithThemeColor = true
    
    /// track相关
    public var trackId: SSTrackEventPoint? = nil
    public var trackProperty: [AnyHashable: Any]? = nil
    public var trackOnce: Bool = false                      // 只记录一次，相当于viewDidLoad,否则页面每次出现记录

    public var showNavBar: Bool = true {
        didSet {
            updateNavigationBar()
        }
    }

    public let contentView: UIView = UIView()

    public var showBackButton: Bool = true
    public var backBar: UIBarButtonItem!
    public var backButton: UIButton!

    private var isFirstAppear: Bool = true
    open var isAppear: Bool = false

    override open func viewDidLoad() {
        super.viewDidLoad()

        buildUI()
        buildRx()
        buildTracker()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.isAppear = true
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.isAppear = false
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if self.isFirstAppear {
            self.viewDidFirstAppear()
            self.isFirstAppear = false
        }
        
        self.dealTrack(!self.trackOnce)
    }
    
    // 根据self.trackOnce的状态确定是load打点还是didAppear打点
    fileprivate func dealTrack(_ need: Bool = true) {
        if need {
            if let trackId = self.trackId {
                TRACKER.event(trackId, property: self.trackProperty ?? [:])
            }
        }
    }

    open func setup() {
        self.hidesBottomBarWhenPushed = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.extendedLayoutIncludesOpaqueBars = false
        self.edgesForExtendedLayout = []
        self.fd_prefersNavigationBarHidden = true
    }
    
    open func buildUI() {
        
        self.hideKeyboardWhenTappedAround()
        
        self.navBar.tintColor = SSColor.c303.color
        
        self.backButton = UIUtils.button(
            target: self,
            action: #selector(actionBack),
            image: "common.back",
            title: nil,
            color: (StocksConfig.appearance.theme == .black || !self.isNavBarRenderWithThemeColor) ? SSColor.c301 : SSColor.c102,
            inset: nil
        )
        
        self.backBar = UIBarButtonItem(customView: self.backButton)
        
        self.view.ss.themeHandler { [weak self] (view) in
            view.backgroundColor = SSColor.c101.color
            
            self?.setNeedsStatusBarAppearanceUpdate()
        }

        if showBackButton {
            self.navItem.leftBarButtonItems = [
                UIUtils.fixedSpacer(offset: -12),
                self.backBar
            ]
        }
        self.navBar.items = [self.navItem]

        if self.isNavBarRenderWithThemeColor {
            self.navBar.ss.themeHandler { (bar) in
                bar.backgroundColor = UIColor.xx_hexColor(0x67AFF6FF)
//                bar.updateBackgroundImage()
                bar.titleTextAttributes = [
                    NSForegroundColorAttributeName: SSColor.c104.color,
                    NSFontAttributeName: SSFont.t04.bold
                ]
            }
        } else {
            self.navBar.ss.themeHandler { (bar) in
                bar.backgroundColor = UIColor.xx_hexColor(0x67AFF6FF)
//                bar.backgroundColor = SSColor.c102.color
                bar.titleTextAttributes = [
                    NSForegroundColorAttributeName: SSColor.c301.color,
                    NSFontAttributeName: SSFont.t04.bold
                ]
                bar.ss.applyShadow()
            }
        }

        self.view.addSubview(self.navBar)
        self.updateNavigationBar()

        self.view.addSubview(self.contentView)

        self.contentView.clipsToBounds = true
        self.contentView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.navBar.snp.bottom)
        }
        
        self.view.bringSubview(toFront: self.navBar)
    }

    open func buildRx() {

    }
    
    open func buildTracker() {
        
    }

    open func viewDidFirstAppear() {
        self.dealTrack(self.trackOnce)
    }

    private func updateNavigationBar() {

        guard self.navBar.superview != nil else {
            return
        }

        self.navBar.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(64)
            if self.showNavBar {
                self.navBar.isHidden = false
                make.top.equalTo(self.view.snp.top)
            } else {
                self.navBar.isHidden = true
                make.bottom.equalTo(self.view.snp.top)
            }
        }
    }

    public func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.contentView.addGestureRecognizer(tap)
    }

    open func dismissKeyboard() {
        view.endEditing(true)
    }

    open func actionBack() {
        guard let nav = self.navigationController, nav.viewControllers.count > 1 else {
            self.ss.dismiss()
            return
        }
        self.ss.pop()
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        
        if StocksConfig.appearance.theme == .black {
            return .lightContent
        }
        
        return self.isNavBarRenderWithThemeColor ? .lightContent : .default
    }

    override open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }

}

extension SSBaseViewController {

}
