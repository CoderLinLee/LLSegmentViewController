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
        self.viewCtlContainerColView.isScrollEnabled = false
        layoutSegmentView()
        loadCtls()
        setUpSegmentStyle()
        setUpAddBtn()
    }
    
    func layoutSegmentView() {
        let segmentCtlFrameHeight:CGFloat = 49
        let containerFrame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - segmentCtlFrameHeight)
        let segmentCtlFrame =  CGRect.init(x: 0, y: containerFrame.maxY, width: view.bounds.width, height: segmentCtlFrameHeight)
        layout(segmentCtlFrame:segmentCtlFrame, containerFrame: containerFrame)
    }
    
    func loadCtls() {
        let test1Ctl = factoryCtl(title: "首页", imageName:  "tabbar_home", selectedImageNameStr: "tabbar_home_selected")
        test1Ctl.tabBarItem.badgeValue = "10"
        
        let test2Ctl = factoryCtl(title: "消息", imageName: "tabbar_message_center", selectedImageNameStr: "tabbar_message_center_selected")
        
        let test3Ctl = factoryCtl(title: "发现", imageName: "tabbar_discover", selectedImageNameStr: "tabbar_discover_selected")
        test3Ctl.tabBarItem.badgeValue = LLSegmentRedBadgeValue
        
        let test4Ctl = factoryCtl(title: "我的", imageName: "tabbar_profile", selectedImageNameStr: "tabbar_profile_selected")
        
        let ctls =  [test1Ctl,test2Ctl,test3Ctl,test4Ctl]
        reloadViewControllers(ctls:ctls)
    }
    
    func setUpSegmentStyle() {
        let itemWidth = UIScreen.main.bounds.width/CGFloat(ctls.count+1)
        let tabItemViewStyle = LLSegmentItemTabbarViewStyle()
        tabItemViewStyle.unSelectedColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        tabItemViewStyle.selectedColor = UIColor.init(red: 0.7, green: 0.2, blue: 0.1, alpha: 1)
        tabItemViewStyle.selectedTitleScale = 1
        tabItemViewStyle.itemWidth = itemWidth
        tabItemViewStyle.titleImgeGap = -2 //因为图片有空白的内容
        tabItemViewStyle.titleBottomGap = 3
        tabItemViewStyle.badgeValueLabelOffset = CGPoint.init(x: -3, y: 10)
        
        segmentCtlView.delegate = self
        var ctlViewStyle = LLSegmentedControlStyle()
        ctlViewStyle.segmentItemViewClass = LLSegmentItemTabbarView.self
        ctlViewStyle.itemViewStyle = tabItemViewStyle
        segmentCtlView.reloadData(ctlViewStyle: ctlViewStyle)
        segmentCtlView.clickAnimation = false
        segmentCtlView.indicatorView.isHidden = true
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
    }
}

extension SinaViewController {
    func setUpAddBtn() {
        let itemWidth = UIScreen.main.bounds.width/CGFloat(ctls.count+1)
        let addBtn = UIButton(type: .custom)
        addBtn.setBackgroundImage(#imageLiteral(resourceName: "tabbar_compose_button"), for: .normal)
        addBtn.setBackgroundImage(#imageLiteral(resourceName: "tabbar_compose_button_highlighted"), for: .highlighted)
        addBtn.setImage(#imageLiteral(resourceName: "tabbar_compose_icon_add"), for: .normal)
        addBtn.setImage(#imageLiteral(resourceName: "tabbar_compose_icon_add_highlighted"), for: .highlighted)
        
        addBtn.bounds = CGRect.init(x: 0, y: 0, width: itemWidth, height: segmentCtlView.frame.height)
        addBtn.center = CGPoint.init(x: segmentCtlView.frame.width/2, y: segmentCtlView.frame.height/2)
        segmentCtlView.addSubview(addBtn)
        addBtn.addTarget(self, action: #selector(addBtnClick), for: .touchUpInside)
    }
    
    @objc func addBtnClick(){
        
    }
}


extension SinaViewController:LLSegmentedControlDelegate{
    func segMegmentCtlView(segMegmentCtlView: LLSegmentedControl, itemView: LLSegmentBaseItemView, extraGapAtIndex: NSInteger) -> CGFloat {
        if extraGapAtIndex == 2 {
            return UIScreen.main.bounds.width/CGFloat(ctls.count+1)
        }
        return 0
    }
    
    func segMegmentCtlView(segMegmentCtlView: LLSegmentedControl, clickItemAt sourceItemView: LLSegmentBaseItemView, to destinationItemView: LLSegmentBaseItemView) {
        let keyAnimation = CAKeyframeAnimation.init(keyPath: "transform.scale")
        keyAnimation.duration = 0.25;
        keyAnimation.values = [1.0,0.4,1.0];
        //动画均匀进行
        keyAnimation.calculationMode = kCAAnimationCubicPaced;
        //将帧动画添加到当前图层
        destinationItemView.layer.add(keyAnimation, forKey: "keyAnimation")
    }
    
    func segMegmentCtlView(segMegmentCtlView: LLSegmentedControl, sourceItemView: LLSegmentBaseItemView, shouldChangeTo destinationItemView: LLSegmentBaseItemView) -> Bool {
        if destinationItemView.index == 3 {
            let loginCtl = TestViewController()
            loginCtl.showTableView = false
            loginCtl.title = "请先登录"
            self.navigationController?.pushViewController(loginCtl, animated: true)
            return false
        }
        return true
    }
}
