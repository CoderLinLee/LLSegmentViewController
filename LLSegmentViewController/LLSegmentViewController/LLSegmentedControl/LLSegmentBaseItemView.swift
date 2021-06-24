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


open class LLSegmentBaseItemView: UIView  {
    public var contentOffsetOnRight = false
    public var index = 0
    public var isSelected = false
    public var percent:CGFloat = 0
    public var title:String = ""
    public var badgeValue:String = ""
    internal weak var indicatorView:LLIndicatorView?
    private var itemViewStyle = LLSegmentItemViewStyle()
    
    private let badgeValueObserverKeyPath = "badgeValue"
    private let titleObserverKeyPath = "title"
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
    
    open var tabBarItem: UITabBarItem?{
        didSet{
            tabBarItem?.addObserver(self, forKeyPath: badgeValueObserverKeyPath, options: [.new], context: nil)
            tabBarItem?.addObserver(self, forKeyPath: titleObserverKeyPath, options: [.new], context: nil)
        }
    }

    deinit {
        tabBarItem?.removeObserver(self, forKeyPath: titleObserverKeyPath)
        tabBarItem?.removeObserver(self, forKeyPath: badgeValueObserverKeyPath)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if  keyPath ==  badgeValueObserverKeyPath{
            badgeValueChange(badgeValue: tabBarItem?.badgeValue ?? "")
            setNeedsLayout()
            layoutIfNeeded()
        }else if keyPath == titleObserverKeyPath {
            titleChange(title: tabBarItem?.title ?? "")
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    open func percentChange(percent:CGFloat){
        if percent == 1 {
            self.isSelected = true
        }else if percent == 0 {
            self.isSelected = false
        }
        self.percent = percent
    }

    //override for subClass
    open func badgeValueChange(badgeValue:String){ self.badgeValue = badgeValue }
    open func titleChange(title:String){ self.title = title }
    open func itemWidth() ->CGFloat { return 0 }
    open func setSegmentItemViewStyle(itemViewStyle:LLSegmentItemViewStyle) { self.itemViewStyle=itemViewStyle }
}
