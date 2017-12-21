//
//  WBNetWorkManager.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/12/20.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit
import AFNetworking


/// swift 数据类型可以是任意
/// switch / enum 在OC 都只支持整数
enum WBHTTPMethod {
    case GET
    case POST
}

/// 网络管理工具
class WBNetWorkManager: AFHTTPSessionManager {
    
    /// 静态区/ 常量/ 闭包
    /// 在第一次访问时，执行闭包，把结果保存在 shared 常量中
    static let shared = WBNetWorkManager()
    
    func request(method: WBHTTPMethod = .GET,urlString: String,parameters: [String: AnyObject],completion:@escaping (_ json: AnyObject?,_ isSuccess: Bool)->()){
    
        // 成功的回调
        let success = { (task: URLSessionDataTask, json: Any?)->() in
                completion(json as AnyObject, true)
        }
        
        // 失败的回调
        let failure = { (task: URLSessionDataTask?, error: Error)->() in
            print("网络请求错误 \(error)")
            completion(nil, false)
            
        }
        
        if method == .GET {
            get(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            post(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
        
        
    }
}
