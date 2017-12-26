
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
    
    /** 下拉上拉刷新获取数据 */
    func statusList(since_id: Int64,max_id: Int64, completion: @escaping (_ list: [[String:AnyObject]]?, _ isSuccess: Bool)->()) {
        
        // 用网络工具 加载微博数据
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        let params = ["since_id": "\(since_id)","max_id": "\(max_id > 0 ? max_id - 1 : 0)"]
        
        tokenRequest(urlString: urlString, parameters: params as [String : AnyObject]) { (json, isSuccess) in
            //从 json 中获取 status 字典数组
            // 如果 as? 失败，result = nil
            let result = json?["statuses"] as? [[String: AnyObject]]
            completion(result, isSuccess)
        }
    }
    
    /** 获取未读数 */
    func unReadcount(completion: @escaping (_ count: Int)->()) {
        guard let uid = userAccount.uid else {
            return 
        }
        
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        let params = ["uid":uid]  as [String : AnyObject]
        
        tokenRequest(urlString: urlString, parameters: params) { (json, isSuccess) in
            let dict = json as? [String: AnyObject]
            let count = dict?["status"] as? Int
            completion(count ?? 0)
        }
        
        
    }
    
}

// MARK: - 用户信息
extension WBNetWorkManager {
    
    /// 加载当前用户信息 - 用户登录后立即执行
    func loadUserInfo(completion: @escaping (_ dict: [String: AnyObject])->()){
        guard let uid = userAccount.uid else {
            return
        }
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        let params = ["uid":uid]
        
        tokenRequest(urlString: urlString, parameters: params as [String : AnyObject]) { (json, isSuccess) in
            completion((json as? [String: AnyObject]) ?? [:])
        }
        
        
    }
}

// MARK: - 请求Access_Token
extension WBNetWorkManager {
    
    /// 获取Access_Token
    func loadAccessToken(code: String,completion:@escaping (_ isSuccess: Bool)->()) {
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        let params = ["client_id": WBAppKey,
                      "client_secret": WBAppSecret,
                      "grant_type": "authorization_code",
                      "code": code,
                      "redirect_uri": WBRedirectURI]
        
        request(method: .POST, urlString: urlString, parameters: params as [String : AnyObject]) { (json, isSuccess) in
           
            // 如果请求失败，对用户账户数据不会有任何影响
            // 直接用字典设置 userAccount 的属性
            self.userAccount.yy_modelSet(with: (json as? [String: AnyObject]) ?? [:])
            
            // 加载当前用户信息
            self.loadUserInfo(completion: { (dict) in
                
                // 使用用户信息字典设置用户账户信息(昵称和头像地址)
                self.userAccount.yy_modelSet(with: dict)
                
                // 保存模型
                self.userAccount.saveAccount()
                
                print(self.userAccount)
                
                // 完成回调
                completion(isSuccess)
            })

        }
    }
    
}
