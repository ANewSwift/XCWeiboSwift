//
//  UIBarButtonItem+Extensions.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/12/8.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    /** 自定义，isBack:判断是否是第一个控制器，添加返回按钮 */
    convenience init(title: String, fontSize: CGFloat = 16, target: AnyObject?, action: Selector, isBack: Bool = false) {
        let btn = UIButton.createBtn(title: title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        
        //判断如果不是第一个控制器，则加上返回的按钮
        if isBack {
            btn.setImage(UIImage.init(named: "navigationbar_back_withtext"), for: .normal)
            btn.setImage(UIImage.init(named: "navigationbar_back_withtext_highlighted"), for: .highlighted)
            //加东西好像需要，重新设置下尺寸
            btn.sizeToFit()
        }
        
        btn.addTarget(target, action: action, for: .touchUpInside)
        
         self.init(customView: btn)
        
    }
}
