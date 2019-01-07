//
//  LLSegmentCtlItemView.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/20.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit

public let LLSegmentAutomaticDimension:CGFloat = -1
open class LLSegmentCtlItemViewStyle:NSObject {
    public var itemWidth:CGFloat = LLSegmentAutomaticDimension
}


open class LLSegmentBaseItemView: UIView {
    public var isScrollerTarget = false
    public var contentOffsetOnRight = false
    public var index = 0

    public override required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public var associateViewCtl:UIViewController?
    public var percent:CGFloat = 0
    
    //override for subClass
    public func percentChange(percent:CGFloat){ self.percent = percent}
    public func itemWidth() ->CGFloat { return 0 }
    public func setSegmentItemViewStyle(itemViewStyle:LLSegmentCtlItemViewStyle) {}
}
