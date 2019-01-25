//
//  TopRefreshViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2019/1/25.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

class TopRefreshViewController: PersonDetailViewController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCustomNavBar()
        customNavBar.alpha = 0
        lufeiImageView.contentMode = .scaleToFill
        
        containerScrView.refreshControl = UIRefreshControl(frame: CGRect.init(x: 0, y: -containerScrView.contentInset.top - 44, width: 44, height: 44))
        containerScrView.refreshControl?.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
        containerScrView.refreshControl?.tintColor = UIColor.black
    }
    
    //重写方法，不让图片缩放
    override func scrollView(scrollView: LLContainerScrollView, dragTop offsetY: CGFloat) {
        
    }
    
    override func scrollView(scrollView: LLContainerScrollView, dragToMinimumHeight progress: CGFloat) {
        customNavBar.alpha = progress
    }
    
    @objc func refreshControlAction(){
        if containerScrView.refreshControl?.isRefreshing == true {
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute:{ [weak self] in
                self?.containerScrView.refreshControl?.endRefreshing()
            })
        }
    }
}



extension TopRefreshViewController{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}
