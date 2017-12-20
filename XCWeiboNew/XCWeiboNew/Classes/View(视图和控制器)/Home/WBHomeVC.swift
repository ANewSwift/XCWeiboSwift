//
//  WBHomeVC.swift
//  XCWeibo
//
//  Created by 郝少龙 on 2017/11/29.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit

// 定义全局常量，尽量使用 private 修饰，否则到处可以访问
private let cellId = "cellId"

class WBHomeVC: WBBaseVC {

    /// 微博数据数组
    fileprivate lazy var statusList = [String]()
    
    /// 加载数据
    override func loadData() {
        
        print("开始加载数据")
        
        // 模拟‘延时’加载数据 -> dispatch_after
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 2)) {
            
            for i in 0..<13 {
                if self.isPullup {
                    // 将数据追加到数组底部
                    self.statusList.append("上拉-\(i)")
                } else {
                    // 将数据插入到数组的顶部
                    self.statusList.insert(i.description, at: 0)
                }
                
            }
            
            print("刷新表格")
            
            // 结束刷新控件
            self.refreshControl?.endRefreshing()
            
            // 恢复上拉刷新标记
            self.isPullup = false
            
            // 刷新表格
            self.tableView?.reloadData()
        }
        
    }
    
    /// 显示好友
    func showFriends() {
        print(#function)
        
        let vc = WBDemoVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        
    }

    
}

// MARK: - 表格数据源方法， 具体的数据源方法实现， 不需要 super
extension WBHomeVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1、取cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for:indexPath)
        // 2、设置内容
        cell.textLabel?.text = statusList[indexPath.row]
        // 3、返回cell
        return cell;
    }
}

// MARK: - 设置界面
extension WBHomeVC {
    
    ///重写父类的方法
    override func setupTableView() {
    
        super.setupTableView()
        
        //设置导航栏的按钮
        // 这个init，方法是extension的，目的：加 带返回图标的按钮
        navItem.leftBarButtonItem = UIBarButtonItem.init(title: "好友", target: self, action: #selector(showFriends))
        
        // 注册原型cell
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
}
