//
//  simpleTabViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/26.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit

class SimpleTabViewController: LLSegmentViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageView.isScrollEnabled = false
        
        layoutContentView()
        loadCtls()
        setUpSegmentStyle()
    }
    
    func layoutContentView() {
        self.layoutInfo.segmentControlPositionType = .bottom(size: CGSize.init(width: UIScreen.main.bounds.width, height: 50),offset:0)
        self.relayoutSubViews()
    }
    
    func loadCtls() {
        let test1Ctl = factoryCtl(title: "微信", imageName:  "tabbar_mainframe", selectedImageNameStr: "tabbar_mainframeHL")
        test1Ctl.tabBarItem.badgeValue = "10"
        
        let test2Ctl = factoryCtl(title: "通讯录", imageName: "tabbar_contacts", selectedImageNameStr: "tabbar_contactsHL")
        test2Ctl.tabBarItem.badgeValue = nil
        
        let test3Ctl = factoryCtl(title: "发现", imageName: "tabbar_discover1", selectedImageNameStr: "tabbar_discoverHL")
        test3Ctl.tabBarItem.badgeValue = LLSegmentRedBadgeValue
        
        let test4Ctl = factoryCtl(title: "我", imageName: "tabbar_me", selectedImageNameStr: "tabbar_meHL")
        let ctls =  [test1Ctl,test2Ctl,test3Ctl,test4Ctl]
        reloadViewControllers(ctls:ctls)
    }
    
    func setUpSegmentStyle() {
        let tabItemStyle = LLSegmentItemTabbarViewStyle()
        tabItemStyle.unSelectedColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        tabItemStyle.selectedColor = UIColor.init(red: 0.7, green: 0.2, blue: 0.1, alpha: 1)
        tabItemStyle.itemWidth = UIScreen.main.bounds.width/CGFloat(ctls.count)
        tabItemStyle.badgeValueLabelOffset = CGPoint.init(x: 2, y: 5)
        
        var segmentCtlStyle = LLSegmentedControlStyle()
        segmentCtlStyle.segmentItemViewClass = LLSegmentItemTabbarView.self
        segmentCtlStyle.itemViewStyle = tabItemStyle
        segmentCtlView.reloadData(ctlViewStyle: segmentCtlStyle)
        segmentCtlView.clickAnimation = false
        segmentCtlView.indicatorView.isHidden = true
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
    }
}


