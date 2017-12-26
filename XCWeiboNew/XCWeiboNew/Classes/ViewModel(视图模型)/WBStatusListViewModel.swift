
//
//  WBStatusListViewModel.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/12/21.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import Foundation

/// 微博数据列表视图模型
/*
 父类的选择
 
 - 如果类需要使用 `KVC` 或者字典转模型框架设置对象值，类就需要继承自 NSObject
 - 如果类只是包装一些代码逻辑(写了一些函数)，可以不用任何父类，好处：更加轻量级
 - 提示：如果用 OC 写，一律都继承自 NSObject 即可
 
 使命：负责微博的数据处理
 1. 字典转模型
 2. 下拉／上拉刷新数据处理
 */

private var pullupErrorTimes = 0
private let maxPullupTryTimes = 3

/** 事务逻辑层（处理上拉下拉刷新数据的获取，并回调传给控制器）*/
class WBStatusListViewModel {
    
    /// 微博模型数组懒加载
    lazy var statusList = [WBStatus]()
    
    func loadStatus(isPullup: Bool,completion: @escaping (_ isSuccess: Bool,_ shouldRefresh: Bool)->()){
        
        // 上拉刷新限制，错误超过三次，则不刷新
        if isPullup && pullupErrorTimes > maxPullupTryTimes {
            completion(true, false)
            return
        }
        
        let since_id = isPullup ? 0 : self.statusList.first?.id ?? 0
        let max_id = !isPullup ? 0 :self.statusList.last?.id ?? 0
        
        /// 调用网络管理工具，获取数据
        WBNetWorkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            // 1、字典转模型
            guard let array = NSArray.yy_modelArray(with: WBStatus.self, json: list ?? []) as? [WBStatus] else {
                
                completion(isSuccess, false)
                return
            }
            
            // 2、拼接数据
            if isPullup {
                self.statusList += array
            } else {
                self.statusList = array + self.statusList
            }
            
            print("array的count\(array.count)")
            // 3、判断上拉刷新的数据量
            if isPullup && array.count == 0 {
                pullupErrorTimes += 1
                completion(isSuccess, false)
            } else {
                completion(isSuccess, true)
            }

        }
    }
}
