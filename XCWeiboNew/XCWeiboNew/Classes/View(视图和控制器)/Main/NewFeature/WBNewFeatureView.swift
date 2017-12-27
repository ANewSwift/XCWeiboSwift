//
//  WBNewFeatureView.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/12/26.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit

class WBNewFeatureView: UIView {

    /// 新特性底部的ScrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// 进入微博按钮
    @IBOutlet weak var enterButton: UIButton!
    
    /// 底部滑动指示器
    @IBOutlet weak var pageControl: UIPageControl!
    
    /// 进入微博
    @IBAction func enterStatus(_ sender: Any) {
        removeFromSuperview()
    }
   
    class func newFeatureView() -> WBNewFeatureView {
        
        let nib = UINib.init(nibName: "WBNewFeatureView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBNewFeatureView
        
        // 从 XIB 加载的视图，默认是600 * 600 的
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    override func awakeFromNib() {
        // 如果使用自动布局设置的界面，从 XIB 加载默认是 600 * 600 大小
        // 添加 4 个图像视图
        let count = 4
        let rect = UIScreen.main.bounds
        
        for i in 0..<count {
            let imageName = "new_feature_\(i + 1)"
            let iv = UIImageView.init(image: UIImage.init(named: imageName))
            
            // 设置位置大小
            iv.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            
            // 设置scrollView与imageView的背景色为clear，便于显示底下内容
            iv.backgroundColor = UIColor.clear
            
            scrollView.addSubview(iv)
        }
        
        // 指定scrollView的属性
        scrollView.contentSize = CGSize.init(width: CGFloat(count + 1) * rect.width, height: rect.height)
        
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        // 设置代理
        scrollView.delegate = self
        
        // 隐藏按钮
        enterButton.isHidden = true
    }

}
extension WBNewFeatureView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 滚动到最后一屏，让视图删除
        // 1、获取当前页数
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        // 2、判断是否是最后一页
        if page == scrollView.subviews.count {
            removeFromSuperview()
        }
        
        // 3、如果是倒数第二页，显示按钮
        enterButton.isHidden = (page != scrollView.subviews.count - 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 1、一旦滚动就隐藏按钮(避免最后显示按钮的尴尬)
        enterButton.isHidden = true
        
        // 2、计算当前的偏移量
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        
        // 3、设置分页控件
        pageControl.currentPage = page
        
        // 4、分页控件的隐藏（最后一页）
        pageControl.isHidden = (page == scrollView.subviews.count)
    }
}
