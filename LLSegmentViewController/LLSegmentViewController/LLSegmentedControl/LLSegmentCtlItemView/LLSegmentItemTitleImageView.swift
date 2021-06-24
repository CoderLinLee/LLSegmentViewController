//
//  LLSegmentItemTitleImageView.swift
//  LLSegmentViewController
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit



public enum LLTitleImageButtonStyle {
    case titleEmty
    case titleOnly
    case titleTop(margin:CGFloat)
    case titleBottom(margin:CGFloat)
    case titleLeft(margin:CGFloat)
    case titleRight(margin:CGFloat)
}

public class LLSegmentItemTitleImageTabBarItem:UITabBarItem {
    /** 图片和文字布局 */
    public var style = LLTitleImageButtonStyle.titleTop(margin: 0)
    /** 图片显示大小 */
    public var imgViewSize = CGSize.init(width: 20, height: 20)
    /** 文本字体大小 */
    public var titleLabelFontSize:CGFloat = 13
    /** 这里有可能是网络图片，放出来在这里设置 */
    public var setImageBlock:((UIImageView,Bool,LLSegmentItemTitleImageTabBarItem)->Void)?
}

open class LLSegmentItemTitleImageView: LLSegmentItemBadgeView {
    let titleLabel = UILabel()
    let imageView = UIImageView()
    required public init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        addSubview(imageView)
        badgeValueLabel.isHidden = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func itemWidth() -> CGFloat {
        if let tabBarItem = tabBarItem as? LLSegmentItemTitleImageTabBarItem{
            let layoutInfo = getLayoutInfo(tabBar: tabBarItem)
            return layoutInfo.contentSize.width + 2*10
        }
        return 0
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if let tabBarItem = tabBarItem as? LLSegmentItemTitleImageTabBarItem{
            titleLabel.text = tabBarItem.title
            titleLabel.font = UIFont.systemFont(ofSize: tabBarItem.titleLabelFontSize)
            let layoutInfo = getLayoutInfo(tabBar: tabBarItem)
            titleLabel.frame = layoutInfo.titleLabelFrame
            imageView.frame = layoutInfo.imageViewFrame
        }
    }
    
    override open func percentChange(percent: CGFloat) {
        super.percentChange(percent: percent)
        titleLabel.text = tabBarItem?.title
        let isSelected = percent > 0.5
        if let tabBarItem = tabBarItem as? LLSegmentItemTitleImageTabBarItem{
            tabBarItem.setImageBlock?(imageView,isSelected,tabBarItem)
        }
    }
    
    private func getLayoutInfo(tabBar:LLSegmentItemTitleImageTabBarItem) -> (titleLabelFrame:CGRect,imageViewFrame:CGRect,contentSize:CGSize) {
        let titleLabelSize = tabBar.title?.LLGetStrSize(font: tabBar.titleLabelFontSize,
                                                        w: 1000, h: 1000) ?? CGSize.zero
        let imgViewSize = tabBar.imgViewSize
        var contentWidth:CGFloat = 0
        var contentHeight:CGFloat = 0
        
        var titleLabelFrame = CGRect.init(origin: CGPoint.zero, size: titleLabelSize)
        var imageViewFrame = CGRect.init(origin: CGPoint.zero, size: imgViewSize)
        let selfCenter = CGPoint.init(x: bounds.width/2, y: bounds.height/2)
        switch tabBar.style {
        case .titleEmty:
            contentHeight = imgViewSize.height
            contentWidth = imageViewFrame.width
            
            imageViewFrame.origin.x = selfCenter.x - contentWidth/2
            imageViewFrame.origin.y = selfCenter.y - contentWidth/2
            
            titleLabelFrame = CGRect.zero
            
        case .titleOnly:
            contentHeight = titleLabelSize.height
            contentWidth = titleLabelSize.width
            
            imageViewFrame = CGRect.zero

            titleLabelFrame.origin.x = selfCenter.x - contentWidth/2
            titleLabelFrame.origin.y = selfCenter.y - contentHeight/2

        case .titleTop(let margin):
            contentHeight = titleLabelSize.height + imgViewSize.height + margin
            contentWidth = max(titleLabelSize.width, imgViewSize.width)
            
            imageViewFrame.origin.y = selfCenter.y + contentHeight/2 - imgViewSize.height
            imageViewFrame.origin.x = selfCenter.x - imgViewSize.width/2
            
            titleLabelFrame.origin.y = selfCenter.y - contentHeight/2
            titleLabelFrame.origin.x = selfCenter.x - titleLabelSize.width/2
            
        case .titleBottom(let margin):
            contentHeight = titleLabelSize.height + imgViewSize.height + margin
            contentWidth = max(titleLabelSize.width, imgViewSize.width)
            
            imageViewFrame.origin.y = selfCenter.y - contentHeight/2
            imageViewFrame.origin.x = selfCenter.x - imgViewSize.width/2
            
            titleLabelFrame.origin.y = selfCenter.y + contentHeight/2 - titleLabelSize.height
            titleLabelFrame.origin.x = selfCenter.x - titleLabelSize.width/2
            
        case .titleLeft(let margin):
            contentWidth = titleLabelSize.width + imgViewSize.width + margin
            contentHeight = max(titleLabelSize.height, imgViewSize.height)
            
            imageViewFrame.origin.x = selfCenter.x + contentWidth/2 - imgViewSize.width
            imageViewFrame.origin.y = selfCenter.y - imgViewSize.height/2
            
            titleLabelFrame.origin.x = selfCenter.x - contentWidth/2
            titleLabelFrame.origin.y = selfCenter.y - titleLabelSize.height/2
            
        case .titleRight(let margin):
            contentWidth = titleLabelSize.width + imgViewSize.width + margin
            contentHeight = max(titleLabelSize.height, imgViewSize.height)
            
            imageViewFrame.origin.x = selfCenter.x - contentWidth/2
            imageViewFrame.origin.y = selfCenter.y - imgViewSize.height/2
            
            titleLabelFrame.origin.x = selfCenter.x + contentWidth/2 - titleLabelSize.width
            titleLabelFrame.origin.y = selfCenter.y - titleLabelSize.height/2
        }
        return (titleLabelFrame,imageViewFrame,CGSize.init(width: contentWidth, height: contentHeight))
    }
}
