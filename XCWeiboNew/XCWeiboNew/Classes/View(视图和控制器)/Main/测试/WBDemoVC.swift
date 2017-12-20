//
//  WBDemoVC.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/11/30.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit

class WBDemoVC: WBBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "第 \(navigationController?.childViewControllers.count ?? 0) 个"
    }

    //MARK: - 监听方法
    // 继续 push 一个新的控制器
    
    @objc func showNext(){
        let vc = WBDemoVC()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WBDemoVC{
    
    //重写父类
    override func setupTableView() {
        
        //没有这一句，跳转卡顿
        super.setupTableView()
        
        //设置右侧的控制器
        navItem.rightBarButtonItem = UIBarButtonItem.init(title: "下一个", target: self, action: #selector(showNext))
    }
}
