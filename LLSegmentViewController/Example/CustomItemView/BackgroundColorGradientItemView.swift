//
//  BackgroundColorGradientItemView.swift
//  LLSegmentViewController
//
//  Created by lilin on 2019/1/5.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

class BackgroundColorGradientItemView: LLSegmentItemTitleView {
    let finalColor = UIColor.init(red: 176/255.0, green: 224/255.0, blue: 230/255.0, alpha: 1)
    let whiteColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)

    override func percentChange(percent: CGFloat) {
        super.percentChange(percent: percent)
        self.backgroundColor = interpolationColorFrom(fromColor: whiteColor, toColor: finalColor, percent: percent)
    }
}


//MARK:-自定义的使用
class BackgroundColorGradientItemViewController: TitleViewController {
    override func setUpSegmentStyle() {
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        if let indicatorViewWidthChangeStyle = indicatorViewWidthChangeStyle {
            segmentCtlView.indicatorView.widthChangeStyle = indicatorViewWidthChangeStyle
        }
        var ctlViewStyle = LLSegmentedControlStyle()
        ctlViewStyle.segmentItemViewClass = BackgroundColorGradientItemView.self
        ctlViewStyle.itemViewStyle = titleViewStyle
        segmentCtlView.reloadData(ctlViewStyle: ctlViewStyle)
    }
}
