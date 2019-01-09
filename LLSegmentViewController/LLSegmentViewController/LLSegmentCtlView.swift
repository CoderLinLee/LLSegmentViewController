//
//  LLSegmentCtl.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/18.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit


@objc public protocol LLSegmentCtlViewDelegate : NSObjectProtocol {
    @objc optional func segMegmentCtlView(segMegmentCtlView: LLSegmentCtlView, reloadCtlView defaultSelectItemView:LLSegmentBaseItemView)
    @objc optional func segMegmentCtlView(segMegmentCtlView: LLSegmentCtlView, itemView: LLSegmentBaseItemView,extraGapAtIndex:NSInteger) -> CGFloat
    @objc optional func segMegmentCtlView(segMegmentCtlView: LLSegmentCtlView, clickItemAt sourceItemView: LLSegmentBaseItemView, to destinationItemView: LLSegmentBaseItemView)
    @objc optional func segMegmentCtlView(segMegmentCtlView: LLSegmentCtlView,totalPercent:CGFloat)
    @objc optional func segMegmentCtlView(segMegmentCtlView: LLSegmentCtlView,dragToScroll leftItemView:LLSegmentBaseItemView,rightItemView:LLSegmentBaseItemView)
    @objc optional func segMegmentCtlView(segMegmentCtlView: LLSegmentCtlView,dragToSelected itemView: LLSegmentBaseItemView)

}


public struct LLSegmentCtlViewStyle{
    public var itemSpacing:CGFloat = 0
    public var segmentItemViewClass:LLSegmentBaseItemView.Type = LLSegmentItemTitleView.self
    public var itemViewStyle:LLSegmentCtlItemViewStyle = LLSegmentItemTitleViewStyle()
    public var defaultSelectedIndex:NSInteger = 0
    public init(){}
}

open class LLSegmentCtlView: UIView {
    //----------------------separatorLine-----------------------// 设置完成后调用reloadSeparator方法，刷新分割线样式
    public var separatorLineShowEnabled = false
    public var separatorLineColor = UIColor.lightGray
    public var separatorLineWidth = 1/UIScreen.main.scale
    public var separatorTopBottomMargin:(top:CGFloat,bottom:CGFloat) = (0,0)
    private var separatorViews = [UIView]()

    public var totalPercent:CGFloat = 0
    public var contentOffsetAnimation = true
    public var delegate:LLSegmentCtlViewDelegate?
    public private (set) var indicatorView = LLIndicatorView(frame:CGRect.init(x: 0, y: 0, width: 10, height: 3))
    public var ctls:[UIViewController]!
    public let segMegmentScrollerView = UIScrollView(frame: CGRect.zero)
    public var currentPageItemView:LLSegmentBaseItemView!
    public var leftItemView:LLSegmentBaseItemView!
    public var rightItemView:LLSegmentBaseItemView!
    public var ctlViewStyle = LLSegmentCtlViewStyle()
    
    private let associateScrollerViewObserverKeyPath = "contentOffset"
    private var itemViews = [LLSegmentBaseItemView]()
    
    public weak var associateScrollerView:UIScrollView? {
        didSet{
            associateScrollerView?.addObserver(self, forKeyPath: associateScrollerViewObserverKeyPath, options: [.new,.old], context: nil)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        associateScrollerView?.removeObserver(self, forKeyPath: associateScrollerViewObserverKeyPath)
    }
}

extension LLSegmentCtlView{
    public func reloadSeparator() {
        for separator in separatorViews {
            reloadOneSeparatorView(separatorView: separator)
        }
    }
    
    private func reloadOneSeparatorView(separatorView:UIView) {
        var separatorViewCenter = separatorView.center
        separatorView.frame = CGRect.init(x: 0, y: separatorTopBottomMargin.top, width: separatorLineWidth, height: bounds.height - separatorTopBottomMargin.top - separatorTopBottomMargin.bottom)
        separatorViewCenter.y = separatorView.center.y
        separatorView.center = separatorViewCenter
        
        separatorView.backgroundColor = separatorLineColor
        separatorView.isHidden = !separatorLineShowEnabled
        
    }
}


extension LLSegmentCtlView{
    public func reloadData(ctlViewStyle:LLSegmentCtlViewStyle? = nil) {
        if ctlViewStyle != nil {
            self.ctlViewStyle = ctlViewStyle!
        }
        
        for subView in segMegmentScrollerView.subviews{
            if subView != indicatorView {
                subView.removeFromSuperview()
            }else{
                segMegmentScrollerView.addSubview(indicatorView)
            }
        }
        itemViews.removeAll()
        
        var lastItemView:LLSegmentBaseItemView? = nil
        let ItemViewClass = self.ctlViewStyle.segmentItemViewClass
        for (index,ctl) in ctls.enumerated() {
            let segmentCtlItemView = ItemViewClass.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: bounds.height))
            segmentCtlItemView.associateViewCtl = ctl
            segmentCtlItemView.setSegmentItemViewStyle(itemViewStyle: self.ctlViewStyle.itemViewStyle)
            segmentCtlItemView.percentChange(percent: 0)
            segmentCtlItemView.index = index
            if let segmentCtlItemView = segmentCtlItemView as? LLSegmentItemTitleView {
                segmentCtlItemView.indicatorView = indicatorView
            }
    
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(segmentItemClick(gesture:)))
            segmentCtlItemView.addGestureRecognizer(tapGesture)
            
            //size
            var segmentCtlItemViewFrame = segmentCtlItemView.frame
            segmentCtlItemViewFrame.size.width = segmentCtlItemView.itemWidth()
            segmentCtlItemViewFrame.size.height = self.bounds.height
            
            //origin
            if let lastItemView = lastItemView {
                var itemGap = self.ctlViewStyle.itemSpacing
                if let gap = delegate?.segMegmentCtlView?(segMegmentCtlView: self, itemView: segmentCtlItemView, extraGapAtIndex: index) {
                    itemGap += gap
                }
                segmentCtlItemViewFrame.origin.x = lastItemView.frame.maxX + itemGap
            }
            segmentCtlItemViewFrame.origin.y = (bounds.height - segmentCtlItemViewFrame.size.height) / 2
            
            segmentCtlItemView.frame = segmentCtlItemViewFrame
            segMegmentScrollerView.addSubview(segmentCtlItemView)
            itemViews.append(segmentCtlItemView)
            
            //分割线
            if lastItemView != nil {
                let separatorView = UIView()
                separatorView.center.x = (lastItemView!.frame.maxX + segmentCtlItemView.frame.minX)/2
                segMegmentScrollerView.addSubview(separatorView)
                reloadOneSeparatorView(separatorView: separatorView)
                separatorViews.append(separatorView)
            }
            lastItemView = segmentCtlItemView
        }
        segMegmentScrollerView.contentSize = CGSize.init(width: lastItemView?.frame.maxX ?? bounds.width, height: bounds.height)
        
        //初始化设置状态和位置
        if let defaultSelectedItemView = getItemView(atIndex: self.ctlViewStyle.defaultSelectedIndex) {
            defaultSelectedItemView.percentChange(percent: 1)
            currentPageItemView = defaultSelectedItemView
            didSelecteItemView()
            
            segmentScrollerViewSrollerToCenter(itemView: defaultSelectedItemView, animated: true)
            if let associateScrollerView = associateScrollerView {
                let offsetX = CGFloat(defaultSelectedItemView.index)*associateScrollerView.bounds.width
                associateScrollerView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: false)
            }
            
            indicatorView.centerYGradientStyle = indicatorView.centerYGradientStyle
            indicatorView.reloadLayout(leftItemView: defaultSelectedItemView, rightItemView: defaultSelectedItemView)
        
            delegate?.segMegmentCtlView?(segMegmentCtlView: self, reloadCtlView: defaultSelectedItemView)
            delegate?.segMegmentCtlView?(segMegmentCtlView: self, totalPercent: 1.0/CGFloat(ctls.count))
        }
    }
}

extension LLSegmentCtlView{
    //点击
    @objc func segmentItemClick(gesture:UIGestureRecognizer) {
        if let selectedItemView = gesture.view as? LLSegmentBaseItemView,
            let selectedIndex = itemViews.index(of: selectedItemView)?.hashValue,
            let associateScrollerView = associateScrollerView{
            let preSeletedIndex = Int(associateScrollerView.contentOffset.x / associateScrollerView.bounds.width)
            let preSelectedItemView = getItemView(atIndex: preSeletedIndex)
            
            //
            if let preSelectedItemView = preSelectedItemView {
                delegate?.segMegmentCtlView?(segMegmentCtlView: self, clickItemAt: preSelectedItemView, to: selectedItemView)
            }
            
            //点击的是当前的
            if currentPageItemView == selectedItemView {
                return
            }
            currentPageItemView = selectedItemView
            didSelecteItemView()

            if let preSelectedItemView = preSelectedItemView {
                var leftItemView = selectedItemView
                var rightItemView = preSelectedItemView
                if leftItemView.frame.origin.x > rightItemView.frame.origin.x {
                    leftItemView = preSelectedItemView
                    rightItemView = selectedItemView
                }
                
                let offset = CGPoint.init(x: CGFloat(selectedIndex) * associateScrollerView.bounds.width, y: 0)
                if fabs(Double(preSeletedIndex - selectedIndex)) == 1 && contentOffsetAnimation{
                    associateScrollerView.setContentOffset(offset, animated: true)
                }else{
                    associateScrollerView.setContentOffset(offset, animated: false)
                }
                segmentScrollerViewSrollerToCenter(itemView: selectedItemView, animated: true)
                
                UIView.animate(withDuration: 0.25) {
                    self.indicatorView.reloadLayout(leftItemView: leftItemView, rightItemView: rightItemView)
                }
            }
        }
    }
    
    private func didSelecteItemView() {
        rightItemView = currentPageItemView
        leftItemView = currentPageItemView
        for itemView in itemViews {
            if itemView != currentPageItemView {
                itemView.percentChange(percent: 0)
            }else{
                itemView.percentChange(percent: 1)
            }
        }
    }
}

extension LLSegmentCtlView{
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard ctls != nil && ctls.count > 0 else {
            return
        }
        
        if keyPath == associateScrollerViewObserverKeyPath ,
            let newContentOffset = change?[NSKeyValueChangeKey.newKey] as? CGPoint,
            let scrollView = associateScrollerView{
            
            totalPercent = (newContentOffset.x + scrollView.bounds.width) / scrollView.contentSize.width
            let percentRang = CGFloat(0)...CGFloat(1)
            if percentRang.contains(totalPercent){
                delegate?.segMegmentCtlView?(segMegmentCtlView: self, totalPercent: totalPercent)
            }
            
            let userScroller = (scrollView.isTracking || scrollView.isDecelerating)
            if  scrollView.contentSize.width != 0 && scrollView.bounds.width != 0 && userScroller{
                contentOffsetChangeCalculation(scrollView: scrollView)
            }
        }
    }
    
    
    private func contentOffsetChangeCalculation(scrollView:UIScrollView) {
        let basePercent = 1.0 / CGFloat(ctls.count)
        
        //边界,最右边和最左边的情况不往下执行
        let drageRange = basePercent...1
        if !drageRange.contains(totalPercent){
            return
        }
        
        //计算leftItemIndex,rightItemIndex
        let index = totalPercent/basePercent - 1
        let leftItemIndex = max(0, min(ctls.count - 1, Int(floor(index))))
        let rightItemIndex = max(0, min(ctls.count - 1, Int(ceil(index))))
        var rightPercent = index - CGFloat(leftItemIndex)
        var leftPercent = 1 - rightPercent
        if leftItemIndex == rightItemIndex {
            leftPercent = 1
            rightPercent = 1
        }

        if let leftItemView = getItemView(atIndex: leftItemIndex),
            let rightItemView = getItemView(atIndex: rightItemIndex) {
            contentOffsetChangeViewAction(leftItemView: leftItemView, rightItemView: rightItemView,leftPercent: leftPercent,rightPercent: rightPercent)
            
            delegate?.segMegmentCtlView?(segMegmentCtlView: self, dragToScroll: leftItemView, rightItemView: rightItemView)
        }
    }
    
    private func contentOffsetChangeViewAction(leftItemView:LLSegmentBaseItemView,rightItemView:LLSegmentBaseItemView,leftPercent:CGFloat,rightPercent:CGFloat) {
        //边界情况:快速滑动的情况
        if (leftItemView,rightItemView) != (self.leftItemView,self.rightItemView) {
            self.leftItemView.percentChange(percent: 0)
            self.rightItemView.percentChange(percent: 0)
        }
        leftItemView.percentChange(percent: leftPercent)
        rightItemView.percentChange(percent: rightPercent)
        leftItemView.contentOffsetOnRight = false
        rightItemView.contentOffsetOnRight = true
        self.leftItemView = leftItemView
        self.rightItemView = rightItemView
        
        indicatorView.reloadLayout(leftItemView: leftItemView, rightItemView: rightItemView)
        
        //segMegmentScrollerView Follow rolling:segMegmentScrollerView跟随用户的滑动
        var scrollerPageItemView:LLSegmentBaseItemView?
        if leftItemView.percent >= 0.5 {
            scrollerPageItemView = leftItemView
        }else{
            scrollerPageItemView = rightItemView
        }
        if let scrollerPageItemView = scrollerPageItemView, scrollerPageItemView != currentPageItemView {
            segmentScrollerViewSrollerToCenter(itemView: scrollerPageItemView, animated: true)
        }
        
        if scrollerPageItemView?.percent == 1 && scrollerPageItemView != currentPageItemView{
            currentPageItemView = scrollerPageItemView
            didSelecteItemView()
            delegate?.segMegmentCtlView?(segMegmentCtlView: self, dragToSelected: currentPageItemView)
        }
    }
}

extension LLSegmentCtlView{
    private  func segmentScrollerViewSrollerToCenter(itemView:LLSegmentBaseItemView,animated:Bool) {
        var offsetX = segMegmentScrollerView.contentOffset.x
        let targetCenter = itemView.center
         
        let boundsCenterX = bounds.width/2
        if let convertCenter = itemView.superview?.convert(targetCenter, to: self){
            offsetX -= (boundsCenterX - convertCenter.x)
            offsetX = max(0, min(offsetX, segMegmentScrollerView.contentSize.width - bounds.width))
            segMegmentScrollerView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: animated)
        }
    }
}

extension LLSegmentCtlView{
    private func initSubviews() {
        if #available(iOS 11.0, *) {
            segMegmentScrollerView.contentInsetAdjustmentBehavior = .never
        }
        segMegmentScrollerView.backgroundColor = UIColor.clear
        segMegmentScrollerView.frame = bounds
        segMegmentScrollerView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        segMegmentScrollerView.showsHorizontalScrollIndicator = false
        segMegmentScrollerView.showsVerticalScrollIndicator = false
        segMegmentScrollerView.bounces = false
        addSubview(segMegmentScrollerView)

        indicatorView.backgroundColor = UIColor.black
        segMegmentScrollerView.addSubview(indicatorView)
    }
    
    private func getItemView(atIndex:NSInteger) -> LLSegmentBaseItemView? {
        if atIndex < 0 || atIndex >= itemViews.count {
            return nil
        }
        return itemViews[atIndex]
    }
}

