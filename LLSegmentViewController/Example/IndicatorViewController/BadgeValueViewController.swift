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
        self.layoutInfo.segmentControlPositionType = .top(size: CGSize.init(width: UIScreen.main.bounds.width, height: 50),offset:0)
        self.relayoutSubViews()
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
        
        let itemStyle = LLSegmentItemTitleViewStyle()
        itemStyle.selectedTitleScale = 1
        itemStyle.badgeValueLabelOffset = CGPoint.init(x: 0, y: 0)
        var ctlViewStyle = LLSegmentedControlStyle()
        ctlViewStyle.segmentItemViewClass = LLSegmentItemTitleView.self
        ctlViewStyle.itemViewStyle = itemStyle
        segmentCtlView.reloadData(ctlViewStyle: ctlViewStyle)
    }
}


class TestBadgeValueViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1)
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
