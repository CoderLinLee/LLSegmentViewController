//
//  NestViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2019/1/2.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

class NestViewController: LLSegmentViewController {
    let segmentItemWidth:CGFloat = 60
    let segmentViewHeight:CGFloat = 30
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutContentView()
        loadCtls()
        setUpSegmentStyle()
    }
    
    func layoutContentView() {
        let segmentCtlFrame = CGRect.init(x: 0, y: 0, width: segmentItemWidth*2, height: segmentViewHeight)
        let containerFrame = view.bounds
        layout(segmentCtlFrame:segmentCtlFrame, containerFrame: containerFrame)
    }
    
    func loadCtls() {
        let test1Ctl = NestSubViewController()
        test1Ctl.title = "主题一"
        
        let test2Ctl = NestSubViewController()
        test2Ctl.title = "主题二"
        let ctls =  [test1Ctl,test2Ctl]
        reloadViewControllers(ctls:ctls)
    }
    
    func setUpSegmentStyle() {
        let titleViewStyle = LLSegmentItemTitleViewStyle()
        titleViewStyle.selectedColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        titleViewStyle.unSelectedColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        titleViewStyle.itemWidth = segmentItemWidth
        titleViewStyle.selectedTitleScale = 1
        
        segmentCtlView.indicatorView.widthChangeStyle = .stationary(baseWidth: segmentItemWidth)
        segmentCtlView.indicatorView.centerYGradientStyle = .center
        segmentCtlView.indicatorView.bounds = CGRect.init(x: 0, y: 0, width: segmentItemWidth, height: segmentViewHeight)
        segmentCtlView.indicatorView.layer.cornerRadius = segmentViewHeight/2
        segmentCtlView.indicatorView.backgroundColor = UIColor.red
        var ctlViewStyle = LLSegmentedControlStyle()
        ctlViewStyle.segmentItemViewClass = LLSegmentItemTitleView.self
        ctlViewStyle.itemViewStyle = titleViewStyle
        segmentCtlView.reloadData(ctlViewStyle: ctlViewStyle)
        
        segmentCtlView.layer.cornerRadius = segmentViewHeight/2
        segmentCtlView.layer.borderColor = UIColor.red.cgColor
        segmentCtlView.layer.borderWidth = 1
        self.navigationItem.titleView = segmentCtlView
    }
}


class NestSubViewController: LLSegmentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

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
        test1Ctl.showTableView = false
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
