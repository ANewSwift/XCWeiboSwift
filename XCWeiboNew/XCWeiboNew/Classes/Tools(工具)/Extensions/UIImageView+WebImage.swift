
//
//  UIImageView+WebImage.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/12/27.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import SDWebImage

extension UIImageView {
    /// 隔离 SDWebImage 设置图像函数
    func cz_setImage(urlString: String?,placeholderImage: UIImage?,isAvatar: Bool = false){
        
        // 处理 URL
        guard let urlString = urlString,
            let url = URL.init(string: urlString) else {
                // 设置占位图像
                image = placeholderImage
                return
                
            }
        
        // 可选项只是用在 Swift，OC 有的时候用 ! 同样可以传入 nil
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) { [weak self] (image, _, _, _) in
            // 完成回调 - 判断是否是头像
            
            if isAvatar {
                self?.image = image?.cz_avatarImage(size: self?.bounds.size)
            }
        }
    }
}
