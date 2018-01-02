
//
//  UIImage.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/12/27.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import Foundation

extension UIImage {
    
    /// 创建头像图像
    func cz_avatarImage(size: CGSize?,backColor: UIColor = UIColor.white,lineColor: UIColor = UIColor.lightGray) -> UIImage? {
        
        var size = size
        if size == nil || size?.width == 0 {
            size = CGSize.init(width: 34, height: 34)
        }
        
        let rect = CGRect.init(origin: CGPoint.init(), size: size!)
        
        //opauqe true 不透明/false 透明
        // 上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        // 圆外背景色填充
        backColor.setFill()
        UIRectFill(rect)
        
        // 圆的路径
        let path = UIBezierPath.init(ovalIn: rect)
        path.addClip()
        
        // 绘制
        draw(in: rect)
        
        let ovalPath = UIBezierPath(ovalIn: rect)
        ovalPath.lineWidth = 2
        lineColor.setStroke()
        ovalPath.stroke()
        
        // 获取上下文
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result
        
    }
    
    /// 生成指定大小的不透明图象
    func cz_image(size: CGSize? = nil, backColor: UIColor = UIColor.white) -> UIImage? {
        
        var size = size
        if size == nil {
            size = self.size
        }
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        backColor.setFill()
        UIRectFill(rect)
        
        draw(in: rect)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result
    }
}
