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
        self.viewCtlContainerColView.isScrollEnabled = false
        
        let segmentCtlFrameHeight:CGFloat = 49
        let containerFrame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - segmentCtlFrameHeight)
        let segmentCtlFrame =  CGRect.init(x: 0, y: containerFrame.maxY, width: view.bounds.width, height: segmentCtlFrameHeight)
        layout(segmentCtlFrame:segmentCtlFrame, containerFrame: containerFrame)
        
        let test1Ctl = factoryCtl(title: "微信", imageName:  "tabbar_mainframe", selectedImageNameStr: "tabbar_mainframeHL")
        test1Ctl.tabBarItem.badgeValue = "10"
        
        let test2Ctl = factoryCtl(title: "通讯录", imageName: "tabbar_contacts", selectedImageNameStr: "tabbar_contactsHL")
        test2Ctl.tabBarItem.badgeValue = nil
        
        let test3Ctl = factoryCtl(title: "发现", imageName: "tabbar_discover1", selectedImageNameStr: "tabbar_discoverHL")
        test3Ctl.tabBarItem.badgeValue = LLSegmentRedBadgeValue
        
        let test4Ctl = factoryCtl(title: "我", imageName: "tabbar_me", selectedImageNameStr: "tabbar_meHL")
        let ctls =  [test1Ctl,test2Ctl,test3Ctl,test4Ctl]
        
        let tabItemViewStyle = LLSegmentItemTabbarViewStyle()
        tabItemViewStyle.unSelectedColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        tabItemViewStyle.selectedColor = UIColor.init(red: 0.7, green: 0.2, blue: 0.1, alpha: 1)
        tabItemViewStyle.selectedTitleScale = 1
        tabItemViewStyle.itemWidth = UIScreen.main.bounds.width/CGFloat(ctls.count)
        tabItemViewStyle.badgeValueLabelOffset = CGPoint.init(x: 2, y: 5)
        
        reloadViewControllers(ctls:ctls)
        let ctlViewStyle = LLSegmentCtlViewStyle(itemSpacing: 0, segmentItemViewClass: LLSegmentItemTabbarView.self, itemViewStyle: tabItemViewStyle, defaultSelectedIndex: 0)
        segmentCtlView.reloadData(ctlViewStyle: ctlViewStyle)
        segmentCtlView.contentOffsetAnimation = false
        segmentCtlView.indicatorView.isHidden = true
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
    }

}


func factoryCtl(title:String,imageName:String,selectedImageNameStr:String) -> UIViewController {
    let test2Ctl = TestViewController()
    test2Ctl.title = title
    test2Ctl.tabBarItem.image = UIImage.init(named: imageName)
    test2Ctl.tabBarItem.selectedImage = UIImage.init(named: selectedImageNameStr)
    return test2Ctl
}
