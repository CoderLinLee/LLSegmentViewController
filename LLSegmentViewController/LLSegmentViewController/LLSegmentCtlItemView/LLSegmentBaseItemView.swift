//
//  LLSegmentCtlItemView.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/20.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit

let LLSegmentAutomaticDimension:CGFloat = -1
public class LLSegmentCtlItemViewStyle {
    var itemWidth:CGFloat = LLSegmentAutomaticDimension
}


public class LLSegmentBaseItemView: UIView {
    var isScrollerTarget = false
    var contentOffsetOnRight = false

    var separatorView = UIView()
    public override required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var associateViewCtl:UIViewController?
    var percent:CGFloat = 0
    
    //override for subClass
    func percentChange(percent:CGFloat){ self.percent = percent}
    func itemWidth() ->CGFloat { return 0 }
    func setSegmentItemViewStyle(itemViewStyle:LLSegmentCtlItemViewStyle) {}
}
