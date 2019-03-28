//
//  LLSegmentItemTitleView.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/24.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit


public class LLSegmentItemTitleViewStyle:LLSegmentItemBadgeViewStyle {
    public var selectedColor = UIColor.init(red: 50/255.0, green: 50/255.0, blue:  50/255.0, alpha: 1)
    public var unSelectedColor = UIColor.init(red: 136/255.0, green: 136/255.0, blue: 136/255.0, alpha: 1)
    public var selectedTitleScale:CGFloat = 1.2
    public var titleFontSize:CGFloat = 12
    public var extraTitleSpace:CGFloat = 10
    public var titleLabelMaskEnabled = false
    public var titleLabelMaskColor = UIColor.red
    public var titleLabelCenterOffsetY:CGFloat = 0
}

open class LLSegmentItemTitleView: LLSegmentItemBadgeView {
    public let titleLabel = UILabel()
    internal let maskTitleLabel = UILabel()
    private let maskTitleLabelMask = CAShapeLayer()
    private var itemTitleViewStyle = LLSegmentItemTitleViewStyle()
    required public init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: itemTitleViewStyle.titleFontSize)
        addSubview(titleLabel)
        
        maskTitleLabel.textAlignment = .center
        maskTitleLabel.textColor = itemTitleViewStyle.titleLabelMaskColor
        maskTitleLabel.font = titleLabel.font
        maskTitleLabelMask.backgroundColor = UIColor.red.cgColor
        maskTitleLabel.layer.mask = maskTitleLabelMask
        addSubview(maskTitleLabel)
    
        badgeValueLabelLocationView = maskTitleLabel
        self.bringSubviewToFront(badgeValueLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint.init(x: bounds.width/2, y: bounds.height/2 + itemTitleViewStyle.titleLabelCenterOffsetY)
        
        maskTitleLabel.sizeToFit()
        maskTitleLabel.center = titleLabel.center
        maskTitleLabelMask.bounds = maskTitleLabel.bounds
        layoutBadgeLabel()
    }
    
    override open func titleChange(title: String) {
        super.titleChange(title: title)
        titleLabel.text = title
        maskTitleLabel.text = title
    }
    
    override open func percentChange(percent: CGFloat) {
        super.percentChange(percent: percent)
        titleLabelCalculation()
        titleLabelMaskCalculation()
    }
    
    override open func itemWidth() -> CGFloat {
        if itemTitleViewStyle.itemWidth == LLSegmentAutomaticDimension {
            var titleLableWidth = self.title.LLGetStrSize(font: itemTitleViewStyle.titleFontSize, w: 1000, h: 1000).width
            titleLableWidth = titleLableWidth + 2*itemTitleViewStyle.extraTitleSpace
            return titleLableWidth
        }else{
            return itemTitleViewStyle.itemWidth
        }
    }
    
    override open func setSegmentItemViewStyle(itemViewStyle: LLSegmentItemViewStyle) {
        super.setSegmentItemViewStyle(itemViewStyle: itemViewStyle)
        if let itemViewStyle = itemViewStyle as? LLSegmentItemTitleViewStyle {
            self.itemTitleViewStyle = itemViewStyle
            titleLabel.textColor = itemViewStyle.unSelectedColor
            maskTitleLabel.textColor = itemViewStyle.titleLabelMaskColor
        }
    }
}

extension LLSegmentItemTitleView{
    //titleLabel
    private func titleLabelCalculation() {
        let percentConvert = self.percentConvert()
        titleLabel.textColor = interpolationColorFrom(fromColor:itemTitleViewStyle.unSelectedColor, toColor:itemTitleViewStyle.selectedColor, percent: percentConvert)
        let scale = 1 + (itemTitleViewStyle.selectedTitleScale - 1)*percentConvert
        let font = UIFont.boldSystemFont(ofSize: itemTitleViewStyle.titleFontSize * scale)
        titleLabel.font = font
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint.init(x: bounds.width/2, y: bounds.height/2 + itemTitleViewStyle.titleLabelCenterOffsetY)
    }
    
    //mask
    private func titleLabelMaskCalculation() {
        if itemTitleViewStyle.titleLabelMaskEnabled {
            maskTitleLabel.sizeToFit()
            maskTitleLabel.center = titleLabel.center
            maskTitleLabel.font = titleLabel.font
            
            let maskTitleLabelHalfWidth = titleLabel.frame.width/2
            var centerX:CGFloat = titleLabel.frame.minX - maskTitleLabelHalfWidth
            if let indicatorView = indicatorView {
                //正常情况
                let indicatorFrame = indicatorView.convert(indicatorView.bounds,to:self)
                if contentOffsetOnRight {
                    centerX = min(indicatorFrame.maxX - maskTitleLabelHalfWidth, titleLabel.center.x)
                }else{
                    centerX = max(indicatorFrame.minX + maskTitleLabelHalfWidth, titleLabel.center.x)
                }
                
                //指示器的宽度小于maskTitleLabel的宽度
                let indicatorViewFinalWidth = indicatorView.finalWidthOn(itemView: self)
                if indicatorViewFinalWidth < titleLabel.frame.width {
                    if contentOffsetOnRight {
                        centerX += (titleLabel.frame.width - indicatorViewFinalWidth)*percent/2
                        centerX = min(centerX, titleLabel.center.x)
                    }else{
                        centerX -= (titleLabel.frame.width - indicatorViewFinalWidth)*percent/2
                        centerX = max(centerX, titleLabel.center.x)
                    }
                }
                
                //点击的情况，指示器有动画切换
                if percent == 0 {
                    centerX = titleLabel.frame.minX - maskTitleLabelHalfWidth
                }else if percent == 1{
                    centerX = titleLabel.frame.minX + maskTitleLabelHalfWidth
                }
            }
            var maskTitleLabelCenter = maskTitleLabel.center
            maskTitleLabelCenter.x = centerX
            maskTitleLabelCenter = self.convert(maskTitleLabelCenter, to: maskTitleLabel)
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            maskTitleLabelMask.bounds = maskTitleLabel.bounds
            maskTitleLabelMask.position = maskTitleLabelCenter
            maskTitleLabel.isHidden = false
            CATransaction.commit()
        }else{
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            maskTitleLabel.isHidden = true
            CATransaction.commit()
        }
    }
}
