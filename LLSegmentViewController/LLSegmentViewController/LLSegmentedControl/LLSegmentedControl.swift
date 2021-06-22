//
//  LLSegmentCtl.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/18.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit


@objc public protocol LLSegmentedControlDelegate : NSObjectProtocol {
    /********回调信息*****/
    @objc optional func segMegmentCtlView(segMegmentCtlView: LLSegmentedControl, itemView: LLSegmentBaseItemView,itemSpacing atIndex:NSInteger) -> CGFloat
    @objc optional func segMegmentCtlView(segMegmentCtlView: LLSegmentedControl,totalPercent:CGFloat)

    
    /********点击ItemView*****/
    @objc optional func segMegmentCtlView(segMegmentCtlView: LLSegmentedControl, clickItemAt sourceItemView: LLSegmentBaseItemView, to destinationItemView: LLSegmentBaseItemView)
    @objc optional func segMegmentCtlView(segMegmentCtlView: LLSegmentedControl, sourceItemView: LLSegmentBaseItemView, shouldChangeTo destinationItemView: LLSegmentBaseItemView)->Bool

    /*******滚动ContentView*****/
    @objc optional func segMegmentCtlView(segMegmentCtlView: LLSegmentedControl,dragToScroll leftItemView:LLSegmentBaseItemView,rightItemView:LLSegmentBaseItemView)
    @objc optional func segMegmentCtlView(segMegmentCtlView: LLSegmentedControl,dragToSelected itemView: LLSegmentBaseItemView)
}


public struct LLSegmentedControlStyle{
    public var itemSpacing:CGFloat = 0
    public var segmentItemViewClass:LLSegmentBaseItemView.Type = LLSegmentItemTitleView.self
    public var itemViewStyle:LLSegmentItemViewStyle = LLSegmentItemViewStyle()
    public var defaultSelectedIndex:NSInteger = 0
    public var contentInset = UIEdgeInsets.zero
    public init(){}
}

open class LLSegmentedControl: UIView {
    //----------------------separatorLine-----------------------// 设置完成后调用reloadSeparator方法，刷新分割线样式
    public var separatorLineShowEnabled = false
    public var separatorLineColor = UIColor.lightGray
    public var separatorLineWidth = 1/UIScreen.main.scale
    public var separatorTopBottomMargin:(top:CGFloat,bottom:CGFloat) = (0,0)
    private var separatorViews = [UIView]()
    
    //----------------------public设置属性-----------------------//
    public var clickAnimation = true
    public weak var delegate:LLSegmentedControlDelegate?
    public private (set) var indicatorView = LLIndicatorView(frame:CGRect.init(x: 0, y: 0, width: 10, height: 3))
    public private (set) var currentSelectedItemView:LLSegmentBaseItemView!
    public private (set) var leftItemView:LLSegmentBaseItemView!
    public private (set) var rightItemView:LLSegmentBaseItemView!
    public private (set) var itemViews = [LLSegmentBaseItemView]()
    public var ctlViewStyle = LLSegmentedControlStyle()
    public var bottomSeparatorStyle:(height:CGFloat,color:UIColor) = (1,UIColor.clear){
        didSet{
            var bottomSeparatorLineViewFrame = bottomSeparatorLineView.frame
            bottomSeparatorLineViewFrame.size.height = bottomSeparatorStyle.height
            bottomSeparatorLineViewFrame.origin.y = bounds.height - bottomSeparatorStyle.height
            bottomSeparatorLineView.frame = bottomSeparatorLineViewFrame
            bottomSeparatorLineView.backgroundColor = bottomSeparatorStyle.color
        }
    }
    
    //----------------------private-----------------------//
    private let associateScrollerViewObserverKeyPath = "contentOffset"
    private var totalPercent:CGFloat = 0
    internal var titles:[String]!
    internal var ctls = [UIViewController]()
    private let segMegmentScrollerView = UIScrollView(frame: CGRect.zero)
    private let bottomSeparatorLineView = UIView()
    private var itemAndSeparatorViews = [(itemView:LLSegmentBaseItemView,separatorView:UIView)]()
    public weak var associateScrollerView:UIScrollView? {
        didSet{
            associateScrollerView?.addObserver(self, forKeyPath: associateScrollerViewObserverKeyPath, options: [.new,.old], context: nil)
        }
    }
    init(frame: CGRect,titles:[String]) {
        super.init(frame: frame)
        self.titles = titles
        initSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        associateScrollerView?.removeObserver(self, forKeyPath: associateScrollerViewObserverKeyPath)
    }
    
    public func reloadData(ctlViewStyle:LLSegmentedControlStyle? = nil) {
        if let ctlViewStyle = ctlViewStyle {
            self.ctlViewStyle = ctlViewStyle
        }
        
        removeItemViews()
        reloadItemViews()
        reLayoutItemViews()
        setDefaultSelectedAtIndexStatu()
    }
}

//MARK:- ************************************** API调用接口 **************************************
extension LLSegmentedControl{
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


extension LLSegmentedControl{
    public func reLayoutItemViews() {
        var lastItemView:LLSegmentBaseItemView? = nil
        for (offset: index,element: (itemView: segmentCtlItemView,separatorView: separatorView)) in itemAndSeparatorViews.enumerated() {
            //size
            var segmentCtlItemViewFrame = segmentCtlItemView.frame
            segmentCtlItemViewFrame.size.width = segmentCtlItemView.itemWidth()
            segmentCtlItemViewFrame.size.height = self.bounds.height
            
            //origin
            if let lastItemView = lastItemView {
                var itemGap = self.ctlViewStyle.itemSpacing
                if let gap = delegate?.segMegmentCtlView?(segMegmentCtlView: self, itemView: segmentCtlItemView, itemSpacing: index) {
                    itemGap += gap
                }
                segmentCtlItemViewFrame.origin.x = lastItemView.frame.maxX + itemGap
            }
            segmentCtlItemViewFrame.origin.y = (bounds.height - segmentCtlItemViewFrame.size.height) / 2
            segmentCtlItemView.frame = segmentCtlItemViewFrame
            
            //分割线
            if lastItemView != nil {
                separatorView.center.x = (lastItemView!.frame.maxX + segmentCtlItemView.frame.minX)/2
            }else{
                separatorView.isHidden = true
            }
            lastItemView = segmentCtlItemView
        }
        segMegmentScrollerView.contentSize = CGSize.init(width: lastItemView?.frame.maxX ?? bounds.width, height: bounds.height)
        segMegmentScrollerView.contentInset = ctlViewStyle.contentInset
        segMegmentScrollerView.contentOffset = CGPoint.init(x: -ctlViewStyle.contentInset.left, y: 0)
    }

    //初始化设置状态和位置
    internal func setDefaultSelectedAtIndexStatu(){
        if let defaultSelectedItemView = getItemView(atIndex: self.ctlViewStyle.defaultSelectedIndex) {
            defaultSelectedItemView.percentChange(percent: 1)
            currentSelectedItemView = defaultSelectedItemView
            rightItemView = defaultSelectedItemView
            leftItemView = defaultSelectedItemView
            
            segmentScrollerViewSrollerToCenter(itemView: defaultSelectedItemView, animated: false)
            if let associateScrollerView = associateScrollerView {
                let offsetX = CGFloat(defaultSelectedItemView.index)*associateScrollerView.bounds.width
                associateScrollerView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: false)
            }
            
            indicatorView.centerYGradientStyle = indicatorView.centerYGradientStyle
            indicatorView.reloadLayout(leftItemView: defaultSelectedItemView, rightItemView: defaultSelectedItemView)
            
            totalPercent = 1.0/CGFloat(titles.count)
            delegate?.segMegmentCtlView?(segMegmentCtlView: self, totalPercent: totalPercent)
        }
    }
}

//MARK:- **************************************** 点击处理 ************************************
extension LLSegmentedControl{
    @objc func segmentItemClick(gesture:UITapGestureRecognizer) {
        if let sourceItemView = currentSelectedItemView,
            let destinationItemView = gesture.view as? LLSegmentBaseItemView{
            checkOutItemView(sourceItemView: sourceItemView, destinationItemView: destinationItemView)
        }
    }
    
    private func checkOutItemView(sourceItemView:LLSegmentBaseItemView,destinationItemView:LLSegmentBaseItemView){
        //有些类型要处理点击的情况
        delegate?.segMegmentCtlView?(segMegmentCtlView: self, clickItemAt: sourceItemView, to: destinationItemView)
        
        //点击的是当前的
        if sourceItemView == destinationItemView {
            return
        }
        
        //询问代理点击是否切换
        let shouldCheckOut = delegate?.segMegmentCtlView?(segMegmentCtlView: self, sourceItemView: sourceItemView, shouldChangeTo: destinationItemView)
        if shouldCheckOut != true && shouldCheckOut != nil{
            return
        }
        
        //ItemView响应
        checkOutItemViewAction(sourceItemView: sourceItemView, destinationItemView: destinationItemView)
        
        //associateScrollerView和segMegmentScrollerView响应
        checkOutItemContentViewAction(sourceItemView: sourceItemView, destinationItemView: destinationItemView)
        
        //segMegmentScrollerView响应
        segmentScrollerViewSrollerToCenter(itemView: destinationItemView, animated: clickAnimation)
        
        //指示器响应
        checkOutItemIndicatorViewAction(sourceItemView: sourceItemView, destinationItemView: destinationItemView)
    }
    
    //ItemView响应
    private func checkOutItemViewAction(sourceItemView:LLSegmentBaseItemView,destinationItemView:LLSegmentBaseItemView){
        sourceItemView.percentChange(percent: 0)
        destinationItemView.percentChange(percent: 1)
        leftItemView = destinationItemView
        rightItemView = destinationItemView
        currentSelectedItemView = destinationItemView
    }
    
    //associateScrollerView响应
    private func checkOutItemContentViewAction(sourceItemView:LLSegmentBaseItemView,destinationItemView:LLSegmentBaseItemView){
        let gap = abs(CGFloat(sourceItemView.index - destinationItemView.index))
        let offsetX = CGFloat(destinationItemView.index) * associateScrollerView!.bounds.width
        let offset = CGPoint.init(x: offsetX, y: 0)
        if gap == 1 && clickAnimation{
            associateScrollerView?.setContentOffset(offset, animated: true)
        }else{
            associateScrollerView?.setContentOffset(offset, animated: false)
        }
    }
    
    //IndicatorView响应
    private func checkOutItemIndicatorViewAction(sourceItemView:LLSegmentBaseItemView,destinationItemView:LLSegmentBaseItemView){
        var leftItemView = sourceItemView
        var rightItemView = destinationItemView
        if leftItemView.frame.origin.x > rightItemView.frame.origin.x {
            leftItemView = destinationItemView
            rightItemView = sourceItemView
        }
        let animationDuration = clickAnimation ? 0.25 : 0
        UIView.animate(withDuration: animationDuration) {
            self.indicatorView.reloadLayout(leftItemView: leftItemView, rightItemView: rightItemView)
        }
    }
}

//MARK:- **************************************** ContentView滚动处理 ************************************
extension LLSegmentedControl{
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard titles != nil && titles.count > 0 else {
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
        if let leftAndRightItemView = getLeftAndRightItemView(){
            contentOffsetChangeViewAction(leftItemView: leftAndRightItemView.leftItemView,
                                          rightItemView: leftAndRightItemView.rightItemView)
            
            delegate?.segMegmentCtlView?(segMegmentCtlView: self, dragToScroll: leftItemView, rightItemView: rightItemView)
        }
    }
    
    private func contentOffsetChangeViewAction(leftItemView:LLSegmentBaseItemView,rightItemView:LLSegmentBaseItemView) {
        //边界情况:快速滑动的情况,contentOffset的变化是不连续的
        if (leftItemView,rightItemView) != (self.leftItemView,self.rightItemView) {
            let curentItemViews = [leftItemView,rightItemView]
            if !curentItemViews.contains(self.leftItemView){
                self.leftItemView.percentChange(percent: 0)
            }else if !curentItemViews.contains(self.rightItemView){
                self.rightItemView.percentChange(percent: 0)
            }
            
            //segMegmentScrollerView Follow rolling:segMegmentScrollerView跟随用户的滑动
            var scrollerPageItemView = leftItemView
            if rightItemView.percent >= 0.5 {
                scrollerPageItemView = rightItemView
            }
            segmentScrollerViewSrollerToCenter(itemView: scrollerPageItemView, animated: true)
            
            //滚动选中
            if scrollerPageItemView != currentSelectedItemView{
                currentSelectedItemView = scrollerPageItemView
                delegate?.segMegmentCtlView?(segMegmentCtlView: self, dragToSelected: currentSelectedItemView)
            }
        }
        

        self.leftItemView = leftItemView
        self.rightItemView = rightItemView
        indicatorView.reloadLayout(leftItemView: leftItemView, rightItemView: rightItemView)
    }
}


//MARK:- **************************************** Tool方法 ************************************
extension LLSegmentedControl{
    private func getLeftAndRightItemView()->(leftItemView:LLSegmentBaseItemView,rightItemView:LLSegmentBaseItemView)?{
        guard titles != nil && titles.count > 0 else {
            return nil
        }
        
        guard let associateScrollerView = associateScrollerView else {
            return nil
        }

        //边界,最右边和最左边的情况
        let basePercent = associateScrollerView.contentOffset.x/associateScrollerView.contentSize.width
        let drageRange = basePercent...1
        if totalPercent < drageRange.lowerBound {
            leftItemView.percentChange(percent: 1)
            indicatorView.reloadLayout(leftItemView: leftItemView, rightItemView: leftItemView)
        }
        if totalPercent > drageRange.upperBound {
            indicatorView.reloadLayout(leftItemView: rightItemView, rightItemView: rightItemView)
            rightItemView.percentChange(percent: 1)
        }
        if !drageRange.contains(totalPercent){
            return nil
        }
        
        //计算leftItemIndex,rightItemIndex
        let index = associateScrollerView.contentOffset.x/associateScrollerView.bounds.width
        let leftItemIndex = max(0, min(titles.count - 1, Int((index))))
        let rightItemIndex = max(0, min(titles.count - 1, Int(ceil(index))))
        var rightPercent = CGFloat(index) - CGFloat(leftItemIndex)
        var leftPercent = 1 - rightPercent
        if leftItemIndex == rightItemIndex {
            leftPercent = 1
            rightPercent = 1
        }
        
        if let leftItemView = getItemView(atIndex: leftItemIndex),
            let rightItemView = getItemView(atIndex: rightItemIndex) {
            
            leftItemView.contentOffsetOnRight = false
            rightItemView.contentOffsetOnRight = true
            leftItemView.percentChange(percent: leftPercent)
            rightItemView.percentChange(percent: rightPercent)
            return (leftItemView,rightItemView)
        }
        return nil
    }
    
    private  func segmentScrollerViewSrollerToCenter(itemView:LLSegmentBaseItemView,animated:Bool) {
        var offsetX = segMegmentScrollerView.contentOffset.x
        let targetCenter = itemView.center
         
        let boundsCenterX = bounds.width/2
        if let convertCenter = itemView.superview?.convert(targetCenter, to: self){
            offsetX -= (boundsCenterX - convertCenter.x)
            offsetX = max(0, min(offsetX, segMegmentScrollerView.contentSize.width - bounds.width))
            segMegmentScrollerView.setContentOffset(CGPoint.init(x: offsetX - ctlViewStyle.contentInset.left, y: 0), animated: animated)
        }
    }
}

extension LLSegmentedControl{
    internal func removeItemViews(){
        for subView in segMegmentScrollerView.subviews{
            if subView != indicatorView {
                subView.removeFromSuperview()
            }
        }
        itemViews.removeAll()
        itemAndSeparatorViews.removeAll()
    }
    
    internal func reloadItemViews(){
        let ItemViewClass = self.ctlViewStyle.segmentItemViewClass
        for (index,title) in titles.enumerated() {
            //ItemView
            let segmentCtlItemView = ItemViewClass.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: bounds.height))
            if ctls.count > index {
                segmentCtlItemView.bindAssociateViewCtl(ctl: ctls[index])
            }
            segmentCtlItemView.setSegmentItemViewStyle(itemViewStyle: self.ctlViewStyle.itemViewStyle)
            segmentCtlItemView.titleChange(title: title)
            segmentCtlItemView.percentChange(percent: 0)
            segmentCtlItemView.index = index
            segmentCtlItemView.indicatorView = indicatorView
            
            segMegmentScrollerView.addSubview(segmentCtlItemView)
            itemViews.append(segmentCtlItemView)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(segmentItemClick(gesture:)))
            segmentCtlItemView.addGestureRecognizer(tapGesture)
            
            //分割线
            let separatorView = UIView()
            reloadOneSeparatorView(separatorView: separatorView)
            separatorViews.append(separatorView)
            segMegmentScrollerView.addSubview(separatorView)

            let itemAndSeparatorView = (segmentCtlItemView,separatorView)
            itemAndSeparatorViews.append(itemAndSeparatorView)
        }
    }
}

extension LLSegmentedControl{
    internal func selected(at Index:NSInteger,animation:Bool)  {
        if let targetItemView = getItemView(atIndex: Index),
            let currentSelectedItemView = currentSelectedItemView,
            targetItemView != currentSelectedItemView{
            let preAnimation = clickAnimation
            clickAnimation = animation
            checkOutItemView(sourceItemView: currentSelectedItemView, destinationItemView: targetItemView)
            clickAnimation = preAnimation
        }
    }
    
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
        
        bottomSeparatorLineView.backgroundColor = bottomSeparatorStyle.color
        bottomSeparatorLineView.frame = CGRect.init(x: 0, y: bounds.height - bottomSeparatorStyle.height, width: bounds.width, height: bottomSeparatorStyle.height)
        bottomSeparatorLineView.autoresizingMask = [.flexibleWidth,.flexibleTopMargin]
        addSubview(bottomSeparatorLineView)
    }
    
    private func getItemView(atIndex:NSInteger) -> LLSegmentBaseItemView? {
        if atIndex < 0 || atIndex >= itemViews.count {
            return nil
        }
        return itemViews[atIndex]
    }
}

