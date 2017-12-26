//
//  WBOAuthVC.swift
//  XCWeiboNew
//
//  Created by 郝少龙 on 2017/12/24.
//  Copyright © 2017年 郝少龙. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 通过 webView 加载新浪微博授权页面控制器
class WBOAuthVC: UIViewController {
    
    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        
        view.backgroundColor = UIColor.white
        
        // 取消滚动视图 - 新浪微博的服务器，返回的授权页面默认就是手机全屏
        webView.scrollView.isScrollEnabled = false
        
        // 设置代理
        webView.delegate = self
        
        // 设置导航栏标题
        title = "登录新浪微博"
        
        // 设置导航栏左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "自动填充", target: self, action: #selector(autoFill))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 请求用户授权Token
        
        // 加载授权页面
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirectURI)"
        
        // 1> URL 确定要访问的资源
        guard let url = URL.init(string: urlString) else {
            return
        }
        
        /// 2> 建立请求
        let request = URLRequest.init(url: url)
        
        /// 3> 加载请求
        webView.loadRequest(request)
        
    }
    
    @objc fileprivate func close() {
        dismiss(animated: true, completion: nil)
        SVProgressHUD.dismiss(withDelay: 0)
    }

    @objc private func autoFill() {
        
        // 准备 js
        let js = "document.getElementById('userId').value='15733192168';" + "document.getElementById('passwd').value='hao258369.';"
        
        webView.stringByEvaluatingJavaScript(from: js)
    }
    
}

extension WBOAuthVC: UIWebViewDelegate {
    
    /// 开始加载新浪微博服务器的登录界面
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // 确认思路：
        // 1. 如果请求地址包含 http://baidu.com 不加载页面 ／ 否则加载页面
        if request.url?.absoluteString.hasPrefix(WBRedirectURI) == false {
            return true
        }
        print("加载请求 --- \(String(describing: request.url?.absoluteString))")
        
        // 2. 从 http://baidu.com 回调地址的`查询字符串`中查找 `code=`
        //    如果有，授权成功，否则，授权失败
        if request.url?.query?.hasPrefix("code=") == false {
            
            print("取消授权")
            
            close()
            return false
        }
        
        // 3. 从 query 字符串中取出 授权码
        // 代码走到此处，url 中一定有 查询字符串，并且 包含 `code=`
        // code=15be12d79321e474c599210ef637c978
        
        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""
        print("授权码 - \(code)")
        
        // 4、使用授权码获取 Access_Token
        WBNetWorkManager.shared.loadAccessToken(code: code) { (isSuccess) in
            if !isSuccess {
                SVProgressHUD.showError(withStatus: "网络请求失败")
            } else {
                // 下一步做什么？跳转`界面` 通过通知发送登录成功消息
                // 1> 发送通知 - 不关心有没有监听者
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserLoginSuccessNotification), object: nil)
                // 2> 关闭窗口
                self.close()
            }
        }
        
        return true
    }
    
    /// 开始加载其他页面
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    /// 其他页面加载结束
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss(withDelay: 0)
    }
}
