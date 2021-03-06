//
//  LLSegmentBadgeItemView.swift
//  LLSegmentViewController
//
//  Created by apple on 2019/1/12.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

public class LLSegmentItemBadgeViewStyle:LLSegmentItemViewStyle {
    /*数字或红点Label.center偏离图片右上角*/
    public var badgeValueLabelOffset = CGPoint.init(x: 5, y: 5)
    public var badgeValueLabelColor = UIColor.red
    public var badgeValueLabelTextColor = UIColor.white
    public var badgeValueMaxNum = 99
}

public let LLSegmentRedBadgeValue = "redBadgeValue"
open class LLSegmentItemBadgeView: LLSegmentBaseItemView {
    public let badgeValueLabel = UILabel()
    internal var badgeValueLabelLocationView:UIView?
    public var badgeItemViewStyle = LLSegmentItemBadgeViewStyle()
    required public init(frame: CGRect) {
        super.init(frame: frame)
        
        badgeValueLabel.backgroundColor = UIColor.red
        badgeValueLabel.textAlignment = .center
        badgeValueLabel.textColor = UIColor.white
        badgeValueLabel.font = UIFont.systemFont(ofSize: 12)
        badgeValueLabel.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        badgeValueLabel.center = CGPoint.init(x: bounds.width - 10, y: 10)
        badgeValueLabel.isHidden = true
        addSubview(badgeValueLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func setSegmentItemViewStyle(itemViewStyle: LLSegmentItemViewStyle) {
        super.setSegmentItemViewStyle(itemViewStyle: itemViewStyle)
        if let itemViewStyle = itemViewStyle as? LLSegmentItemBadgeViewStyle {
            badgeItemViewStyle = itemViewStyle
            badgeValueLabel.backgroundColor = itemViewStyle.badgeValueLabelColor
            badgeValueLabel.textColor = itemViewStyle.badgeValueLabelTextColor
        }
    }
    
    internal func layoutBadgeLabel() {
        guard let badgeValueLabelLocationView = badgeValueLabelLocationView else {
            return
        }
        
        var badgeValueStr = tabBarItem?.badgeValue
        if let badgeValue = badgeValueStr, let intValue = Int(badgeValue) {
            if intValue > badgeItemViewStyle.badgeValueMaxNum {
                badgeValueStr = "\(badgeItemViewStyle.badgeValueMaxNum)+"
            }
        }
        badgeValueLabel.text = badgeValueStr
        badgeValueLabel.sizeToFit()
        
        var badgeValueLabelFrame = badgeValueLabel.frame
        if tabBarItem?.badgeValue == LLSegmentRedBadgeValue {
            badgeValueLabel.isHidden = false
            badgeValueLabelFrame.size.width = 5
            badgeValueLabelFrame.size.height = 5
            badgeValueLabel.text = ""
        }else if tabBarItem?.badgeValue == nil {
            badgeValueLabel.isHidden = true
            badgeValueLabel.text = ""
        }else{
            badgeValueLabel.isHidden = false
            badgeValueLabelFrame.size.width += 10
            badgeValueLabelFrame.size.height += 0
            badgeValueLabelFrame.size.width = max(badgeValueLabelFrame.width, badgeValueLabelFrame.height)
        }
        badgeValueLabel.frame = badgeValueLabelFrame
        badgeValueLabel.center = CGPoint.init(x: badgeValueLabelLocationView.frame.maxX + badgeItemViewStyle.badgeValueLabelOffset.x, y: badgeValueLabelLocationView.frame.minY + badgeItemViewStyle.badgeValueLabelOffset.y)
        badgeValueLabel.layer.cornerRadius = badgeValueLabel.bounds.height/2
        badgeValueLabel.clipsToBounds = true
    }
}
