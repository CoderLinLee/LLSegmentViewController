//
//  LLMsgViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/18.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit

class LLMsgViewController: LLSegmentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "消息"
        layoutContentView()
        loadCtls()
        setUpSegmentStyle()
     
    }
    
    func layoutContentView() {
        let segmentCtlFrame =  CGRect.init(x: 0, y: 64, width: view.bounds.width, height: 50)
        let containerFrame = CGRect.init(x: 0, y: segmentCtlFrame.maxY, width: view.bounds.width, height: view.bounds.height - segmentCtlFrame.maxY)
        layout(segmentCtlFrame:segmentCtlFrame, containerFrame: containerFrame)
    }
    
    func loadCtls() {
        let test1Ctl = TestViewController()
        test1Ctl.title = "动态"
        test1Ctl.tabBarItem.badgeValue = LLSegmentRedBadgeValue
        
        let test2Ctl = TestViewController()
        test2Ctl.showTableView = false
        test2Ctl.title = "通知"
        test2Ctl.tabBarItem.badgeValue = nil
        let ctls =  [test1Ctl,test2Ctl]
        reloadViewControllers(ctls:ctls)
    }
    
    func setUpSegmentStyle() {
        let titleViewStyle = LLSegmentItemTitleViewStyle()
        titleViewStyle.selectedColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        titleViewStyle.unSelectedColor = UIColor.init(red: 0.2, green: 0.4, blue: 0.8, alpha: 1)
        titleViewStyle.itemWidth = UIScreen.main.bounds.width/CGFloat(ctls.count)
        
        segmentCtlView.indicatorView.widthChangeStyle = .stationary(baseWidth: 30)
        var ctlViewStyle = LLSegmentedControlStyle()
        ctlViewStyle.segmentItemViewClass = LLSegmentItemTitleView.self
        ctlViewStyle.itemViewStyle = titleViewStyle
        segmentCtlView.reloadData(ctlViewStyle: ctlViewStyle)
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
    }
}

