

//
//  UIImage+Extensions.swift
//  Common
//
//  Created by Hugo on 2017/5/9.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import Foundation

extension UIImage {
    
    /**
     图片压缩，异步处理
     
     - parameter size:        最终分辨率
     - parameter maxDataSize: 图片大小kb
     - parameter handler:     成功回调
     */
    public func compressImage(_ size: CGSize, maxDataSize: Int, handler: ((_ imageData: Data?) -> Void)?) {
        DispatchQueue.global(qos: .default).async {
            let image = self.scaleImage(size)
            let data = image.resetSizeToData(maxDataSize)
            DispatchQueue.main.async(execute: {
                handler?(data)
            })
        }
    }
    
    /**
     更改分辨率
     
     - parameter size: 分辨率
     
     - returns: UIImage
     */
    public func scaleImage(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    
    /**
     图片质量压缩到指定大小，二分
     
     - parameter maxSize: 大小kb
     
     - returns: NSData
     */
    public func resetSizeToData(_ maxSize: Int) -> Data? {
        
        // 先判断当前大小是否满足要求，不满足再进行压缩
        let data = UIImageJPEGRepresentation(self, 1)!
        if data.size() <= maxSize {
            return data
        }
        
        var maxQuality: CGFloat = 1
        var minQuelity: CGFloat = 0
        while maxQuality - minQuelity >= 0.01 { // 精度
            let midQuality = (maxQuality + minQuelity) / 2
            let data = UIImageJPEGRepresentation(self, midQuality)!
            if data.size() > maxSize {
                maxQuality = midQuality
            } else {
                minQuelity = midQuality
            }
        }
        return UIImageJPEGRepresentation(self, minQuelity)
    }
    
    public convenience init(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: view.frame.size.width, height: view.frame.size.height), false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage!)!)
    }

}


extension Data {
    /**
     获取data size
     
     - returns: kb
     */
    public func size() -> Int {
        let sizeOrigin = Int64(self.count)
        let sizeOriginKB = Int(sizeOrigin / 1024)
        return sizeOriginKB
    }
}
