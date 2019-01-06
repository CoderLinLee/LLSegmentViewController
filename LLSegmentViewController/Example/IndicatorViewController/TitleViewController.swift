//
//  TitleViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/27.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit


class TitleViewController: LLSegmentViewController {
    var titleViewStyle = LLSegmentItemTitleViewStyle()
    var indicatorViewWidthChangeStyle:LLIndicatorViewWidthChangeStyle?
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
        for title in titles {
            let ctl = TestViewController()
            ctl.showTableView = false
            ctl.title = title
            ctls.append(ctl)
        }
        reloadViewControllers(ctls:ctls)
    }
    
    func setUpSegmentStyle() {
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        if let indicatorViewWidthChangeStyle = indicatorViewWidthChangeStyle {
            segmentCtlView.indicatorView.widthChangeStyle = indicatorViewWidthChangeStyle
        }
        var ctlViewStyle = LLSegmentCtlViewStyle()
        ctlViewStyle.segmentItemViewClass = LLSegmentItemTitleView.self
        ctlViewStyle.itemViewStyle = titleViewStyle
        segmentCtlView.reloadData(ctlViewStyle: ctlViewStyle)
    }
}
