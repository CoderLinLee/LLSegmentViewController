//
//  LLSegmentItemTitleView.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/24.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit


public class LLSegmentItemTitleViewStyle:LLSegmentCtlItemViewStyle {
    var selectedColor = UIColor.init(red: 50/255.0, green: 50/255.0, blue:  50/255.0, alpha: 1)
    var unSelectedColor = UIColor.init(red: 136/255.0, green: 136/255.0, blue: 136/255.0, alpha: 1)
    var selectedTitleScale:CGFloat = 1.2
    var titleFontSize:CGFloat = 12
    var extraTitleSpace:CGFloat = 30
}

class LLSegmentItemTitleView: LLSegmentCtlItemView {
    let titleLabel = UILabel()
    private var itemTitleViewStyle = LLSegmentItemTitleViewStyle()
    required init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: itemTitleViewStyle.titleFontSize)
        addSubview(titleLabel)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var associateViewCtl: UIViewController? {
        didSet{
            titleLabel.text = associateViewCtl?.title
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint.init(x: bounds.width/2, y: bounds.height/2)
    }
    
    override func percentChange(percent: CGFloat) {
        super.percentChange(percent: percent)
        titleLabel.textColor = interpolationColorFrom(fromColor:itemTitleViewStyle.unSelectedColor, toColor:itemTitleViewStyle.selectedColor, percent: percent)
        let scale = 1 + (itemTitleViewStyle.selectedTitleScale - 1)*percent
        let font = UIFont.boldSystemFont(ofSize: itemTitleViewStyle.titleFontSize * scale)
        titleLabel.font = font
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint.init(x: bounds.width/2, y: bounds.height/2)
    }
    
    override func itemWidth() -> CGFloat {
        if itemTitleViewStyle.itemWidth == LLSegmentAutomaticDimension {
            var titleLableWidth = associateViewCtl?.title?.LLGetStrSize(font: itemTitleViewStyle.titleFontSize, w: 1000, h: 1000).width ?? 0
            titleLableWidth = titleLableWidth + 2*itemTitleViewStyle.extraTitleSpace
            return titleLableWidth
        }else{
            return itemTitleViewStyle.itemWidth
        }
    }
    
    override func setSegmentItemViewStyle(itemViewStyle: LLSegmentCtlItemViewStyle) {
        if let itemViewStyle = itemViewStyle as? LLSegmentItemTitleViewStyle {
            self.itemTitleViewStyle = itemViewStyle
            titleLabel.textColor = itemViewStyle.unSelectedColor
        }
    }
}
