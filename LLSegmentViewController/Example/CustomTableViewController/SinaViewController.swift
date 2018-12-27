//
//  SinaViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/27.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit

class SinaViewController: LLSegmentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerScrollerView.isScrollEnabled = false
        
        let segmentCtlFrameHeight:CGFloat = 49
        let containerFrame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - segmentCtlFrameHeight)
        let segmentCtlFrame =  CGRect.init(x: 0, y: containerFrame.maxY, width: view.bounds.width, height: segmentCtlFrameHeight)
        layout(segmentCtlFrame:segmentCtlFrame, containerFrame: containerFrame)
        
        let test1Ctl = factoryCtl(title: "微信", imageName:  "tabbar-icon-board-normal", selectedImageNameStr: "tabbar-icon-board-selected")
        test1Ctl.tabBarItem.badgeValue = "10"
        
        let test2Ctl = factoryCtl(title: "通讯录", imageName: "tabbar-icon-college-normal", selectedImageNameStr: "tabbar-icon-college-selected")
        test2Ctl.tabBarItem.badgeValue = nil
        
        let test3Ctl = factoryCtl(title: "发现", imageName: "tabbar-icon-discover-normal", selectedImageNameStr: "tabbar-icon-discover-selected")
        test3Ctl.tabBarItem.badgeValue = LLSegmentRedBadgeValue
        
        let test4Ctl = factoryCtl(title: "我", imageName: "tabbar-icon-personal-normal", selectedImageNameStr: "tabbar-icon-personal-selected")
        let ctls =  [test1Ctl,test2Ctl,test3Ctl,test4Ctl]
        let itemWidth = UIScreen.main.bounds.width/CGFloat(ctls.count+1)
        let tabItemViewStyle = LLSegmentItemTabbarViewStyle()
        tabItemViewStyle.selectedColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        tabItemViewStyle.unSelectedColor = UIColor.init(red: 0.7, green: 0.2, blue: 0.1, alpha: 1)
        tabItemViewStyle.selectedTitleScale = 1
        tabItemViewStyle.itemWidth = UIScreen.main.bounds.width/CGFloat(ctls.count+1)
        
        reloadContents(ctls:ctls)
        segmentCtlView.delegate = self
        segmentCtlView.reloadData(itemSpacing: 0,segmentItemViewClass:LLSegmentItemTabbarView.self,itemViewStyle: tabItemViewStyle)
        segmentCtlView.contentOffsetAnimation = false
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        
        let addBtn = UIButton(type: .custom)
        addBtn.setTitle("添加", for: .normal)
        addBtn.backgroundColor = UIColor.lightGray
        addBtn.bounds = CGRect.init(x: 0, y: 0, width: itemWidth, height: segmentCtlView.frame.height)
        addBtn.center = CGPoint.init(x: segmentCtlView.frame.width/2, y: segmentCtlView.frame.height/2)
        segmentCtlView.addSubview(addBtn)
        addBtn.addTarget(self, action: #selector(addBtnClick), for: .touchUpInside)
    }
    @objc func addBtnClick(){
        
    }
}


extension SinaViewController:LLSegmentCtlViewDelegate{
    func segMegmentCtlView(segMegmentCtlView: LLSegmentCtlView, itemView: LLSegmentCtlItemView, extraGapAtIndex: NSInteger) -> CGFloat {
        if extraGapAtIndex == 2 {
            return UIScreen.main.bounds.width/CGFloat(ctls.count+1)
        }
        return 0
    }
    func segMegmentCtlView(segMegmentCtlView: LLSegmentCtlView, itemView: LLSegmentCtlItemView, selectedAt: NSInteger) {
        let keyAnimation = CAKeyframeAnimation.init(keyPath: "transform.scale")
        keyAnimation.duration = 0.25;
        keyAnimation.values = [1.0,0.8,1.0];
        //动画均匀进行
        keyAnimation.calculationMode = kCAAnimationCubicPaced;
        //将帧动画添加到当前图层
        itemView.layer.add(keyAnimation, forKey: "keyAnimation")
       
    }
}
