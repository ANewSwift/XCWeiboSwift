//
//  WBStatusCell.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/12/27.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit

class WBStatusCell: UITableViewCell {
    
    /// 单条微博视图模型
    var viewModel: WBStatusViewModel? {
        didSet {
            
            /// 会员图标
            memberIconView.image = viewModel?.memberIcon
            /// 认证图标
            vipIconView.image = viewModel?.vipIcon
            /// 微博正文文本
            statusLabel.text = viewModel?.status.text
            /// 用户昵称
            nameLabel.text = viewModel?.status.user?.screen_name
            /// 用户头像
            iconView.cz_setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage.init(named: "avatar_default_big"), isAvatar: true)
            let prefix = viewModel?.status.retweeted_status?.user?.screen_name ?? ""
            let retweetedText = viewModel?.status.retweeted_status?.text ?? ""
            /// 转发微博的正文
            retweetedLabel?.text = "@" + prefix + ": " + retweetedText
            /// 配图视图
            pictureView.viewModel = viewModel
            /// 底部工具条
            statusToolBar.viewModel = viewModel
        }
    }
    
    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    /// 姓名
    @IBOutlet weak var nameLabel: UILabel!
    /// 会员图标
    @IBOutlet weak var memberIconView: UIImageView!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    /// 认证图标
    @IBOutlet weak var vipIconView: UIImageView!
    /// 微博正文
    @IBOutlet weak var statusLabel: UILabel!
    /// 微博底部的工具条
    @IBOutlet weak var statusToolBar: WBStatusToolBar!
    /// 配图视图
    @IBOutlet weak var pictureView: WBStatusPictureView!
    /// 被转发微博的正文
    @IBOutlet weak var retweetedLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 离屏渲染 - 异步绘制
        self.layer.drawsAsynchronously = true
        
        // 栅格化 - 异步绘制之后，会生成一张独立的图像，cell在屏幕上滚动的时候，本质上滚动的是这张图片
        // cell 优化，要尽量减少图层的数量，相当于就只有一层！
        // 停止滚动之后，可以接收监听
        self.layer.shouldRasterize = true
        
        // 使用 `栅格化` 必须注意指定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
        
        
        
    }

}
