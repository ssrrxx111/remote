//
//  USEmailUtils.swift
//  FMSetting
//
//  Created by webull on 2017/6/2.
//  Copyright © 2017年 fumi. All rights reserved.
//

import Foundation
import MessageUI

open class USEmailUtils: NSObject {
    
    public static let instance = USEmailUtils()
    
    // 发送邮件
    public func sendMail(_ email: String) {
        // 首先要判断设备具不具备发送邮件功能
        if MFMailComposeViewController.canSendMail() {
            let controller = MFMailComposeViewController()
            controller.mailComposeDelegate = self
            // 设置主题
            controller.setSubject("")
            // 设置收件人
            controller.setToRecipients([email])
            // 设置邮件正文内容（支持html）
            controller.setMessageBody("", isHTML: false)
            
            // 打开界面
            CommonDispatcher.topVC?.ss.present(controller, animated: true, completion: nil)
        } else {
            showSendMailErrorAlert(email)
        }
    }
    
    // 无法发送邮件提示
    public func showSendMailErrorAlert(_ email: String) {
        let action1 = XXActionItem(title: i18n("setting.menu.setting"), action: { (index) in
            UIApplication.shared.openURL(URL(string: "mailto://\(email)")!)
        }, status: .highlighted, image: nil)
        let action2 = XXActionItem(title: i18n("common.cancel"), action: nil, status: .normal, image: nil)
        
        XXAlertView(title: i18n("setting.feedback.email.error.title"), detail: i18n("setting.feedback.email.error.message"), actionItems: [action1, action2]).show()
    }
    
}

extension USEmailUtils: MFMailComposeViewControllerDelegate {
    // 邮件发送代理
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
