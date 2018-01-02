//
//  WBStatusPictureView.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/12/28.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit

class WBStatusPictureView: UIView {
    
    var viewModel: WBStatusViewModel? {
        
        didSet {
            calcViewSize()
            
            urls = viewModel?.picURLs
        }
    }
    
    /// 根据视图模型的配图视图大小，调整显示内容
    private func calcViewSize() {
        
        // 处理宽度
        // 1> 单图，根据配图视图的大小，修改 subviews[0] 的宽高
        if viewModel?.picURLs?.count == 1 {
            let viewSize = viewModel?.pictureViewSize ?? CGSize.init()
            
            // a) 获取第0个图像视图
            let v = subviews[0]
            v.frame = CGRect.init(x: 0,
                                  y: WBStatusPictureViewOutterMargin,
                                  width: viewSize.width,
                                  height: viewSize.height - WBStatusPictureViewOutterMargin)
            
            
        } else {
            // 2> 多图(无图)，回复 subview[0] 的宽高，保证九宫格布局的完整
            
            let v = subviews[0]
            v.frame = CGRect.init(x: 0,
                                  y: WBStatusPictureViewOutterMargin,
                                  width: WBStatusPictureItemWidth,
                                  height: WBStatusPictureItemWidth)
            
        }
        
        // 修改高度约束
        heightCons.constant = viewModel?.pictureViewSize.height ?? 0
    }
    
    /// 循环创建好的9个imageView并设置url及显示imageView
    private var urls: [WBStatusPicture]? {
        didSet {
            
            // 1、隐藏所有的 imageView
            for v in subviews {
                v.isHidden = true
            }
            
            // 2. 遍历 urls 数组，顺序设置图像
            var index = 0
            for url in urls ?? [] {
                
                let iv = subviews[index] as! UIImageView
                
                // 处理 4 张图像
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                
                // 设置图像
                iv.cz_setImage(urlString: url.thumbnail_pic, placeholderImage: nil)
                
                // 显示图像
                iv.isHidden = false
                
                index += 1
            }
            
        }
    }

    /// 配图视图的高度约束
    @IBOutlet weak var heightCons: NSLayoutConstraint!

    override func awakeFromNib() {
        setupUI()
    }
}

extension WBStatusPictureView {
    
    // 1. Cell 中所有的控件都是提前准备好
    // 2. 设置的时候，根据数据决定是否显示
    // 3. 不要动态创建控件
    
    /// 循环创建imageView并设置图片位置
    fileprivate func setupUI(){
        
        // 设置背景颜色
        backgroundColor = superview?.backgroundColor
//        // 超出边界的内容不显示
//        clipsToBounds = true
        
        let count = 3
        let rect = CGRect.init(x: 0,
                               y: WBStatusPictureViewOutterMargin,
                               width: WBStatusPictureItemWidth,
                               height: WBStatusPictureItemWidth)
        
        for i in 0..<count * count {
            
            let iv = UIImageView.init()
            iv.backgroundColor = UIColor.yellow
            // 设置 contentMode
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            
            // 行
            let row = CGFloat.init(i / count)
            // 列
            let col = CGFloat.init(i % count)
            
            let xOffset = col * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            let yOffset = row * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            
            addSubview(iv)
            
        }
        
        
    }
}
