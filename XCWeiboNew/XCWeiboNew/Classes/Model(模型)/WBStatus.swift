//
//  WBStatus.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/12/21.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit
import YYModel

/// 微博数据模型
class WBStatus: NSObject {
    /// Int 类型，在 64 位的机器是 64 位，在 32 位机器就是 32 位
    /// 如果不写 Int64 在 iPad 2/iPhone 5/5c/4s/4 都无法正常运行
    var id: Int64 = 0
    /// 微博信息内容
    var text: String?
    
    /// 重写 description 的计算型属性
    override var description: String{
        return yy_modelDescription()
    }
    
    
    
}
