//
//  LLSegmentItemTabbarView.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/26.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit

public class LLSegmentItemTabbarViewStyle:LLSegmentItemBadgeViewStyle {
    public var titleImgeGap:CGFloat = 2
    public var titleBottomGap:CGFloat = 3
    
    public var selectedColor = UIColor.init(red: 50/255.0, green: 50/255.0, blue:  50/255.0, alpha: 1)
    public var unSelectedColor = UIColor.init(red: 136/255.0, green: 136/255.0, blue: 136/255.0, alpha: 1)
    public var titleFontSize:CGFloat = 12
}


open class LLSegmentItemTabbarView: LLSegmentItemBadgeView {
    let titleLabel = UILabel()
    let imageView = UIImageView()
    let tabbarItemButton = UIButton()
    private var tabbarViewStyle = LLSegmentItemTabbarViewStyle()
    required public init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(imageView)
        
        imageView.contentMode = .bottom
        badgeValueLabelLocationView = imageView
        self.bringSubviewToFront(badgeValueLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override open func percentChange(percent: CGFloat) {
        super.percentChange(percent: percent)
        titleLabel.textColor = interpolationColorFrom(fromColor:tabbarViewStyle.unSelectedColor, toColor:tabbarViewStyle.selectedColor, percent: percent)
        if percent == 1 {
            imageView.image = associateViewCtl?.tabBarItem.selectedImage
        }else{
            imageView.image = associateViewCtl?.tabBarItem.image
        }
    }
    
    override open func itemWidth() -> CGFloat {
        return tabbarViewStyle.itemWidth
    }
    
    override open func titleChange(title: String) {
        super.titleChange(title: title)
        titleLabel.text = title
    }
    
    override open func setSegmentItemViewStyle(itemViewStyle: LLSegmentItemViewStyle) {
        super.setSegmentItemViewStyle(itemViewStyle: itemViewStyle)
        if let itemViewStyle = itemViewStyle as? LLSegmentItemTabbarViewStyle {
            self.tabbarViewStyle = itemViewStyle
            titleLabel.textAlignment = .center
            titleLabel.textColor = itemViewStyle.unSelectedColor
            titleLabel.font = UIFont.systemFont(ofSize: itemViewStyle.titleFontSize)
            titleLabel.sizeToFit()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
        let titleLabelHeight = titleLabel.bounds.height
        let titleLabelY = bounds.height - tabbarViewStyle.titleBottomGap - titleLabelHeight
        titleLabel.frame = CGRect.init(x: 0, y: titleLabelY, width: bounds.width, height: titleLabelHeight)
        
        let imgSize = imageView.image?.size ?? CGSize.zero
        let bottomMargin = titleLabelHeight + tabbarViewStyle.titleBottomGap + tabbarViewStyle.titleImgeGap
        imageView.center = CGPoint.init(x: bounds.width/2, y:bounds.height - bottomMargin - imgSize.height/2)
        imageView.bounds = CGRect.init(origin: CGPoint.zero, size: imgSize)
        layoutBadgeLabel()
        
        if percent == 1 {
            imageView.image = associateViewCtl?.tabBarItem.selectedImage
        }else{
            imageView.image = associateViewCtl?.tabBarItem.image
        }
    }
}
