
//
//  WeiBoCommon.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/12/24.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import Foundation

// MARK: - 获取access_token,应用程序信息
/// 应用程序 ID
let WBAppKey = "1220555723"
/// 应用程序加密信息(开发者可以申请修改)
let WBAppSecret = "06c59941b189aedeb0a3c4837039cc24"
/// 回调地址 - 登录完成调转的 URL，参数以 get 形式拼接
let WBRedirectURI = "http://www.baidu.com"


// MARK: - 全局通知定义
/// 用户需要登录通知
let WBUserShouldLoginNotification = "WBUserShouldLoginNotification"
/// 用户登录成功通知
let WBUserLoginSuccessNotification = "WBUserLoginSuccessNotification"

// MARK: - 微博配图视图常量
/// 配图视图外侧的间距
let WBStatusPictureViewOutterMargin = CGFloat.init(12)
/// 配图视图内部图像视图的间距
let WBStatusPictureViewInnerMargin = CGFloat.init(3)
/// 配图视图的宽度
let WBStatusPictureViewWidth = UIScreen.cz_screenWidth() - 2 * WBStatusPictureViewOutterMargin
/// 每个 Item 图片默认的宽度
let WBStatusPictureItemWidth = (WBStatusPictureViewWidth - 2 * WBStatusPictureViewInnerMargin) / 3

