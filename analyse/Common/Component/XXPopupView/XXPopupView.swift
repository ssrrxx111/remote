//
//  XXPopupView.swift
//
//
//  Created by adad184 on 7/11/16.
//  Copyright © 2016 ustock. All rights reserved.
//
import SnapKit

public enum XXPopupType: Int {
    case alert
    case sheet
    case drop
    case custom
    case right
    case none
}

protocol XXPopupable {

    /**
     *  override this method to show the keyboard if with a keyboard
     */
    func showKeyboard()

    /**
     *  override this method to hide the keyboard if with a keyboard
     */
    func hideKeyboard()

    /**
     *  override this method to provide custom show animation
     */
    func showAnimation(completion closure: ((_ popupView: XXPopupView, _ finished: Bool) -> Void)?)

    /**
     *  override this method to provide custom hide animation
     */
    func hideAnimation(completion closure: ((_ popupView: XXPopupView, _ finished: Bool) -> Void)?)
}

//记录xxAlertView弹出状态
public let stackDepthRecordOfXXAlertView = XXAlertViewStackDepthRecord()
public class XXAlertViewStackDepthRecord {
    
    public var alertDepth: Int = 0
    
    public var isShowing: Bool {
        return alertDepth > 0
    }
    
    public func show() {
        alertDepth += 1
    }
    
    public func hide() {
        alertDepth -= 1
        alertDepth = max(0, alertDepth)
    }
}

open class XXPopupView: UIView, XXPopupable {

    fileprivate struct XXPopupNotification {
        static let hideAll = "XXPopupViewHideAllNotification"
    }

    var visible: Bool {

        guard let view = self.targetView else {
            return false
        }

        return view.xx_dimBackgroundView.isHidden
    }

    public weak var targetView: UIView?
    public var type: XXPopupType = .custom
    public var duration: TimeInterval = 0.3
    public var withKeyboard: Bool = false

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    open func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyHideAll(_:)), name: Notification.Name(rawValue: XXPopupNotification.hideAll), object: nil)

        self.targetView = XXPopupWindow
        self.clipsToBounds = true
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: XXPopupNotification.hideAll), object: nil)
    }

    @objc fileprivate func notifyHideAll(_ n: Notification) {
        guard let cls: AnyClass = n.object as! AnyClass? else {
            return
        }

        if self.isKind(of: cls) {
            self.hide()
        }
    }

    /**
     *  show the popup view with completiom block
     */
    open func show(completion closure: ((_ popupView: XXPopupView, _ finished: Bool) -> Void)? = nil) {

        if self.targetView == nil {
            self.targetView = XXPopupWindow
        }
        self.targetView?.xx_showDimBackground()

        self.showAnimation(completion: closure)

        if self.withKeyboard {
            self.showKeyboard()
        }
    }

    /**
     *  hide the popup view with completiom block
     */
    open func hide(completion closure: ((_ popupView: XXPopupView, _ finished: Bool) -> Void)? = nil) {

        //记录xxAlertView弹出状态
        stackDepthRecordOfXXAlertView.hide()
        
        if self.targetView == nil {
            self.targetView = XXPopupWindow
        }
        self.targetView?.xx_hideDimBackground()

        self.hideAnimation(completion: closure)

        if self.withKeyboard {
            self.hideKeyboard()
        }
    }

    /**
     *  hide all popupview with current class, eg. XXAlertview.hideAll()
     */
    open static func hideAll() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: XXPopupNotification.hideAll), object: self.self)
    }
}

extension XXPopupView {

    func showKeyboard() {

    }

    func hideKeyboard() {

    }

    open func showAnimation(completion closure: ((_ popupView: XXPopupView, _ finished: Bool) -> Void)?) {

        if self.superview == nil {
            self.targetView?.xx_dimBackgroundView.addSubview(self)
        }

        switch self.type {
        case .alert:
            self.snp.remakeConstraints({ (make) in
                let y = self.withKeyboard ? (-216 / 2 ) : 0
                make.centerY.equalTo(self.targetView!).offset(y)
                make.centerX.equalTo(self.targetView!)
            })
            //            self.layoutIfNeeded()

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
                    if let completionClosure = closure {
                        completionClosure(self, finished)
                    }
            })
        case .sheet:
            self.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(self.targetView!)
                make.width.equalTo(self.targetView!)
                make.bottom.equalTo(self.targetView!.snp.bottom)
            })
            self.layoutIfNeeded()
            self.transform = CGAffineTransform(translationX: 0, y: self.targetView!.frame.height)

            UIView.animate(
                withDuration: self.duration,
                delay: 0.0,
                options: [
                    UIViewAnimationOptions.curveEaseOut,
                    UIViewAnimationOptions.beginFromCurrentState
                ],
                animations: {
                    self.transform = CGAffineTransform.identity
            },
                completion: { (finished: Bool) in
                    if let completionClosure = closure {
                        completionClosure(self, finished)
                    }
            })
        case .right:
            self.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(self.targetView!)
                make.width.equalTo(Utils.screenWidth * 4 / 5)
                make.height.equalTo(Utils.screenHeight)
                make.trailing.equalToSuperview()
            })
            self.layoutIfNeeded()
            self.transform = CGAffineTransform(translationX: Utils.screenWidth * 4 / 5, y: 0)
            
            UIView.animate(
                withDuration: self.duration,
                delay: 0.0,
                options: [
                    UIViewAnimationOptions.curveEaseOut,
                    UIViewAnimationOptions.beginFromCurrentState
                ],
                animations: {
                    self.transform = CGAffineTransform.identity
            },
                completion: { (finished: Bool) in
                    if let completionClosure = closure {
                        completionClosure(self, finished)
                    }
            })
            
        case .drop:
            self.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(self.targetView!)
                make.width.equalTo(self.targetView!)
                make.top.equalTo(self.targetView!.snp.top)
            })
            self.layoutIfNeeded()
            self.transform = CGAffineTransform(translationX: 0, y: -self.targetView!.frame.height)

            UIView.animate(
                withDuration: self.duration,
                delay: 0.0,
                options: [
                    UIViewAnimationOptions.curveEaseOut,
                    UIViewAnimationOptions.beginFromCurrentState
                ],
                animations: {
                    self.transform = CGAffineTransform.identity
            },
                completion: { (finished: Bool) in
                    if let completionClosure = closure {
                        completionClosure(self, finished)
                    }
            })
        case .custom:
            self.snp.remakeConstraints({ (make) in
                let y = self.withKeyboard ? (-216 / 2) : 0
                make.centerY.equalTo(self.targetView!).offset(y)
                make.centerX.equalTo(self.targetView!)
            })
            self.layoutIfNeeded()

            self.transform = CGAffineTransform(translationX: 0, y: -self.targetView!.frame.height)

            UIView.animate(
                withDuration: self.duration,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 1.5,
                options: [
                    UIViewAnimationOptions.curveEaseOut,
                    UIViewAnimationOptions.beginFromCurrentState
                ],
                animations: {
                    self.transform = CGAffineTransform.identity
            },
                completion: { (finished: Bool) in
                    if let completionClosure = closure {
                        completionClosure(self, finished)
                    }
            })
            break
        default:
            break
        }
    }

    open func hideAnimation(completion closure: ((_ popupView: XXPopupView, _ finished: Bool) -> Void)?) {

        switch self.type {
        case .alert:
            UIView.animate(
                withDuration: self.duration,
                delay: 0.0,
                options: [
                    UIViewAnimationOptions.curveEaseIn,
                    UIViewAnimationOptions.beginFromCurrentState
                ],
                animations: {
                    self.alpha = 0.0
            },
                completion: { (finished: Bool) in
                    if finished {
                        self.removeFromSuperview()
                    }
                    if let completionClosure = closure {
                        completionClosure(self, finished)
                    }
            })
            break
        case .sheet:
            UIView.animate(
                withDuration: self.duration,
                delay: 0.0,
                options: [
                    UIViewAnimationOptions.curveEaseIn,
                    UIViewAnimationOptions.beginFromCurrentState
                ],
                animations: {
                    self.transform = CGAffineTransform(translationX: 0, y: self.targetView!.frame.height)
            },
                completion: { (finished: Bool) in
                    if finished {
                        self.removeFromSuperview()
                    }
                    if let completionClosure = closure {
                        completionClosure(self, finished)
                    }
            })
        case .right:
            UIView.animate(
                withDuration: self.duration,
                delay: 0.0,
                options: [
                    UIViewAnimationOptions.curveEaseIn,
                    UIViewAnimationOptions.beginFromCurrentState
                ],
                animations: {
                    self.transform = CGAffineTransform(translationX: Utils.screenWidth * 4 / 5, y: 0)
            },
                completion: { (finished: Bool) in
                    if finished {
                        self.removeFromSuperview()
                    }
                    if let completionClosure = closure {
                        completionClosure(self, finished)
                    }
            })
            
        case .drop:

            UIView.animate(
                withDuration: self.duration,
                delay: 0.0,
                options: [
                    UIViewAnimationOptions.curveEaseIn,
                    UIViewAnimationOptions.beginFromCurrentState
                ],
                animations: {
                    self.transform = CGAffineTransform(translationX: 0, y: -self.targetView!.frame.height)
            },
                completion: { (finished: Bool) in
                    if finished {
                        self.removeFromSuperview()
                    }
                    if let completionClosure = closure {
                        completionClosure(self, finished)
                    }
            })
        case .custom:
            UIView.animate(
                withDuration: self.duration,
                delay: 0.0,
                options: [
                    UIViewAnimationOptions.curveEaseIn,
                    UIViewAnimationOptions.beginFromCurrentState
                ],
                animations: {
                    self.transform = CGAffineTransform(translationX: 0, y: self.targetView!.frame.height)
            },
                completion: { (finished: Bool) in
                    if finished {
                        self.removeFromSuperview()
                    }
                    if let completionClosure = closure {
                        completionClosure(self, finished)
                    }
            })
        default:
            break
        }
    }
}
