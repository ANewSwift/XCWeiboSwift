//
//  WBStatusPicture.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/12/27.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit

/// 微博配图模型
class WBStatusPicture: NSObject {

    /// 缩略图地址 - 新浪返回的缩略图令人发指
    var thumbnail_pic: String?
    /// 大尺寸图片
//    var largePic: String?
    
    override var description: String {
        return yy_modelDescription()
    }
}
