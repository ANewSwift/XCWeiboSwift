
//
//  WBNetWorkManager+Extension.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/12/21.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import Foundation

// MARK: - 封装新浪微博的网络请求方法
extension WBNetWorkManager {
    func statusList(completion: @escaping (_ list: [[String:AnyObject]]?, _ isSuccess: Bool)->()) {
        
        // 用网络工具 加载微博数据
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        tokenRequest(urlString: urlString, parameters: nil) { (json, isSuccess) in
            //从 json 中获取 status 字典数组
            // 如果 as? 失败，result = nil
            let result = json?["statuses"] as? [[String: AnyObject]]
            completion(result, isSuccess)
        }
    }
}
