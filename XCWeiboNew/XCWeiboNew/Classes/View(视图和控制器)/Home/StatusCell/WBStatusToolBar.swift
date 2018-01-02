//
//  WBStatusToolBar.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/12/28.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit

class WBStatusToolBar: UIView {
    
    var viewModel: WBStatusViewModel? {
        didSet {
            retweetedButton.setTitle(viewModel?.retweetedStr, for: .normal)
            commentButton.setTitle(viewModel?.commentStr, for: .normal)
            likeButton.setTitle(viewModel?.likeStr, for: .normal)
        }
    }
    
    /// 转发按钮
    @IBOutlet weak var retweetedButton: UIButton!
    /// 评论按钮
    @IBOutlet weak var commentButton: UIButton!
    /// 点赞按钮
    @IBOutlet weak var likeButton: UIButton!
}
