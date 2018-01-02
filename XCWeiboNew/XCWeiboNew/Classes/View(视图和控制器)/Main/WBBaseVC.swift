//
//  WBBaseVC.swift
//  XCWeibo
//
//  Created by 郝少龙 on 2017/11/29.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit

/// 所有主控制器的基类控制器
class WBBaseVC: UIViewController {
    
    /// 访客视图信息字典
    var visitorInfoDictionary: [String: String]?
    
    /// 表格视图 - 如果用户没有登录，就不创建
    var tableView : UITableView?
    
    /// 刷新控件
    var refreshControl: XCRefreshControl?
    
    /// 上拉刷新标识
    var isPullup = false
    
    /// 自定义导航条
    lazy var navigationBar = UINavigationBar.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
//    var navigationBar: UINavigationBar?
    /// 自定义导航条目
    lazy var navItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        // 用户登录方可加载数据
        WBNetWorkManager.shared.userLogon ? loadData() : ()
        
        // 注册用户登录成功的通知
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: WBUserLoginSuccessNotification), object: nil)

        if #available(iOS 11.0, *) {
            tableView?.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false;
        }
//        UIApplication.shared.statusBarStyle
//        print("状态栏的Frmae:\(UIApplication.shared.statusBarFrame)")
//        print("导航栏的Frame:\(navigationBar.frame)")
//        print("tableView的Fram\(view.bounds)")

    }
    
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    ///重写 title 的 didSet
    override var title: String?{
        didSet{
            navItem.title = title
        }
    }
    
    /// 加载数据 - 具体的实现由子类完成
    func loadData(){
        // 如果子类不实现此方法，默认关闭刷新控件
        refreshControl?.endRefreshing()
    
    }
    
}

// MARK: - 设置登录，注册按钮的监听方法
extension WBBaseVC {
    
    @objc fileprivate func loginSuccess(n:NotificationCenter){
        print("登录成功 \(n)")
        // 更新 UI => 将访客视图替换为表格视图
        // 需要重新设置 view
        // 在访问 view 的 getter 时，如果 view == nil 会调用 loadView -> viewDidLoad
        view = nil
        
        navItem.leftBarButtonItem = nil
        navItem.rightBarButtonItem = nil
        
        // 注销通知 -> 重新执行 viewDidLoad 会再次注册！避免通知被重复注册
        NotificationCenter.default.removeObserver(self)
    }
    
    /** 登录的监听方法 */
    @objc fileprivate func login() {
        // 发送登录通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    
    /** 登录的注册方法 */
    @objc fileprivate func register() {
        print("注册")
    }
}

// MARK: - 设置界面
extension WBBaseVC {

    /** 
     *  每次调用都NavigationBar，并设置空的tableView
     */
    fileprivate func setupUI(){
        
        // 取消自动缩进，隐藏导航栏会自动缩进 20 个点

       //automaticallyAdjustsScrollViewInsets = false
       

        // 自定义navigationBar
        setupNavigationBar()
    
        // FIXME: - 三目判断,切换访客视图 与 用户视图
        // 根据userLogon状态判断
        WBNetWorkManager.shared.userLogon ? setupTableView() : setupVisitorView()
    }
    
    // 设置表格视图
    func setupTableView() {
        // 新建tableView
        tableView = UITableView.init(frame: view.bounds, style: .plain)
        
        // 插入到顶部导航条下边
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        // 实现数据源的代理
        tableView?.dataSource = self
        tableView?.delegate = self
        
        // 设置tableView内容（顶部与底部避开导航条）缩进
        tableView?.contentInset = UIEdgeInsetsMake(navigationBar.bounds.height, 0, tabBarController?.tabBar.bounds.height ?? 49, 0)
        
        // 设置指示器偏移
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        
        // 设置刷新控件
        // 1> 实例化控件
        refreshControl =  XCRefreshControl()
        
        // 2> 添加到表格视图
        tableView?.addSubview(refreshControl!)
        
        // 3> 添加监听方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    // 设置访客视图
    private func setupVisitorView(){
        
        let visitorView = WBVisitorView.init(frame: view.bounds)
        view.insertSubview(visitorView, belowSubview: navigationBar)
        
        // 1、设置访客视图信息
        visitorView.visitorInfo = visitorInfoDictionary
        
        // 2、设置登录，注册按钮的Targer方法
        visitorView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        visitorView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        // 3、设置导航条上的按钮
        navItem.leftBarButtonItem = UIBarButtonItem.init(title: "登录", style: .plain, target: self, action: #selector(login))
        navItem.rightBarButtonItem = UIBarButtonItem.init(title: "注册", style: .plain, target: self, action: #selector(register))
        
    }
    
    // 设置导航条
    private func setupNavigationBar() {
        
        // 添加导航条
        view.addSubview(navigationBar)
        
        // 将item设置给 bar
        navigationBar.items = [navItem]
        
        // 1>设置 navBar 的渲染颜色(否则右侧曝光)
        navigationBar.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6)
//        navigationBar.barTintColor = UIColor.yellow

        // 2>设置 navBar 的字体颜色
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGray]
        
        // 3> 设置系统按钮的文字渲染颜色
        navigationBar.tintColor = UIColor.orange
    }
}

// MARK: - 设置数据源及代理
extension WBBaseVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    // 基类只是准备方法，子类负责具体的实现
    // 子类的数据源方法不需要 super
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    // 在显示最后一行的时候，做上拉刷新
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /// 目的：判断indexPath是不是最后一行
        // 拿到将要展示的组和行
        let row = indexPath.row
        let section = indexPath.section
        
        // 如果没有表格数据，直接return
        if row < 0 || section < 0 {
            return
        }
        
        // 拿到将要展示的那一组的最大行
        let count = tableView.numberOfRows(inSection: section)
        
        // 如果是最后一行，同时没有开始上拉刷新
        if (count - 1) == indexPath.row && !isPullup {
            print("上拉刷新")
            
            isPullup = true
            loadData()
        }
        
    }
    
    
}
