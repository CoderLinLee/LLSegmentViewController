//
//  WebViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2019/3/27.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    public var url = "http://www.baidu.com"
    private let webView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = false
        webView.clipsToBounds = false
        webView.frame = view.bounds
        webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(webView)
        webView.scrollView.clipsToBounds = false
        if let requestUrl =  URL.init(string: url) {
            let request = URLRequest.init(url:requestUrl)
            webView.loadRequest(request)
        }
    }
}
