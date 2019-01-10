//
//  LLSegmentItemTitleImageView.swift
//  LLSegmentViewController
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

public protocol LLSegmentItemTitleImageViewProtocol{
    var model : LLTitleImageModel! {get set}
    func loadImageView(titleLabel:UILabel,imageView:UIImageView,percent:CGFloat)
}


public enum LLTitleImageButtonStyle {
    case titleTop(margin:CGFloat)
    case titleBottom(margin:CGFloat)
    case titleLeft(margin:CGFloat)
    case titleRight(margin:CGFloat)
}

open class LLTitleImageModel{
    var title = ""
    var imgeStr = ""
    var selecteImageStr = ""
    var style = LLTitleImageButtonStyle.titleTop(margin: 0)
    var imgViewSize = CGSize.init(width: 20, height: 20)
    public init(title:String,imgeStr:String,style:LLTitleImageButtonStyle) {
        self.title = title
        self.imgeStr = imgeStr
        self.style = style
    }
}


open class LLSegmentItemTitleImageView: LLSegmentBaseItemView {

    let titleLabel = UILabel()
    let imageView = UIImageView()
    var titleImageModel:LLTitleImageModel?
    let titleLabelFontSize:CGFloat = 13
    required public init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.font = UIFont.systemFont(ofSize: titleLabelFontSize)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        addSubview(imageView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public var associateViewCtl: UIViewController?{
        didSet{
            if let ctl = associateViewCtl as? LLSegmentItemTitleImageViewProtocol{
                self.titleImageModel = ctl.model
                setNeedsLayout()
                layoutIfNeeded()
            }
        }
    }
    
    override public func itemWidth() -> CGFloat {
        if let model = titleImageModel{
            let layoutInfo = getLayoutInfo(model: model)
            return layoutInfo.contentSize.width + 2*10
        }
        return 0
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if let model = titleImageModel{
            titleLabel.text = model.title
            
            let layoutInfo = getLayoutInfo(model: model)
            titleLabel.frame = layoutInfo.titleLabelFrame
            imageView.frame = layoutInfo.imageViewFrame
        }
    }
    
    override public func percentChange(percent: CGFloat) {
        super.percentChange(percent: percent)
        if let ctl = associateViewCtl as? LLSegmentItemTitleImageViewProtocol{
            ctl.loadImageView(titleLabel:titleLabel, imageView: imageView, percent: percent)
        }
    }
    
    private func getLayoutInfo(model:LLTitleImageModel) -> (titleLabelFrame:CGRect,imageViewFrame:CGRect,contentSize:CGSize) {
        let titleLabelSize = model.title.LLGetStrSize(font: titleLabelFontSize, w: 1000, h: 1000)
        let imgViewSize = model.imgViewSize
        var contentWidth:CGFloat = 0
        var contentHeight:CGFloat = 0
        
        var titleLabelFrame = CGRect.init(origin: CGPoint.zero, size: titleLabelSize)
        var imageViewFrame = CGRect.init(origin: CGPoint.zero, size: imgViewSize)
        let selfCenter = CGPoint.init(x: bounds.width/2, y: bounds.height/2)
        switch model.style {
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
