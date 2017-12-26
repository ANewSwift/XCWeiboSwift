//
//  WBNavigationC.swift
//  XCWeibo
//
//  Created by 郝少龙 on 2017/11/29.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit

class WBNavigationC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 隐藏默认的 NavigationBar
        navigationBar.isHidden = true
        print(navigationBar.frame)
    }
    
    /// 重写 push 方法，所有的 push 动作都会调用此方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        // 如果不是栈低控制器才需要隐藏，跟控制器不需要处理
        if childViewControllers.count > 0 {
            // 隐藏底部的 TabBar
            viewController.hidesBottomBarWhenPushed = true
            
            //判断控制器的类型
            if let vc = viewController as? WBBaseVC {
                
                var title = "返回"
                
                // 判断控制器的级数，只有一个子控制器的时候，显示栈底控制器的标题
                if childViewControllers.count == 1 {
                    title = childViewControllers.first?.title ?? "返回"
                }
                
                vc.navItem.leftBarButtonItem = UIBarButtonItem.init(title: title, target: self, action: #selector(popToParent), isBack: true)
                
            }
        }
        
        super.pushViewController(viewController, animated: true)
        
    }
    
    /// POP 返回到上一级控制器
    @objc private func popToParent(){
        popViewController(animated: true)
    }
}
