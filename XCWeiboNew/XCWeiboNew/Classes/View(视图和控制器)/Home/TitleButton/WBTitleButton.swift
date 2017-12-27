//
//  WBTitleButton.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/12/26.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit

class WBTitleButton: UIButton {

    /// 重载构造函数
    /// - title 如果是 nil，就显示`首页`
    /// - 如果不为 nil，显示 title 和 箭头图像
    init(title: String?) {
        super.init(frame: CGRect.init())
        
        // 1> 判断 title 是否为nil
        if title == nil {
            setTitle("首页", for: .normal)
        } else {
            setTitle(title! + " ", for: .normal)
            
            // 设置图像
            setImage(UIImage.init(named: "navigationbar_arrow_down"), for: .normal)
            setImage(UIImage.init(named: "navigationbar_arrow_up"), for: .selected)
        }
        
        // 2> 设置字体和颜色
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: .normal)
        
        // 3> 设置大小
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 重新布局子视图
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let titleLabel = titleLabel,let imageView = imageView else {
            return
        }
        
        // 将label的x左移动imageView的宽度
        titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)
        // 将imageView的x右移动label的宽度
        imageView.frame = imageView.frame.offsetBy(dx: titleLabel.bounds.width, dy: 0)
    }
    
}
