
//
//  UILabel+Extension.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/12/18.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit

extension UILabel{
    static func xc_labelWithText(text: NSString,fontSize: CGFloat,color: UIColor) -> UILabel{
        let label = UILabel()
        
        label.text = text as String
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = color
        label.numberOfLines = 0
        
        label.sizeToFit()
        
        return label
        
    }
}
