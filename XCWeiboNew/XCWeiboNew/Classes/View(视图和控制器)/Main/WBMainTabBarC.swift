//
//  WBMainTabBarC.swift
//  XCWeibo
//
//  Created by 郝少龙 on 2017/11/29.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit

class WBMainTabBarC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 利用数组定义所有子控制器
        setupChildControllers()
        // 创建一个ContactAdd类型的按钮
        setupComposeButton()
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
    
    
    //MARK: - 监听方法
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

extension WBMainTabBarC{
    
    ///设置撰写按钮
    fileprivate func setupComposeButton(){
        
        tabBar.addSubview(composeButton)
        
        //计算按钮的宽度
        let count = CGFloat(childViewControllers.count)
        let w = tabBar.bounds.width / count - 1
        
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
        
        //按钮的监听方法
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
        
        
    }
    
    /// 设置所有子控制器
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
    
    ///使用字典创建一个子控制器
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
