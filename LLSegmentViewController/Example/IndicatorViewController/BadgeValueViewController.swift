//
//  BadgeValueViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2019/1/5.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

class BadgeValueViewController: LLSegmentViewController {

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
        let titles = ["螃蟹", "麻辣小龙虾", "苹果", "营养胡萝卜", "葡萄", "美味西瓜", "香蕉", "香甜菠萝", "鸡肉", "鱼", "海星"];
        var ctls = [UIViewController]()
        for (index,title) in titles.enumerated() {
            let ctl = TestBadgeValueViewController()
            ctl.title = title
            ctl.tabBarItem.badgeValue = index%3 == 0 ? LLSegmentRedBadgeValue : "\(index)"
            ctls.append(ctl)
        }
        reloadViewControllers(ctls:ctls)
    }
    
    func setUpSegmentStyle() {
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        segmentCtlView.indicatorView.widthChangeStyle = .equalToItemWidth(margin:0)
        
        let titleStyle = LLSegmentItemTitleViewStyle()
        titleStyle.selectedTitleScale = 1
        var ctlViewStyle = LLSegmentCtlViewStyle()
        ctlViewStyle.segmentItemViewClass = LLSegmentItemBadgeTitleView.self
        ctlViewStyle.itemViewStyle = titleStyle
        segmentCtlView.reloadData(ctlViewStyle: ctlViewStyle)
    }
}


class TestBadgeValueViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LLRandomRGB()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if self.tabBarItem.badgeValue == LLSegmentRedBadgeValue {
            self.tabBarItem.badgeValue = nil
        }else{
            let badgeValueStr = self.tabBarItem.badgeValue ?? ""
            let badgeValue = (Int(badgeValueStr) ?? 0) + 1
            self.tabBarItem.badgeValue = "\(badgeValue)"
        }
    }
}
