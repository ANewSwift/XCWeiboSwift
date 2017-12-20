//
//  WBVisitorView.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/12/18.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit

/// 访客视图
class WBVisitorView: UIView {
    
    /// 登录按钮
    lazy var loginButton: UIButton = UIButton.cz_textButton("登录",
        fontSize: 16,
        normalColor: UIColor.darkGray,
        highlightedColor: UIColor.black,
        backgroundImageName: "common_button_white_disable")
    
    /// 注册按钮
    lazy var registerButton: UIButton = UIButton.cz_textButton("注册",
       fontSize: 16,
       normalColor: UIColor.orange,
       highlightedColor: UIColor.black,
       backgroundImageName: "common_button_white_disable")

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 旋转图标的动画（首页）
    fileprivate func startAnimation() {
        
        let anim = CABasicAnimation.init(keyPath: "transform.rotation")
        
        // 每隔 duration 转 toValue 角度 且重复 repeatCount次
        anim.toValue = 2 * Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 10
        
        // 动画完成不删除，如果 iconView 被释放，动画会一起销毁！
        // 在设置连续播放的动画非常有用！
        anim.isRemovedOnCompletion = false
        
        // 将动画添加到图层
        iconView.layer.add(anim, forKey: nil)
        
        
        
    }
    
    /// 访客视图的信息字典 [imageName / message]
    /// 如果是首页 imageName == ""
    var visitorInfo: [String: String]? {
        didSet{
            // 1> 取字典信息
            guard let imageName = visitorInfo?["imageName"],
                let message = visitorInfo?["message"]
                else {
                    return
            }
            
            // 2> 设置消息
            tipLabel.text = message
            
            // 3> 设置图像，首页不需要设置
            if imageName == ""{
                
                startAnimation()
                return
            }
            
            iconView.image = UIImage.init(named: imageName)
            
            // 其他控制器的访客视图不需要显示小房子/遮罩视图
            houseIconView.isHidden = true
            maskIconView.isHidden = true
        }
    }
    

    // MARK: - 私有控件
    /// 懒加载属性只有调用 UIKit 控件的指定构造函数不需，其他都需要使用类型
    /// 图像视图
    fileprivate lazy var iconView = UIImageView.init(image: UIImage.init(named: "visitordiscover_feed_image_smallicon"))
    
    /// 遮罩图像 - 使用maskView会重名
    fileprivate lazy var maskIconView = UIImageView.init(image: UIImage.init(named: "visitordiscover_feed_mask_smallicon"))
    
    /// 小房子
    fileprivate lazy var houseIconView = UIImageView.init(image: UIImage.init(named: "visitordiscover_feed_image_house"))
    
    /// 提示
    fileprivate lazy var tipLabel = UILabel.xc_labelWithText(text: "关注一些人，回这里看看有什么惊喜关注一些人，回这里看看有什么惊喜",
        fontSize: 14,
        color: UIColor.darkGray)
}

// MARK: - 设置界面
extension WBVisitorView{
    func setupUI() {
        backgroundColor = UIColor.cz_color(withHex: 0xEDEDED)
        
        //1、添加控件
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipLabel)
        addSubview(loginButton)
        addSubview(registerButton)
        
        // 文本居中
        tipLabel.textAlignment = .center
        
        // 2、取消自动布局(autoresizing)
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
         /// 自动布局 边距
         let margin: CGFloat = 20.0
        
        // 3、自动布局
        // 1> 图像视图
        addConstraints([NSLayoutConstraint.init(item: iconView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0)])
        addConstraints([NSLayoutConstraint.init(item: iconView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: -60)])
        
        // 2> 小房子
        addConstraints([NSLayoutConstraint.init(item: houseIconView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0)])
        addConstraints([NSLayoutConstraint.init(item: houseIconView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: -60)])
        
        // 3> 提示标签
        addConstraints([NSLayoutConstraint.init(item: tipLabel,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: iconView,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0)])
        addConstraints([NSLayoutConstraint.init(item: tipLabel,
            attribute: .top,
            relatedBy: .equal,
            toItem: iconView,
            attribute: .bottom,
            multiplier: 1.0,
            constant: margin)])
        addConstraints([NSLayoutConstraint.init(item: tipLabel,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 236)])
        
        // 4> 注册按钮
        addConstraints([NSLayoutConstraint.init(item: loginButton,
            attribute: .left,
            relatedBy: .equal,
            toItem: tipLabel,
            attribute: .left,
            multiplier: 1.0,
            constant: 0)])
        addConstraints([NSLayoutConstraint.init(item: loginButton,
            attribute: .top,
            relatedBy: .equal,
            toItem: tipLabel,
            attribute: .bottom,
            multiplier: 1.0,
            constant: margin)])
        addConstraints([NSLayoutConstraint.init(item: loginButton,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 100)])

        // 5> 登录按钮
        addConstraints([NSLayoutConstraint.init(item: registerButton,
            attribute: .right,
            relatedBy: .equal,
            toItem: tipLabel,
            attribute: .right,
            multiplier: 1.0,
            constant: 0)])
        addConstraints([NSLayoutConstraint.init(item: registerButton,
            attribute: .top,
            relatedBy: .equal,
            toItem: tipLabel,
            attribute: .bottom,
            multiplier: 1.0,
            constant: margin)])
        addConstraints([NSLayoutConstraint.init(item: registerButton,
            attribute: .width,
            relatedBy: .equal,
            toItem: loginButton,
            attribute: .width,
            multiplier: 1.0,
            constant: 0)])
        
        // 6> 遮罩图像
        // views: 定义 VFL 中的控件名称和实际名称映射关系
        // metrics: 定义 VFL 中 () 指定的常数影射关系
        let viewDict = ["maskIconView": maskIconView,"registerButton": registerButton] as [String : Any]
        let metrics = ["spacing": -35]
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[maskIconView]-0-|",
            options: [],
            metrics: nil,
            views: viewDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[maskIconView]-(spacing)-[registerButton]",
            options: [],
            metrics: metrics,
            views: viewDict))

    }
}
