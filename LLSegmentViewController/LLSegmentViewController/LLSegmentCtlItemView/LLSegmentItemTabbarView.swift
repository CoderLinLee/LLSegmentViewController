//
//  LLSegmentItemTabbarView.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/26.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit

public class LLSegmentItemTabbarViewStyle:LLSegmentItemTitleViewStyle {
    public var titleImgeGap:CGFloat = 2
    public var titleBottomGap:CGFloat = 3
    /*数字或红点Label.center偏离图片右上角*/
    public var badgeValueLabelOffset = CGPoint.init(x: 5, y: 5)
    public var badgeValueLabelColor = UIColor.red
    public var badgeValueMaxNum = 99
}


open class LLSegmentItemTabbarView: LLSegmentBaseItemView {
    let titleLabel = UILabel()
    let imageView = UIImageView()
    let badgeValueLabel = UILabel()
    let tabbarItemButton = UIButton()
    private var tabbarViewStyle = LLSegmentItemTabbarViewStyle()
    private let badgeValueObserverKeyPath = "badgeValue"
    required public init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(imageView)
        
        badgeValueLabel.backgroundColor = UIColor.red
        badgeValueLabel.textAlignment = .center
        badgeValueLabel.textColor = UIColor.white
        badgeValueLabel.font = UIFont.systemFont(ofSize: 12)
        badgeValueLabel.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        badgeValueLabel.center = CGPoint.init(x: bounds.width - 10, y: 10)
        addSubview(badgeValueLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var associateViewCtl: UIViewController? {
        didSet{
            associateViewCtl?.tabBarItem.addObserver(self, forKeyPath: badgeValueObserverKeyPath, options: [.new], context: nil)
            if associateViewCtl?.tabBarItem.title == nil {
                titleLabel.text = associateViewCtl?.title
            }else{
                titleLabel.text = associateViewCtl?.tabBarItem.title
            }
        }
    }
    
    override public func percentChange(percent: CGFloat) {
        super.percentChange(percent: percent)
        titleLabel.textColor = interpolationColorFrom(fromColor:tabbarViewStyle.unSelectedColor, toColor:tabbarViewStyle.selectedColor, percent: percent)
        if percent == 1 {
            imageView.image = associateViewCtl?.tabBarItem.selectedImage
        }else{
            imageView.image = associateViewCtl?.tabBarItem.image
        }
    }
    
    override public func itemWidth() -> CGFloat {
        if tabbarViewStyle.itemWidth == LLSegmentAutomaticDimension {
            var titleLableWidth = associateViewCtl?.title?.LLGetStrSize(font: tabbarViewStyle.titleFontSize, w: 1000, h: 1000).width ?? 0
            titleLableWidth = titleLableWidth + 2*tabbarViewStyle.extraTitleSpace
            return titleLableWidth
        }else{
            return tabbarViewStyle.itemWidth
        }
    }
    
    override public func setSegmentItemViewStyle(itemViewStyle: LLSegmentCtlItemViewStyle) {
        if let itemViewStyle = itemViewStyle as? LLSegmentItemTabbarViewStyle {
            self.tabbarViewStyle = itemViewStyle
            titleLabel.textAlignment = .center
            titleLabel.textColor = itemViewStyle.unSelectedColor
            titleLabel.font = UIFont.systemFont(ofSize: itemViewStyle.titleFontSize)
            
            titleLabel.frame = CGRect.init(x: 0, y: bounds.height - itemViewStyle.titleBottomGap - titleLabel.font.lineHeight, width: bounds.width, height: titleLabel.font.lineHeight)
            titleLabel.autoresizingMask = [.flexibleWidth,.flexibleTopMargin]
            
            imageView.contentMode = .bottom
            imageView.frame = CGRect.init(x: 0, y: 0, width: bounds.width, height: titleLabel.frame.origin.y - tabbarViewStyle.titleImgeGap)
            imageView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            
            badgeValueLabel.backgroundColor = itemViewStyle.badgeValueLabelColor
        }
    }

    override open func layoutSubviews() {
        var badgeValueStr = associateViewCtl?.tabBarItem.badgeValue
        if let badgeValue = badgeValueStr, let intValue = Int(badgeValue) {
            if intValue > tabbarViewStyle.badgeValueMaxNum {
                badgeValueStr = "\(tabbarViewStyle.badgeValueMaxNum)+"
            }
        }
        badgeValueLabel.text = badgeValueStr
        badgeValueLabel.sizeToFit()
        var badgeValueLabelFrame = badgeValueLabel.frame
        if associateViewCtl?.tabBarItem.badgeValue == LLSegmentRedBadgeValue {
            badgeValueLabel.isHidden = false
            badgeValueLabelFrame.size.width = 5
            badgeValueLabelFrame.size.height = 5
            badgeValueLabel.text = ""
        }else if associateViewCtl?.tabBarItem.badgeValue == nil {
            badgeValueLabel.isHidden = true
        }else{
            badgeValueLabel.isHidden = false
            badgeValueLabelFrame.size.width += 10
            badgeValueLabelFrame.size.height += 3
        }
        
        badgeValueLabel.bounds = badgeValueLabelFrame
        let imageViewBottomCenter = CGPoint.init(x: imageView.center.x, y: imageView.frame.maxY)
        if let imageSize = imageView.image?.size {
            let offsetX:CGFloat = tabbarViewStyle.badgeValueLabelOffset.x
            let offsetY:CGFloat = tabbarViewStyle.badgeValueLabelOffset.y
            badgeValueLabel.center = CGPoint.init(x: imageViewBottomCenter.x + imageSize.width/2 + offsetX, y: imageViewBottomCenter.y - imageSize.height + offsetY)
        }else{
            badgeValueLabel.isHidden = true
        }
        badgeValueLabel.layer.cornerRadius = badgeValueLabel.bounds.height/2
        badgeValueLabel.clipsToBounds = true
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if  keyPath ==  badgeValueObserverKeyPath{
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
}
