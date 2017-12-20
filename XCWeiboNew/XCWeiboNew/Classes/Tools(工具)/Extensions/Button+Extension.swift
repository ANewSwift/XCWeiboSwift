
//
//  Button+Extension.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/11/29.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit

extension UIButton{
   
    static func createBgBtn(imgNameN:String,imgNameH:String,bgImgNameN:String,bgImgNameH:String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage.init(named: imgNameN), for: .normal)
        button.setImage(UIImage.init(named: imgNameH), for: .highlighted)
        button.setBackgroundImage(UIImage.init(named: bgImgNameN), for: .normal)
        button.setBackgroundImage(UIImage.init(named: bgImgNameH), for: .highlighted)
        
        return button
    }
    
    static func createBtn(title: String, fontSize: CGFloat, normalColor: UIColor, highlightedColor: UIColor) -> UIButton{
        
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
//        btn.titleLabel?.text = title
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        btn.setTitleColor(normalColor, for: .normal)
        btn.setTitleColor(highlightedColor, for: .highlighted)
        
        btn.sizeToFit()
        return btn
    }
    
  
}
