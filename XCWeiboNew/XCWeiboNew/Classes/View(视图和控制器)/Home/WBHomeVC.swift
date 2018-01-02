//
//  WBHomeVC.swift
//  XCWeibo
//
//  Created by 郝少龙 on 2017/11/29.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit

/// 原创微博可重用 cell id
private let originalCellId = "originalCellId"
/// 被转发微博可重用 cell id
private let retweetedCellId = "retweetedCellId"

class WBHomeVC: WBBaseVC {
    
    /// 列表视图模型(上拉下拉刷新，数据模型)
    fileprivate lazy var listViewModel = WBStatusListViewModel()
    
    /// 加载数据
    override func loadData() {
        
        print("准备刷新")
        refreshControl?.beginRefreshing()
        
        // 模拟演示加载数据
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            
            self.listViewModel.loadStatus(isPullup: self.isPullup) { (isSuccess,shouldRefresh) in
                // 结束刷新控件
                self.refreshControl?.endRefreshing()
                // 恢复上拉刷新标记
                self.isPullup = false
                
                // 刷新表格
                if shouldRefresh {
                    self.tableView?.reloadData()
                }
            }
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
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vm = listViewModel.statusList[indexPath.row]
        
        let cellId = (vm.status.retweeted_status != nil) ? retweetedCellId : originalCellId
        
        // 1、取cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for:indexPath) as! WBStatusCell
        
        // 2、设置内容
        cell.viewModel = vm
        // 3、返回cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 1、根据indexPath 获取视图模型
        let vm = listViewModel.statusList[indexPath.row]
        // 2、返回计算好的行高
        return vm.rowHeight
    }
}

// MARK: - 设置界面
extension WBHomeVC {
    
    ///重写父类的方法,建立TabelView
    override func setupTableView() {
    
        super.setupTableView()
        
        //设置导航栏的按钮
        // 这个init，方法是extension的，目的：加 带返回图标的按钮
        navItem.leftBarButtonItem = UIBarButtonItem.init(title: "好友", target: self, action: #selector(showFriends))
        // 注册原型cell
        tableView?.register(UINib.init(nibName: "WBStatusRetweetedCell", bundle: nil), forCellReuseIdentifier: retweetedCellId)
        tableView?.register(UINib.init(nibName: "WBStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalCellId)
        
//        // 设置行高
//        // 取消自动行高
//         tableView?.rowHeight = UITableViewAutomaticDimension
        // 预估行高
        tableView?.estimatedRowHeight = 300

        // 取消分割线
        tableView?.separatorStyle = .none
        
        setupNavTitle()
    }
    
    /// 设置导航栏标题
    private func setupNavTitle(){
        
        let title = WBNetWorkManager.shared.userAccount.screen_name
        
        
        /// 如果title为空则默认title为“首页”，且没有上下箭头
        let button = WBTitleButton.init(title: title)
        
        navItem.titleView = button
        
        button.addTarget(self, action: #selector(clickTitleButton(btn:)), for: .touchUpInside)
    }
    
    @objc func clickTitleButton(btn: UIButton) {
        
        // 设置选中状态
        btn.isSelected = !btn.isSelected
    }
}
