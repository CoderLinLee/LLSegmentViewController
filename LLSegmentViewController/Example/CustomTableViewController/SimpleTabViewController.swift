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
        self.title = "简单样式"
        self.containerScrollerView.isScrollEnabled = false
        
        let segmentCtlFrameHeight:CGFloat = 49
        let containerFrame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - segmentCtlFrameHeight)
        let segmentCtlFrame =  CGRect.init(x: 0, y: containerFrame.maxY, width: view.bounds.width, height: segmentCtlFrameHeight)
        layout(segmentCtlFrame:segmentCtlFrame, containerFrame: containerFrame)
        
        let test1Ctl = factoryCtl(title: "微信", imageName:  "tabbar-icon-board-normal", selectedImageNameStr: "tabbar-icon-board-selected")
        test1Ctl.tabBarItem.badgeValue = LLSegmentRedBadgeValue
        
        let test2Ctl = factoryCtl(title: "通讯录", imageName: "tabbar-icon-college-normal", selectedImageNameStr: "tabbar-icon-college-selected")
        test2Ctl.tabBarItem.badgeValue = nil
        
        let test3Ctl = factoryCtl(title: "发现", imageName: "tabbar-icon-discover-normal", selectedImageNameStr: "tabbar-icon-discover-selected")
        test3Ctl.tabBarItem.badgeValue = LLSegmentRedBadgeValue
        
        let test4Ctl = factoryCtl(title: "我", imageName: "tabbar-icon-personal-normal", selectedImageNameStr: "tabbar-icon-personal-selected")
        let ctls =  [test1Ctl,test2Ctl,test3Ctl,test4Ctl]
        
        let tabItemViewStyle = LLSegmentItemTabbarViewStyle()
        tabItemViewStyle.selectedColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        tabItemViewStyle.unSelectedColor = UIColor.init(red: 0.7, green: 0.2, blue: 0.1, alpha: 1)
        tabItemViewStyle.selectedTitleScale = 1
        tabItemViewStyle.itemWidth = UIScreen.main.bounds.width/CGFloat(ctls.count)
        tabItemViewStyle.titleBottomGap = 5
        tabItemViewStyle.titleImgeGap = 2
        
        reloadContents(ctlModels:ctls)
        segmentCtlView.reloadData(itemSpacing: 0,segmentItemViewClass:LLSegmentItemTabbarView.self,itemViewStyle: tabItemViewStyle)
        segmentCtlView.contentOffsetAnimation = false
    }
    func factoryCtl(title:String,imageName:String,selectedImageNameStr:String) -> UIViewController {
        let test2Ctl = TestViewController()
        test2Ctl.title = title
        test2Ctl.tabBarItem.image = UIImage.init(named: imageName)
        test2Ctl.tabBarItem.selectedImage = UIImage.init(named: selectedImageNameStr)
        return test2Ctl
    }

}
