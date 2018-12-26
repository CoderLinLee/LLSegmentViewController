//
//  LLIndicatorView.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/18.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit

class LLIndicatorViewStyle {
    var isEqualToItemWidth = false
}

public class LLIndicatorView: UIView {
    var indicatorViewStyle = LLIndicatorViewStyle()
    func reloadIndicatorViewLayout(segMegmentCtlView: LLSegmentCtlView, leftItemView: LLSegmentCtlItemView,rightItemView:LLSegmentCtlItemView){
        if indicatorViewStyle.isEqualToItemWidth {
            let leftItemWidth = leftItemView.bounds.width
            let rightItemWidth = rightItemView.bounds.width
            let width = interpolationFrom(from: leftItemWidth, to: rightItemWidth, percent: rightItemView.percent)
            
            var selfBounds = self.bounds
            selfBounds.size.width = width
            self.bounds = selfBounds
        }
    }
}
