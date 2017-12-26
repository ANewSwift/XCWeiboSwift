//
//  AppDelegate.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/11/29.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit
import UserNotifications
import SVProgressHUD
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 设置应用程序额外信息
        setupAddtions()
        
        window = UIWindow()
        
//        window?.backgroundColor = UIColor.red
        window?.rootViewController = WBMainTabBarC()
        window?.makeKeyAndVisible()
        
        loadAppInfo()
        
        return true
    }

}

// MARK: - 设置应用程序额外信息
extension AppDelegate {
    fileprivate func setupAddtions(){
        // 1、设置 SVProgress的最小显示时间
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        
       // 2、设置网络加载指示器
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        // 3、设置用户授权显示通知
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound,.carPlay], completionHandler: { (success, error) in
                print("授权" + (success ? "成功" : "失败"))
            })
        } else {
            let notifySettings = UIUserNotificationSettings.init(types: [.alert,.badge,.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notifySettings)
            
        }
    }
}

// MARK: - 从服务器加载应用程序信息
extension AppDelegate {
    fileprivate func loadAppInfo() {
        // 1> 模拟异步
        DispatchQueue.global().async {
            // 1> url
            let url = Bundle.main.url(forResource: "demo.json", withExtension: nil)
            
            // 2> data
            let data = NSData.init(contentsOf: url!)
            // 3> 写入磁盘
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let jsonPath = docDir.appending("/demo.json")
            
            // 直接保存在沙盒，等待下一次程序的使用
            data?.write(toFile: jsonPath, atomically: true)
            
            print("应用程序加载完毕 \(jsonPath)")
        }
    }
}
