//
//  LLSegmentCtlItemView.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/20.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit

//选中的变化位置
public enum LLSegmentItemViewSelectedStyle {
    /*从中间*/
    case mid
    /*从一开始0...1*/
    case gradient
    /*完全选中才变化*/
    case totalSelected
}

//自动计算返回宽度
public let LLSegmentAutomaticDimension:CGFloat = -1
open class LLSegmentItemViewStyle:NSObject {
    /*itemView的宽度*/
    public var itemWidth:CGFloat = LLSegmentAutomaticDimension
    /*过渡变化*/
    public var selectedStyle = LLSegmentItemViewSelectedStyle.gradient
}


open class LLSegmentBaseItemView: UIView {
    public var isScrollerTarget = false
    public var contentOffsetOnRight = false
    public var index = 0
    public var isSelected = false

    internal weak var indicatorView:LLIndicatorView!
    private var itemViewStyle = LLSegmentItemViewStyle()
    public override required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func percentConvert()->CGFloat{
        switch itemViewStyle.selectedStyle {
        case .gradient:
            return percent
        case .mid:
            if percent >= 0.5 {
                return 1
            }else{
                return 0
            }
        case .totalSelected:
            if isSelected == true {
                return 1
            }else{
                return 0
            }
        }
    }

    open weak var associateViewCtl:UIViewController? {
        didSet{
            var title:String?
            if associateViewCtl?.title != nil {
                title = associateViewCtl?.title
            }else if associateViewCtl?.tabBarItem.title != nil{
                title = associateViewCtl?.tabBarItem.title
            }
            titleChange(title: title ?? "")
        }
    }
    public var percent:CGFloat = 0
    
    //override for subClass
    open func titleChange(title:String){}
    open func percentChange(percent:CGFloat){
        if percent == 1 {
            self.isSelected = true
        }else if percent == 0 {
            self.isSelected = false
        }
        self.percent = percent
    }
    open func itemWidth() ->CGFloat { return 0 }
    open func setSegmentItemViewStyle(itemViewStyle:LLSegmentItemViewStyle) { self.itemViewStyle=itemViewStyle }
}
