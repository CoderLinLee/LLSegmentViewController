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
        self.layoutInfo.segmentControlPositionType = .top(size: CGSize.init(width: UIScreen.main.bounds.width, height: 50))
        self.relayoutSubViews()
    }
    
    func loadCtls() {
        let test1Ctl = TestViewController()
        test1Ctl.title = "动态"
        test1Ctl.tabBarItem.badgeValue = LLSegmentRedBadgeValue
        
        let test2Ctl = TestViewController()
        test2Ctl.showTableView = false
        test2Ctl.title = "通知"
        test2Ctl.tabBarItem.badgeValue = nil
        
        let test3Ctl = TestViewController()
        test3Ctl.showTableView = false
        test3Ctl.title = "消息"
        test3Ctl.tabBarItem.badgeValue = nil
        let ctls =  [test1Ctl,test2Ctl,test3Ctl]
        reloadViewControllers(ctls:ctls)
    }
    
    func setUpSegmentStyle() {
        let itemStyle = LLSegmentItemTitleViewStyle()
        itemStyle.selectedColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        itemStyle.unSelectedColor = UIColor.init(red: 0.2, green: 0.4, blue: 0.8, alpha: 1)
        itemStyle.itemWidth = UIScreen.main.bounds.width/CGFloat(ctls.count)
        itemStyle.badgeValueLabelOffset = CGPoint.zero
        itemStyle.selectedStyle = .mid
        
        segmentCtlView.indicatorView.widthChangeStyle = .stationary(baseWidth: 30)
        var ctlViewStyle = LLSegmentedControlStyle()
        ctlViewStyle.segmentItemViewClass = LLSegmentItemTitleView.self
        ctlViewStyle.itemViewStyle = itemStyle
        segmentCtlView.ctlViewStyle = ctlViewStyle
        segmentCtlView.reloadData(ctlViewStyle: ctlViewStyle)
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
    }
}

