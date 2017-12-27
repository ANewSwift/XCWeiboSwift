//
//  WBMainTabBarC.swift
//  XCWeibo
//
//  Created by 郝少龙 on 2017/11/29.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBMainTabBarC: UITabBarController {
    
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 利用数组定义所有子控制器
        setupChildControllers()
        
        // 创建一个ContactAdd类型的按钮
        setupComposeButton()

        // 建立首页及App未读数图标
        setupTimer()
        
        // 设置新特性视图
        setupNewfeatureViews()
        
        // 设置代理
        delegate = self
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    
    deinit {
        // 销毁时钟
        timer?.invalidate()
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    /** 
     portrait : 竖屏，肖像
     landscape: 横屏，风景画
     
     -  使用代码控制设备的方向，好处，可以在需要横屏的时候， 单独处理
     -  设置支持的方向后，当前的控制器及子控制器都会遵循这个方向！
     -  如果播放视屏，通常是通过 modal 展现的
     
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get{
            return .portrait
        }
    }
    
    // MARK: - 监听方法
    /** 监听用户登录的通知 */
    @objc private func userLogin(n:Notification){
        print("用户登录通知\(n)")
        
        var when = DispatchTime.now()
        
        // 判断n.objectb 是否有值，如果有值，提示用户重新登录
        if n.object != nil{
            
            SVProgressHUD.setDefaultMaskType(.gradient)
            
            SVProgressHUD.showInfo(withStatus: "用户登录已经超时，需要重新登录")
            when = DispatchTime.now() + 2
        }
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            SVProgressHUD.setDefaultMaskType(.clear)
            
            let nav = UINavigationController.init(rootViewController: WBOAuthVC())
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    
    /// 撰写微博
    // FIXME: 没有实现
    @objc fileprivate func composeStatus(){
        print("撰写微博")
        
        // 测试方向旋转
        let vc = UIViewController()
        
        vc.view.backgroundColor = UIColor.randomColor
        
        let nav = UINavigationController.init(rootViewController: vc)
        
        present(nav, animated: true, completion: nil)
        
        
    }
    
    // MARK: - 私有控件
    ///撰写按钮
    fileprivate var composeButton: UIButton = UIButton.cz_imageButton(
        "tabbar_compose_icon_add",
        backgroundImageName: "tabbar_compose_button")
   
}

// MARK: - 新特性视图处理
extension WBMainTabBarC {
    
    fileprivate func setupNewfeatureViews(){
        
        // 0、判断是否登录
        if !WBNetWorkManager.shared.userLogon {
            return
        }
        
        // 1、如果更新，显示新特性，否则显示欢迎界面
        let v = isNewVersion ? WBNewFeatureView.newFeatureView() : WBWelcomeView.welcomeView()
        
        // 2、把视图添加到View上
        v.frame = view.bounds
        view.addSubview(v)
        
    }
    
    /// extesions 中可以有计算型属性，不会占用存储空间
    /// 构造函数：给属性分配空间
    /**
     版本号
     - 在 AppStore 每次升级应用程序，版本号都需要增加，不能递减
     
     - 组成 主版本号.次版本号.修订版本号
     - 主版本号：意味着大的修改，使用者也需要做大的适应
     - 次版本号：意味着小的修改，某些函数和方法的使用或者参数有变化
     - 修订版本号：框架／程序内部 bug 的修订，不会对使用者造成任何的影响
     */
    private var isNewVersion: Bool {
        
        // 1.取当前版本号 1.0.2
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        print("当前版本号：\(currentVersion)")
        
        // 2、取保存在 `Document(iTunes备份)[最理想保存在用户偏好]` 目录中的之前的版本号“1.0.1”
        let path: String = ("version" as NSString).cz_appendDocumentDir()
        let sandboxVersion = (try? String.init(contentsOfFile: path)) ?? ""
        print("沙盒版本:" + sandboxVersion)
        
        // 3、将当前版本号保存在沙盒
        try? currentVersion.write(toFile: path, atomically: true, encoding: .utf8)
        
        // 4、返回两个版本号'是否一致'，not new
        return currentVersion != sandboxVersion
//        return currentVersion == sandboxVersion
    }
}

// MARK: - UITabBarControllerDelegate代理方法
extension WBMainTabBarC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool{
        
//        print("将要切换到 \(viewController)")
        // 1>获取控制器在数组中的索引
        let idx = childViewControllers.index(of: viewController)
        // 2>判断当前索引是首页，将要切换的控制器也是首页，则是重复点击
        if selectedIndex == 0 && idx == selectedIndex {
            print("点击首页")
            
            // 3>让表格滚到到顶部
            // a) 获取到控制器
            let nav = childViewControllers[0] as! UINavigationController
            let vc = nav.childViewControllers[0] as! WBHomeVC
            
            // b) 滚动到顶部
            vc.tableView?.setContentOffset(CGPoint.init(x: 0, y: -64), animated: true)
            // 4> 刷新数据 - 增加延迟，是保证表格先滚动到顶部再刷新
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                vc.loadData()
            }
            
            // 5> 清除 tabItem 的 badgeNumber
            vc.tabBarItem.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0
            
        }
        
        // 判断目标控制器是否是 UIViewController,否则不切换
        return !viewController.isMember(of: UIViewController.self)
    }
    
    
}

// MARK: - 时钟相关方法
extension WBMainTabBarC {
    
    /// 定义时钟
    fileprivate func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    /// 时钟触发方法
    @objc private func updateTimer() {
        
        if !WBNetWorkManager.shared.userLogon {
            return
        }
        
        WBNetWorkManager.shared.unReadcount { (count) in
            print("检测到\(count)条数据")
           
        // 设置首页TabBar,未读微博数
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
        
        // 设置应用图标的未读数
            if count > 0 {
                UIApplication.shared.applicationIconBadgeNumber = count
            }
            
        }
    }
}

// MARK: - 设置界面
extension WBMainTabBarC{
    
    /** 设置撰写按钮 */
    fileprivate func setupComposeButton(){
        
        tabBar.addSubview(composeButton)
        
        //计算按钮的宽度
        let count = CGFloat(childViewControllers.count)
        let w = tabBar.bounds.width / count
        
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
        
        //按钮的监听方法
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
        
        
    }
    
    /** 设置所有子控制器 */
     fileprivate func setupChildControllers(){
        
        // 0、获取沙盒 json 路径
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = docDir.appending("/demo.json")
        
        // 加载Data
        var data = NSData.init(contentsOfFile: jsonPath)
        if data == nil {
            // 从 bundle 加载配置的 json(一定有所以用 "!")
            let path = Bundle.main.path(forResource: "demo.json", ofType: nil)
            data = NSData.init(contentsOfFile: path!)
        }
        
        // 从 bundle 加载配置的 json
        // 反序列化转成数组
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String: AnyObject]]
            else {
                return
        }
        
        // 遍历数组，循环创建控制器的数组
        var arrayM = [UIViewController]()
        for dict in array! {
            arrayM.append(controller(dict: dict))
        }
        
        // FIXME: - 继承此类 -UITabBarController，最关键就是设置其viewControllers
        // 设置 tabBar 的自控制器
        viewControllers = arrayM

    } 
    
    /** 使用字典创建一个子控制器 */
    private func controller(dict: [String : AnyObject]) -> UIViewController{
        
        //1、取得字典内容
        guard let clsName = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? WBBaseVC.Type,
        let visitorDict = dict["visitorInfo"] as? [String: String]
        
        else {
            return UIViewController()
        }
        
        // 2、创建视图控制器
        let vc = cls.init()
        // 设置标题
        vc.title = title
        
        // 设置控制器的访客信息字典
        vc.visitorInfoDictionary = visitorDict
        
        //3、设置图像
        vc.tabBarItem.image = UIImage.init(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage.init(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        
        //4、设置 tabbar 的标题字体（颜色大小）
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orange], for: .highlighted)
        //设置高亮状态下的字体不起作用
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12)], for:.normal)
        
        // 设置根控制器
        let nav = WBNavigationC.init(rootViewController: vc)
        
        return nav
    
    }
}
