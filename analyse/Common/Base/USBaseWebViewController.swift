//
//  USWebViewController.swift
//  NewUstock
//
//  Created by adad184 on 7/8/16.
//  Copyright © 2016 ustock. All rights reserved.
//

import WebKit
import SwiftyJSON
import RxSwift
import RxCocoa

open class USBaseWebViewController: SSBaseViewController, WKUIDelegate, WKNavigationDelegate {

    public fileprivate(set) var webView: WKWebView!
    
    public var url = ""                                             
    fileprivate(set) var htmlString = ""
    private var lineAnimationView = UIView()
    public let progressView = UIProgressView()
//    fileprivate var backButton = UIButton()
    fileprivate var closeButton = UIButton()

    public init(url: String) {
        super.init(nibName: nil, bundle: nil)

        self.url = url
        
    }

    public init(htmlString: String) {
        super.init(nibName: nil, bundle: nil)

        self.htmlString = htmlString

    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init(params: String) {
        super.init(params: params)
        
        self.jsonData = JSON(params)
        self.htmlString = self.jsonData["htmlString"].stringValue
        self.url = self.jsonData["url"].stringValue
    }
    
    open override func setup() {
        super.setup()
        
        self.showNavBar = true
        self.isNavBarRenderWithThemeColor = false
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.loadURL()
    }

    public func loadURL() {
        if self.url != "" {
            if let components = URLComponents(string: self.url) {
                if let queryItems = components.queryItems, queryItems.count > 0 {
                    self.url = self.url + "&" + Utils.urlParameter()
                } else {
                    self.url = self.url + "?" + Utils.urlParameter()
                }
            }

            //            log.info("\(self.url)")

            guard let url = URL(string: self.url) else {
                return
            }
            
            self.webView.load(URLRequest(url: url))
        } else {
            self.webView.loadHTMLString(self.htmlString, baseURL: nil)
        }
    }

    open func reloadPage() {
        self.webView.reload()
    }

    open func updatePageWith(url: String) {
        self.url = url
        self.loadURL()
    }

    open func buildWKUserContentController() -> WKUserContentController {
        return WKUserContentController().ss.customize { (object) in
            object.add(USBaseWebViewControllerLeakAvoider(self), name: "Action")
            object.add(USBaseWebViewControllerLeakAvoider(self), name: "Webull")
            object.add(USBaseWebViewControllerLeakAvoider(self), name: "Activity")
            object.add(USBaseWebViewControllerLeakAvoider(self), name: "AppStore")
            object.add(USBaseWebViewControllerLeakAvoider(self), name: "openShare")
            object.add(USBaseWebViewControllerLeakAvoider(self), name: "openWeb")
            object.add(USBaseWebViewControllerLeakAvoider(self), name: "openTradeBuy")
            object.add(USBaseWebViewControllerLeakAvoider(self), name: "OpenUserFeedback")
            object.add(USBaseWebViewControllerLeakAvoider(self), name: "OpenCustomerServiceNumber")

        }
    }

    override open func buildUI() {
        super.buildUI()
        //
        let content = self.buildWKUserContentController()

        let config = WKWebViewConfiguration().ss.customize { (object) in
            object.userContentController = content
            object.preferences.javaScriptEnabled = true
        }

        self.webView = WKWebView(frame: CGRect.zero, configuration: config).ss.customize { (view) in
            self.contentView.addSubview(view)
            view.navigationDelegate = self
            view.uiDelegate = self
            view.isOpaque = false
            view.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }

        // 加入"webull"的UserAgent
        let uiwebView = UIWebView(frame: CGRect.zero)
        let oldAgent = uiwebView.stringByEvaluatingJavaScript(from: "navigator.userAgent")
        self.webView.customUserAgent = "\(oldAgent ?? "") webull"

        self.progressView.ss.customize { (view) in
            view.ss.themeHandler({ (view) in
                view.progressTintColor = SSColor.c401.color
            })

            self.contentView.addSubview(view)

            view.snp.makeConstraints { (make) in
                make.top.leading.trailing.equalToSuperview()
                make.height.equalTo(3)
            }

        }

        self.updateNavigationItems()
        
    }

    override open func buildRx() {
        super.buildRx()

        _ = self.webView
            .rx.observe(String.self, "title")
            .takeUntil(self.rx.deallocated)
            .subscribe(
                onNext: { [weak self] (title: String?) in

                    guard let `self` = self else {
                        return
                    }

                    guard let t = title else {
                        return
                    }

                    self.navItem.title = t
                    
                    self.updateNavigationItems()
                    self.updateTitle(titleStr: t)
            })

        _ = self.webView
            .rx.observe(Double.self, "estimatedProgress")
            .takeUntil(self.rx.deallocated)
            .subscribe(
                onNext: { [weak self] (progress: Double?) in

                    guard let `self` = self else {
                        return
                    }

                    guard let p = progress else {
                        return
                    }
                    self.updateProgress(p)
                    
            })

        /// 用户登录成功之后通知h5登录状态
        _ = NotificationCenter.default.rx.notification(SSNotification.User.loginStateChanged.name)
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [weak self](NSNotification) in
                guard let `self` = self else {
                    return
                }
                let jsFuncString = "getLoginStatus()"
                self.webView.evaluateJavaScript(jsFuncString, completionHandler: nil)
            })
        
        self.updateNavigationItems()
        
    }
    
    open func updateProgress(_ progress: Double) {
        self.progressView.progress = Float(progress)
        self.progressView.isHidden = self.progressView.progress >= 0.99
    }

    func updateTitle(titleStr: String?) {
        self.title = titleStr ?? ""
    }

    open func updateNavigationItems () {
        
    }
    
    /*
        当 WKWebView 总体内存占用过大，页面即将白屏的时候，系统会调用上面的回调函数，我们在该函数里执行[webView reload](这个时候 webView.URL 取值尚不为 nil）解决白屏问题。在一些高内存消耗的页面可能会频繁刷新当前页面，H5侧也要做相应的适配操作。
        source: https://zhuanlan.zhihu.com/p/24990222
    */
    
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }

    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if webView != self.webView {
            decisionHandler(.allow)
            return
        }

        let app = UIApplication.shared
        if let url = navigationAction.request.url {
            // 打开itunes
            if url.absoluteString.contains("itunes.apple.com") {
                if app.canOpenURL(url) {
                    app.openURL(url)
                    decisionHandler(.cancel)
                    return
                }
            }

            // Handle target="_blank"
            if navigationAction.targetFrame == nil {
                if app.canOpenURL(url) {
                    app.openURL(url)
                    decisionHandler(.cancel)
                    return
                }
            }

            // Handle phone and email links
            if url.scheme == "tel" || url.scheme == "mailto" {
                if app.canOpenURL(url) {
                    app.openURL(url)
                    decisionHandler(.cancel)
                    return
                }
            }

            decisionHandler(.allow)
        }
    }
    
    /// 处理window.open(url, "_blank")
    /// link http://www.jianshu.com/p/a6683ce03ee7
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
//         let targetFrame = navigationAction.targetFrame, targetFrame.isMainFrame, 
        guard let url = navigationAction.request.url else {
            return nil
        }
        
        let vc = USBaseWebViewController(url: url.absoluteString)
        self.ss.push(vc)
        return nil
    }

    /// 处理h5信息,需要处理的自己重写，走Webull的h5才能调用这个方法
    ///
    /// - Parameter jsonData: h5传递的接送数据
    open func dealH5Message(jsonData: JSON) {
        guard let code = jsonData["code"].int, code == 200 else {
//            SSLog("错误信息\(jsonData["msg"].stringValue)")
            self.dealErrorInfo(jsonData: jsonData)
            return
        }
        
        guard let module = jsonData["data"]["module"].string, let action = jsonData["data"]["action"].string else {
//            SSLog("返回数据异常\(jsonData["data"])")
            return
        }
        
        let params = jsonData["data"]["params"]
        
       
        
        // 关闭注册账户浏览器
        if module == "accountRegister" && action == "close" {
            _ = self.navigationController?.popViewController(animated: true)
            return
        }
        
        // 处理h5保存信息到客户端
//        if module == "app" && action == "saveInfo" {
//            
//        }
    }
    
    
    /// 处理js返回的错误信息
    ///
    /// - Parameter jsonData: json数据 code、 data 、 errorCode
    open func dealErrorInfo(jsonData: JSON) {
        let errorCode = jsonData["errorCode"].stringValue
        let msg = jsonData["msg"].stringValue
        var result = msg
        if errorCode != i18n(errorCode) {
            result = i18n(errorCode)
        }
        if result == "" {
            return
        }
        
        HUD.show(nil, detail: result, delay: 1.2, view: self.view)
    }
    
    /// 清除浏览器缓存
    open func deleteCash() {
        let types = WKWebsiteDataStore.allWebsiteDataTypes()
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: types, modifiedSince: date, completionHandler: {
//            SSLog("浏览器缓存已经被清除")
        })
        
    }
}

extension USBaseWebViewController: WKScriptMessageHandler {

    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        if message.name == "Webull" {
            guard let dataString = message.body as? NSString else {
                return
            }

            let jsonData = JSON(parseJSON: dataString as String)
            self.dealH5Message(jsonData: jsonData)

        } else if message.name == "AppStore" {
            UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/cn/app/wei-niu-tou-zi-mei-gu-jiao/id1179213067")!)
        } else if message.name == "openWeb" {
            self.handleOpenWeb(message: message)
        } else if message.name == "OpenUserFeedback" {  // 打开用户反馈
            self.handleOpenWeb(message: message)
        } else if message.name == "OpenCustomerServiceNumber" {  // 拨打客户电话
            self.handleOpenWeb(message: message)
        }
    }

    open func handleOpenWeb(message: WKScriptMessage) {
        guard let dataString = message.body as? NSString else {
            return
        }
        let jsonData = JSON(parseJSON: dataString as String)
        
        self.url = jsonData["url"].stringValue
        self.loadURL()
    }
}

public class USBaseWebViewControllerLeakAvoider: NSObject, WKScriptMessageHandler {

    weak var delegate : WKScriptMessageHandler?
    
    public init(_ delegate: WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.delegate?.userContentController(userContentController, didReceive: message)
    }
}
