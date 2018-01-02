
//
//  XCRefreshControl.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2018/1/2.
//  Copyright © 2018年 郝少龙. All rights reserved.
//

import UIKit

/// 刷新控件
class XCRefreshControl: UIControl {
    
    // MARK: - 属性
    /// 刷新控件的父视图，下拉刷新控件应该适用于 UITableView / UICollectionView
    private weak var scrollView: UIScrollView?
    
    // MARK: - 构造函数
    init() {
        super.init(frame: CGRect.init())
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
    
        // 判断父视图的类型
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        
        // 记录父视图
        scrollView = sv
//        scrollView?.backgroundColor = UIColor.blue
    
        // KVO 监听父视图的 contentOffset
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    // 所有 KVO 方法会统一调用此方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let sv = scrollView else {
            return
        }
        
        // 初始高度就应该是 0
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        
        // 可以根据高度设置刷新控件的 frame
        self.frame = CGRect.init(x: 0, y: -height, width: sv.bounds.width, height: height)
        
    }
    
    /// 开始刷新
    func beginRefreshing() {
        print("开始刷新")
    }
    
    /// 结束刷新
    func endRefreshing() {
        print("结束刷新")
    }

}

extension XCRefreshControl {
    
    fileprivate func setupUI() {
        backgroundColor = UIColor.orange
    }
}
