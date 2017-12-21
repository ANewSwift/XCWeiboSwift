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
    
    /// 访问令牌，所有网络请求，都基于此令牌（登录除外）
    var accessToken: String? = "2.00zds_RGdS1b1B522d100d83qpsGqB"
    
    /// 专门负责拼接 token 的网络请求方法
    func tokenRequest(method: WBHTTPMethod = .GET,urlString: String,parameters: [String: AnyObject]?,completion:@escaping (_ json: AnyObject?,_ isSuccess: Bool)->()){
        
        // 处理 token 字典
        // 0> 判断 token 是否为 nil，为 nil 直接返回，程序执行过程中，一般 token 不会为 nil
        guard let token = accessToken else {
            print("没有 token! 需要登录")
            
            completion(nil, false)
            
            return 
        }
        // 1> 判断 参数字典是否存在，如果为 nil，应该新建一个字典
        var parameters = parameters
        if parameters == nil {
            // 实例化字典
            parameters = [String: AnyObject]()
            // 设置参数字典，代码在此处字典一定有值
            parameters!["access_token"] = token as AnyObject
        }
        
        // 调用 request 发起真正的网络请求方法
        request(method: method, urlString: urlString, parameters: parameters, completion: completion)
    }
    
    
    /// 封装 AFN 的 GET / POST 请求
    ///
    /// - Parameters:
    ///   - method: 请求方法get/post
    ///   - urlString: 请求URL地址
    ///   - parameters: 参数字典
    ///   - completion: 完成回调闭包
    func request(method: WBHTTPMethod = .GET,urlString: String,parameters: [String: AnyObject]?,completion:@escaping (_ json: AnyObject?,_ isSuccess: Bool)->()){
    
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
