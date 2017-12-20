//
//  AppDelegate.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/11/29.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow()
        
//        window?.backgroundColor = UIColor.red
        window?.rootViewController = WBMainTabBarC()
        window?.makeKeyAndVisible()
        
        loadAppInfo()
        
        return true
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
