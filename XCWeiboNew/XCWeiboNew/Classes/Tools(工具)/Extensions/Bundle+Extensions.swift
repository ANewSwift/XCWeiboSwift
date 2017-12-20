
//
//  Bundle+Extensions.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/11/29.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import Foundation

extension Bundle{
    ///返回命名空间字符串
    
    //计算型属性类似于函数，没有参数，有返回值
    var namespace: String{
            return infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
}
