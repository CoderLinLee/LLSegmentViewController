//
//  LLScrollView.swift
//  LLScrollerView
//
//  Created by lilin on 2019/1/17.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit




@objc public protocol LLContainerScrollViewDagDelegate:NSObjectProtocol {
    func scrollView(scrollView:LLContainerScrollView,shouldScrollWithSubView subView:UIScrollView) -> Bool
    func scrollView(scrollView:LLContainerScrollView,dragTop progress:CGFloat)
}

open class LLContainerScrollView: UIScrollView {
    public var paralaxHeader = LLSubViewsLayoutInfo()
    internal weak var dragDeleage:LLContainerScrollViewDagDelegate?
    private var observedViews = [UIScrollView]()
    
    private let observerKeyPath = "contentOffset"
    private let observerOptions:NSKeyValueObservingOptions = [.old,.new]
    private var observerContext = 0
    
    private var isObserving = true
    private var lock = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initialize() {
        self.showsVerticalScrollIndicator = false
        self.isDirectionalLockEnabled = true
        self.bounces = true
        self.delegate = self
        self.panGestureRecognizer.cancelsTouchesInView = false
        self.addObserver(self, forKeyPath: observerKeyPath, options: observerOptions, context: &observerContext)
    }
    
    deinit {
        self.removeObservedViews()
        self.removeObserver(self, forKeyPath: observerKeyPath, context: &observerContext)
    }
    
    public func layoutParalaxHeader(){
        if let headView = paralaxHeader.headView  {
            self.contentInset = UIEdgeInsetsMake(headView.bounds.height, 0, 0, 0)
            headView.center = CGPoint.init(x: bounds.width/2, y: -headView.bounds.height/2)
            insertSubview(headView, at: 0)
            self.contentOffset = CGPoint.init(x: 0, y: -self.contentInset.top)
        }
                
        switch paralaxHeader.refreshType {
        case .container:
            self.bounces = true
        default:
            self.bounces = false
        }
    }
}

extension LLContainerScrollView{
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollView = object as? UIScrollView else {
            return
        }

        if keyPath == observerKeyPath ,
        let newContentOffset = change?[NSKeyValueChangeKey.newKey] as? CGPoint,
        let oldContentOffset = change?[NSKeyValueChangeKey.oldKey] as? CGPoint{
            let diff = oldContentOffset.y - newContentOffset.y
            if diff == 0 || !isObserving { return }
            
            switch paralaxHeader.refreshType{
            case .list:
                if scrollView == self {
                    listRefreshSelfHandle(newContentOffset: newContentOffset, oldContentOffset: oldContentOffset)
                }else{
                    listRefreshOtherScrollViewHandle(scrollView: scrollView, newContentOffset: newContentOffset, oldContentOffset: oldContentOffset)
                }
            case .container:
                if scrollView == self {
                    containerRefreshSelfHandle(newContentOffset: newContentOffset, oldContentOffset: oldContentOffset)
                }else{
                    containerRefreshOtherScrollViewHandle(scrollView: scrollView, newContentOffset: newContentOffset, oldContentOffset: oldContentOffset)
                }
            }
        }
    }
}

extension LLContainerScrollView {
    func listRefreshOtherScrollViewHandle(scrollView:UIScrollView, newContentOffset:CGPoint,oldContentOffset:CGPoint) {
        lock = (scrollView.contentOffset.y > -scrollView.contentInset.top)
        //Manage scroll up
        let minimumHeight = -paralaxHeader.minimumHeight
        if self.contentOffset.y > -self.contentInset.top && self.contentOffset.y < minimumHeight {
            self.scrollView(scrollView: scrollView, contentOffset: CGPoint.zero)
        }
    }
    
    func listRefreshSelfHandle(newContentOffset:CGPoint,oldContentOffset:CGPoint) {
        let diff = oldContentOffset.y - newContentOffset.y
        if diff > 0 && lock {
            self.scrollView(scrollView: self, contentOffset: oldContentOffset)
        }else if self.contentOffset.y < -self.contentInset.top {
            self.scrollView(scrollView: self, contentOffset: CGPoint.init(x: self.contentOffset.x, y: -self.contentInset.top))
        }else if self.contentOffset.y > (contentInset.bottom+contentSize.height - bounds.height) {
            self.scrollView(scrollView: self, contentOffset: CGPoint.init(x: self.contentOffset.x, y: (contentInset.bottom+contentSize.height - bounds.height)))
        }
    }
}

extension LLContainerScrollView {
    func containerRefreshOtherScrollViewHandle(scrollView:UIScrollView, newContentOffset:CGPoint,oldContentOffset:CGPoint) {
        //Adjust the observed scrollview's content offset
        lock = (scrollView.contentOffset.y > -scrollView.contentInset.top)
        
        let minimumHeight = -paralaxHeader.minimumHeight
        if self.contentOffset.y < minimumHeight {
            self.scrollView(scrollView: scrollView, contentOffset: CGPoint.zero)
        }
    }
    
    func containerRefreshSelfHandle(newContentOffset:CGPoint,oldContentOffset:CGPoint) {
        let diff = oldContentOffset.y - newContentOffset.y
        let minimumHeight = -self.paralaxHeader.minimumHeight
        //Adjust self scroll offset when scroll down
        if diff > 0 && lock{
            self.scrollView(scrollView: self, contentOffset: oldContentOffset)
        }else if self.contentOffset.y < -self.contentInset.top && !self.bounces {
            self.scrollView(scrollView: self, contentOffset: CGPoint.init(x: self.contentOffset.x, y: -self.contentInset.top))
        }else if self.contentOffset.y > minimumHeight {
            self.scrollView(scrollView: self, contentOffset: CGPoint.init(x: self.contentOffset.x, y: minimumHeight))
        }
        
        if self.contentOffset.y + self.paralaxHeader.minimumHeight <= -self.contentInset.top,
            let _ = paralaxHeader.headView,
            self.contentInset.top > 0{
            let contentInsetTop = self.contentInset.top
            let progress = fabs(self.contentOffset.y + self.paralaxHeader.minimumHeight + contentInsetTop)/contentInsetTop
            self.dragDeleage?.scrollView(scrollView: self, dragTop: progress)
        }else{
            self.dragDeleage?.scrollView(scrollView: self, dragTop: 0)
        }
        
        var progress:CGFloat = 0
        if self.contentInset.top != self.paralaxHeader.minimumHeight {
            progress = (self.contentOffset.y + self.paralaxHeader.minimumHeight) / (-self.contentInset.top + self.paralaxHeader.minimumHeight)
        }
        print(self.contentOffset.y,progress)
    }
}


extension LLContainerScrollView{
    func scrollView(scrollView:UIScrollView,contentOffset:CGPoint) {
        isObserving = false
        scrollView.contentOffset = contentOffset
        isObserving = true
    }
}

//observedViewManager
extension LLContainerScrollView{
    func removeObservedViews() {
        for scrollView in observedViews{
            scrollView.removeObserver(self, forKeyPath: observerKeyPath, context: &observerContext)
        }
        observedViews.removeAll()
    }
    
    func addObservedView(scrollView:UIScrollView)  {
        if !self.observedViews.contains(scrollView) {
            self.observedViews.append(scrollView)
            lock = (scrollView.contentOffset.y > -scrollView.contentInset.top)
            scrollView.addObserver(self, forKeyPath: observerKeyPath, options: observerOptions, context: &observerContext)
        }
    }
}

extension LLContainerScrollView : UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        lock = false
        self.removeObservedViews()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate && paralaxHeader.refreshType == .list{
            lock = false
            self.removeObservedViews()
        }
    }
}

extension LLContainerScrollView : UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.view == self {
            return false
        }
        
        guard let otherGestureRecognizer = otherGestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        
        let velocity = otherGestureRecognizer.velocity(in: self)
        if fabs(velocity.x) > fabs(velocity.y) {
            return false
        }
        
        // Consider scroll view pan only
        guard let scrollView = otherGestureRecognizer.view as? UIScrollView else { return false }
        
        // Tricky case: UITableViewWrapperView
        if scrollView.superview?.isKind(of: UITableView.classForCoder()) == true {
            return false
        }
        
        var shouldScroll = true
        if dragDeleage?.scrollView(scrollView: self, shouldScrollWithSubView: scrollView) == true{
            shouldScroll = true
            self.addObservedView(scrollView: scrollView)
        }else{
            shouldScroll = false
        }
        return shouldScroll
    }
}




