//
//  CustomItemViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2019/1/5.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit


class CustomItemViewController: TitleViewController {
    var customItemViewClass = LLSegmentItemTitleView.self
    override func initSegmentCtlView() {
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        if let indicatorViewWidthChangeStyle = indicatorViewWidthChangeStyle {
            segmentCtlView.indicatorView.widthChangeStyle = indicatorViewWidthChangeStyle
        }
        let ctlViewStyle = LLSegmentCtlViewStyle(itemSpacing: 0, segmentItemViewClass: BackgroundColorGradientItemView.self, itemViewStyle: titleViewStyle, defaultSelectedIndex: 0)
        segmentCtlView.reloadData(ctlViewStyle: ctlViewStyle)
    }
}
