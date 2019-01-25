//
//  NavHidenChangeLayoutViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2019/1/25.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

class NavHidenChangeLayoutViewController: TitleViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        closeAutomaticallyAdjusts()

        var segmentControlFrame = self.segmentCtlView.frame
        var pageViewFrame = self.pageView.frame
        segmentControlFrame.origin.y = mTopHeight()
        pageViewFrame.origin.y = segmentControlFrame.maxY
        pageViewFrame.size.height = UIScreen.main.bounds.height - segmentControlFrame.maxY
        self.relayoutSegmentControlAndPageViewFrame(segmentControlFrame: segmentControlFrame, pageViewFrame: pageViewFrame)
    }
    
    override func loadCtls() {
        let titles = ["螃蟹", "麻辣小龙虾", "苹果", "营养胡萝卜", "葡萄", "美味西瓜", "香蕉", "香甜菠萝", "鸡肉", "鱼", "海星"];
        var ctls = [UIViewController]()
        for title in titles {
            let ctl = TestViewController()
            ctl.showTableView = true
            ctl.scrollViewEndDragBlock = { (isScrollToTop) in
                
                var segmentControlFrame = self.segmentCtlView.frame
                var pageViewFrame = self.pageView.frame
                if isScrollToTop {
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                    segmentControlFrame.origin.y = 0
                }else{
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    segmentControlFrame.origin.y = mTopHeight()
                }
                pageViewFrame.origin.y = segmentControlFrame.maxY
                pageViewFrame.size.height = UIScreen.main.bounds.height - segmentControlFrame.maxY
                UIView.animate(withDuration: 0.25, animations: {
                    self.relayoutSegmentControlAndPageViewFrame(segmentControlFrame: segmentControlFrame, pageViewFrame: pageViewFrame)
                })
            }
            ctl.title = title
            ctls.append(ctl)
        }
        reloadViewControllers(ctls:ctls)
    }

}
