//
//  WBUserAccount.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/12/25.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit

private let accountFile: NSString = "useraccount.json"

/// 微博账号信息
class WBUserAccount: NSObject {
    
    /// 访问令牌
    var access_token : String?
    
    /// 用户代号
    var uid : String?
    
    /// access_token的生命周期，单位是秒
    var expires_in: TimeInterval = 0 {
        didSet{
            expiresDate = Date.init(timeIntervalSinceNow: expires_in)
        }
    }
    
    /// 过期日期
    var expiresDate: Date?
    
    /// 用户昵称
    var screen_name: String?
    
    /// 用户头像地址（大图），180×180像素
    var avatar_large: String?
    
    override var description: String {
        return yy_modelDescription()
    }
    
    override init() {
        super.init()
        
        // 从磁盘加载保存的文件 -> 字典
        // 1> 加载磁盘文件到二进制数据，如果失败直接返回
        guard let path = accountFile.cz_appendDocumentDir(),
        let data = NSData.init(contentsOfFile: path),
        let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: AnyObject] else {
            return
        }
        
        // 2、使用字典设置属性值
        // *** 用户是否登录的关键代码
//        yy_modelSet(with: dict ?? [:])
        
        // 3. 判断 token 是否过期
        // 测试过期日期 - 开发中，每一个分支都需要测试！
//        expiresDate = Date.init(timeIntervalSinceNow: -3600 * 24)
        if expiresDate?.compare(Date()) != .orderedDescending {
            print("账户过期")
            
            //清空 token
            access_token = nil
            uid = nil
            
            // 删除账户文件
            try? FileManager.default.removeItem(atPath: path)
        }
        
        print("\(self)")
    }
    
    
    /**
     1. 偏好设置(小) - Xcode 8 beta 无效！
     2. 沙盒- 归档／plist/`json`
     3. 数据库(FMDB/CoreData)
     4. 钥匙串访问(小／自动加密 - 需要使用框架 SSKeychain)
     */
    func saveAccount() {
        
        // 1、模型转字典
        var dict = self.yy_modelToJSONObject() as? [String: NSObject] ?? [:]
        
        // 需要移除expiresDate
        dict.removeValue(forKey: "expires_in")
        
        // 2、数据序列化 data
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
        let filePath = accountFile.cz_appendDocumentDir()
        else {
            return
        }
        
        // 3、写入磁盘
        (data as NSData).write(toFile: filePath, atomically: true)
        
        print("用户账户保存成功 \(filePath)")
    }
    
}
