//
//  LLSegmentCtl.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/18.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit
@objc  protocol LLSegmentCtlViewDelegate : NSObjectProtocol {
    @objc optional func segMegmentCtlView(segMegmentCtlView: LLSegmentCtlView, leftItemView: LLSegmentCtlItemView,rightItemView:LLSegmentCtlItemView,percent:CGFloat)
    @objc optional func segMegmentCtlView(segMegmentCtlView: LLSegmentCtlView, itemView: LLSegmentCtlItemView,extraGapAtIndex:NSInteger) -> CGFloat
    @objc optional func segMegmentCtlView(segMegmentCtlView: LLSegmentCtlView, itemView: LLSegmentCtlItemView,selectedAt:NSInteger)
}



public class LLSegmentCtlView: UIView {
    //----------------------separatorLine-----------------------// 设置完成后调用reloadSeparator方法，刷新分割线样式
    public var separatorLineShowEnabled = false
    public var separatorLineColor = UIColor.lightGray
    public var separatorLineWidth = 1/UIScreen.main.scale
    public var separatorTopBottomMargin:(top:CGFloat,bottom:CGFloat) = (0,0)
    private var separatorViews = [UIView]()

    
    public var contentOffsetAnimation = true
    var ctls:[UIViewController]!
    var itemViews = [LLSegmentCtlItemView]()
    var delegate:LLSegmentCtlViewDelegate?
    let segMegmentScrollerView = UIScrollView(frame: CGRect.zero)
    private (set) var indicatorView = LLIndicatorView(frame:CGRect.init(x: 0, y: 0, width: 10, height: 3))
    private let associateScrollerViewObserverKeyPath = "contentOffset"
    private var selectedPage = 0
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
    //点击
    @objc func itemViewClick(gesture:UIGestureRecognizer) {
        if let selectedItemView = gesture.view as? LLSegmentCtlItemView,
            let selectedIndex = itemViews.index(of: selectedItemView)?.hashValue,
            let associateScrollerView = associateScrollerView{
            let preSeletedIndex = Int(associateScrollerView.contentOffset.x / associateScrollerView.bounds.width)
            let preSelectedItemView = getItemView(atIndex: preSeletedIndex)
            
            delegate?.segMegmentCtlView?(segMegmentCtlView: self, itemView: selectedItemView, selectedAt: selectedIndex)

            //点击的是当前的
            if selectedIndex == preSeletedIndex {
                return
            }
            
            if let preSelectedItemView = preSelectedItemView {
                var leftItemView = selectedItemView
                var rightItemView = preSelectedItemView
                if leftItemView.frame.origin.x > rightItemView.frame.origin.x {
                    leftItemView = preSelectedItemView
                    rightItemView = selectedItemView
                }
                
                selectedItemView.percentChange(percent: 1)
                preSelectedItemView.percentChange(percent: 0)
                
                if fabs(Double(preSeletedIndex - selectedIndex)) == 1 && contentOffsetAnimation{
                    let offset = CGPoint.init(x: CGFloat(selectedIndex) * associateScrollerView.bounds.width, y: 0)
                    associateScrollerView.setContentOffset(offset, animated: true)
                }else{
                    
                    //TODO:
                    let offset = CGPoint.init(x: CGFloat(selectedIndex) * associateScrollerView.bounds.width, y: 0)
                    associateScrollerView.setContentOffset(offset, animated: false)
                }
                segMentScrollerViewSrollerTo(itemView: selectedItemView, animated: true)
                
                UIView.animate(withDuration: 0.25) {
                    self.indicatorView.reloadIndicatorViewLayout(segMegmentCtlView: self, leftItemView: leftItemView, rightItemView: rightItemView)
                }

            }
        }
    }
    
    func segMentScrollerViewSrollerTo(itemView:LLSegmentCtlItemView,animated:Bool) {
        var offsetX = segMegmentScrollerView.contentOffset.x
        let targetCenter = itemView.center
        
        let boundsCenterX = bounds.width/2
        if let convertCenter = itemView.superview?.convert(targetCenter, to: self){
            offsetX -= boundsCenterX - convertCenter.x
            offsetX = max(0, min(offsetX, segMegmentScrollerView.contentSize.width - bounds.width))
            segMegmentScrollerView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: animated)
        }
    }
}

extension LLSegmentCtlView{
    func reloadSeparator() {
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
    public func reloadIndicatorView(indicatorView:LLIndicatorView){
        self.indicatorView.removeFromSuperview()
        let oldIndicatorViewCenterX = self.indicatorView.center.x
        var newIndicatorViewCenter = indicatorView.center
        newIndicatorViewCenter.x = oldIndicatorViewCenterX
        indicatorView.center = newIndicatorViewCenter
        segMegmentScrollerView.addSubview(indicatorView)
        self.indicatorView = indicatorView
    }
}

extension LLSegmentCtlView{
    public func reloadData(itemSpacing:CGFloat,segmentItemViewClass: LLSegmentCtlItemView.Type,itemViewStyle:LLSegmentCtlItemViewStyle,defaultSelectedIndex:NSInteger = 0) {
        for subView in segMegmentScrollerView.subviews{
            if subView != indicatorView {
                subView.removeFromSuperview()
            }else{
                segMegmentScrollerView.addSubview(indicatorView)
            }
        }
        itemViews.removeAll()
        var lastItemView:LLSegmentCtlItemView? = nil
        for (index,ctl) in ctls.enumerated() {
            let segmentCtlItemView = segmentItemViewClass.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: bounds.height))
            segmentCtlItemView.associateViewCtl = ctl
            segmentCtlItemView.setSegmentItemViewStyle(itemViewStyle: itemViewStyle)
            segmentCtlItemView.percentChange(percent: 0)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(itemViewClick(gesture:)))
            segmentCtlItemView.addGestureRecognizer(tapGesture)
            
            //size
            var segmentCtlItemViewFrame = segmentCtlItemView.frame
            segmentCtlItemViewFrame.size.width = segmentCtlItemView.itemWidth()
            segmentCtlItemViewFrame.size.height = self.bounds.height
            
            //origin
            if let lastItemView = lastItemView {
                var itemGap = itemSpacing
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
        if let firstItemView = getItemView(atIndex: 0) {
            firstItemView.percentChange(percent: 1)
            indicatorView.centerYGradientStyle = indicatorView.centerYGradientStyle
            indicatorView.reloadIndicatorViewLayout(segMegmentCtlView: self, leftItemView: firstItemView, rightItemView: firstItemView)
        }
        
        if let defaultSelectedItemView = getItemView(atIndex: defaultSelectedIndex) {
            defaultSelectedItemView.percentChange(percent: 1)
        }
        
        if let leftItemView = getItemView(atIndex: 0),
            let rightItemView = getItemView(atIndex: 1){
            delegate?.segMegmentCtlView?(segMegmentCtlView: self, leftItemView: leftItemView, rightItemView: rightItemView, percent: 0)
        }
    }
}

extension LLSegmentCtlView{
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == associateScrollerViewObserverKeyPath ,
            let newContentOffset = change?[NSKeyValueChangeKey.newKey] as? CGPoint,
            let oldContentOffset = change?[NSKeyValueChangeKey.oldKey] as? CGPoint,
            let scrollView = associateScrollerView{
            let userScroller = (scrollView.isTracking || scrollView.isDecelerating)
            
            if  scrollView.contentSize.width != 0 && scrollView.bounds.width != 0 && userScroller{
                contentOffsetChangeCalculation(newContentOffset: newContentOffset, oldContentOffset: oldContentOffset, scrollView: scrollView)
            }
            
            //用户停止拖拽
            if scrollView.isDecelerating {
                let selectedItemIndex = Int((newContentOffset.x + scrollView.bounds.width/2) / scrollView.bounds.width)
                if let selectedItem = getItemView(atIndex: selectedItemIndex) {
                    segMentScrollerViewSrollerTo(itemView: selectedItem, animated: true)
                }
            }
        }
    }
    
    
    func contentOffsetChangeCalculation(newContentOffset:CGPoint,oldContentOffset:CGPoint,scrollView:UIScrollView) {
        let isScrollerToRight = (newContentOffset.x - oldContentOffset.x > 0)
        let leftFirstItem = Int(newContentOffset.x / scrollView.bounds.width)
        var currentItem = 0
        var targetItem = 0
        var percent:CGFloat = 0
        if isScrollerToRight {
            currentItem = leftFirstItem
            targetItem = leftFirstItem + 1
            percent = 1 - (CGFloat(targetItem)*scrollView.bounds.width - newContentOffset.x) / scrollView.bounds.width
        }else{
            currentItem = leftFirstItem + 1
            targetItem = leftFirstItem
            percent = (newContentOffset.x - CGFloat(targetItem)*scrollView.bounds.width) / scrollView.bounds.width
        }
        
        if (currentItem < 0 || currentItem >= ctls.count) || (targetItem < 0 || targetItem >= ctls.count){
            return
        }
        
        let leftItemIndex = Int(newContentOffset.x / scrollView.bounds.width)
        let rightItemIndex = leftFirstItem + 1
        if let leftItemView = getItemView(atIndex: leftItemIndex),
            let rightItemView = getItemView(atIndex: rightItemIndex) {
            
            contentOffsetChangeAction(leftItemView: leftItemView, rightItemView: rightItemView, percent: percent)
        }
    }
    
    func contentOffsetChangeAction(leftItemView:LLSegmentCtlItemView,rightItemView:LLSegmentCtlItemView,percent:CGFloat) {
        let leftPercent = 1 - percent
        let rightPercent = percent
        let rang = CGFloat(0)...CGFloat(1)
        if rang.contains(leftPercent) && rang.contains(rightPercent){
        
            leftItemView.contentOffsetOnRight = false
            rightItemView.contentOffsetOnRight = true
            leftItemView.percentChange(percent: leftPercent)
            rightItemView.percentChange(percent: rightPercent)
            
            indicatorView.reloadIndicatorViewLayout(segMegmentCtlView: self, leftItemView: leftItemView, rightItemView: rightItemView)
            delegate?.segMegmentCtlView?(segMegmentCtlView: self, leftItemView: leftItemView, rightItemView: rightItemView, percent: percent)
        }
    }
    
}


extension LLSegmentCtlView{
    func initSubviews() {
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
    
    func getItemView(atIndex:NSInteger) -> LLSegmentCtlItemView? {
        if atIndex < 0 || atIndex >= itemViews.count {
            return nil
        }
        return itemViews[atIndex]
    }
}

