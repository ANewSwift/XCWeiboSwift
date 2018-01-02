
//
//  WBStatusListViewModel.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/12/21.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import Foundation
import SDWebImage
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
    lazy var statusList = [WBStatusViewModel]()
    
    func loadStatus(isPullup: Bool,completion: @escaping (_ isSuccess: Bool,_ shouldRefresh: Bool)->()){
        
        // 上拉刷新限制，错误超过三次，则不刷新
        if isPullup && pullupErrorTimes > maxPullupTryTimes {
            completion(true, false)
            return
        }
        
        let since_id = isPullup ? 0 : (statusList.first?.status.id ?? 0)
        let max_id = !isPullup ? 0 : (statusList.last?.status.id ?? 0)
        
        /// 调用网络管理工具，获取数据
        WBNetWorkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            // 0. 如果网络请求失败，直接执行完成回调
            if !isSuccess {
                completion(false, false)
                return
            }
            
            // 1. 遍历字典数组，字典转 模型 => 视图模型，将视图模型添加到数组
            var array = [WBStatusViewModel]()
            
            for dict in list ?? [] {
                // 1> 创建微博模型
                let status = WBStatus()
                
                // 2> 使用字典设置模型数值
                status.yy_modelSet(with: dict)
                
                // 3> 使用 `微博` 模型创建 `微博视图` 模型
                let viewModel = WBStatusViewModel.init(model: status)
                
                // 4> 添加到数组
                array.append(viewModel)
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
                
                self.cacheSingleImage(list: array, finished: completion)
                // 4. 真正有数据的回调！
                //completion(isSuccess, true)
            }

        }
    }
    
    /// 缓存本次下载微博数据数组中的单张图像
    ///
    /// - 应该缓存完单张图像，并且修改过配图是的大小之后，再回调，才能够保证表格等比例显示单张图像！
    ///
    /// - parameter list: 本次下载的视图模型数组
    
    private func cacheSingleImage(list: [WBStatusViewModel],finished: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) {
        
        // 调度组
        let group = DispatchGroup()
        
        // 记录数据长度
        var length = 0
        
         // 遍历数组，查找微博数据中有单张图像的，进行缓存
        for vm in list {
            
            // 1> 判断图像数量
            if vm.picURLs?.count != 1 {
                continue
            }
            
            // 2> 代码执行到此，数组中有且仅有一张图片
            guard let pic = vm.picURLs?[0].thumbnail_pic,
                let url = URL.init(string: pic) else {
                    continue
            }
            // print("要缓存的 URL 是 \(url)")
            // 3> 下载图像
            // 1) downloadImage 是 SDWebImage 的核心方法
            // 2) 图像下载完成之后，会自动保存在沙盒中，文件路径是 URL 的 md5
            // 3) 如果沙盒中已经存在缓存的图像，后续使用 SD 通过 URL 加载图像，都会加载本地沙盒地图像
            // 4) 不会发起网路请求，同时，回调方法，同样会调用！
            // 5) 方法还是同样的方法，调用还是同样的调用，不过内部不会再次发起网路请求！
            // *** 注意点：如果要缓存的图像累计很大，要找后台要接口！
            
            // A> 入组
            group.enter()
            
            SDWebImageManager.shared().loadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _, _) in
                if let image = image,let data = UIImagePNGRepresentation(image){
                    length += data.count
                    // 图像缓存成功，更新配图视图的大小
                    vm.updateSingleImageSize(image: image)
                }
                
                print("缓存的图像是 \(image) 长度 \(length)")
                
                // B> 出组 - 放在回调的最后一句
                group.leave()
            })
        }
        
        // C> 监听调度组情况
        group.notify(queue: DispatchQueue.main) {
            print("图像缓存完成 \(length / 1024) K")
            
            // 执行闭包回调
            finished(true, true)
        }
    }
}
