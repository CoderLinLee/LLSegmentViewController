//
//  LLViewControllerContainerView.swift
//  LLScrollerView
//
//  Created by apple on 2019/1/17.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

public protocol LLCtlPageViewDataSource: NSObjectProtocol {
    func numberOfItems(in pageView: LLCtlPageView) -> Int
    func pageView(_ pageView: LLCtlPageView, viewForItemAt index: NSInteger) -> UIView
}

open class LLCtlPageView: UIScrollView {
    //预加载范围，当前view前面几个，后面几个
    public var preLoadRange = 0...0
    
    private var itemCount = 0
    internal weak var dataSoure: LLCtlPageViewDataSource! {
        didSet {
            reloadData()
        }
    }
    
    init(frame: CGRect, ctls: [UIViewController]) {
        super.init(frame: frame)
        initSubViews()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initSubViews() {
        self.delegate = self
        self.backgroundColor = UIColor.clear
        self.isPagingEnabled = true
        self.bounces = false
        self.contentInset = UIEdgeInsets.zero
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.isDirectionalLockEnabled = true
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
}

extension LLCtlPageView {
    internal func reloadCurrentIndex(index: NSInteger) {
        self.contentOffset = CGPoint.init(x: CGFloat(index)*self.bounds.width, y: 0)
    }
    
    internal func reloadData() {
        itemCount = dataSoure.numberOfItems(in: self)
        self.contentSize = CGSize.init(width: CGFloat(itemCount)*self.bounds.width, height: self.bounds.height)
        
        reloadCurrentShowView()
    }
    
    fileprivate func reloadCurrentShowView() {
        guard itemCount > 0 else { return }
        
        let showPages = getShowPageIndex(maxCount: itemCount - 1)
        var pages = [NSInteger]()
        let left = showPages.leftIndex - preLoadRange.lowerBound
        let right = showPages.rightIndex + preLoadRange.upperBound
        for index in left...right {
            if (0...itemCount-1).contains(index) {
                pages.append(index)
            }
        }
        
        for index in pages {
            let showView = dataSoure.pageView(self, viewForItemAt: index)
            showView.frame = CGRect.init(x: CGFloat(index)*bounds.width, y: 0, width: bounds.width, height: bounds.height)
            if !subviews.contains(showView) {
                addSubview(showView)
            }
        }
    }
}

extension LLCtlPageView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer, let otherGestureRecognizer = otherGestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        
        guard let gestureView = gestureRecognizer.view as? LLCtlPageView else {
            return false
        }
        
        guard let otherGestureView = otherGestureRecognizer.view as? LLCtlPageView else {
            return false
        }

        if gestureView != self {
            return false
        }
        
        let currentIndex = Int(gestureView.contentOffset.x / gestureView.bounds.width)
        let currentItemCount = gestureView.itemCount
        // let subIndex = Int(otherGestureView.contentOffset.x / otherGestureView.bounds.width)
        // let subItemCount = otherGestureView.itemCount
        let isCurrentSupper: Bool = otherGestureView.isDescendant(of: gestureView)
        let isMoveLeft: Bool = gestureRecognizer.velocity(in: self).x > 0
        
        var result: Bool = false
        if isCurrentSupper {
            result = false
        } else {
            if isMoveLeft && currentIndex == 0 {
                return true
            } else if isMoveLeft == false && currentIndex == currentItemCount - 1 {
                result = true
            } else {
                result = false
            }
        }
        // print("currentIndex: \(currentIndex), currentItemCount: \(currentItemCount), subIndex: \(subIndex), subItemCount: \(subItemCount), result: \(result), isCurrentSupper: \(isCurrentSupper), isMoveLeft: \(isMoveLeft)")
        return result
    }
}

extension LLCtlPageView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        reloadCurrentShowView()
    }
}

extension UIScrollView {
    fileprivate func getShowPageIndex(maxCount: NSInteger) -> (leftIndex: NSInteger, rightIndex: NSInteger) {
        let index = self.contentOffset.x/self.bounds.width
        let leftItemIndex = max(0, min(maxCount, Int((index))))
        let rightItemIndex = max(0, min(maxCount, Int(ceil(index))))
        return (leftItemIndex, rightItemIndex)
    }
}
