//
//  LLViewControllerContainerView.swift
//  LLScrollerView
//
//  Created by apple on 2019/1/17.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

public protocol LLCtlPageViewDataSource:NSObjectProtocol {
    func numberOfItems(in pageView:LLCtlPageView) -> Int
    func pageView(_ pageView: LLCtlPageView, viewForItemAt index: NSInteger) -> UIView
}


open class LLCtlPageView: UIView {
    var containerScrollView:UIScrollView!
    var preLoadRange = 0...10
    private var itemCount = 0
    var dataSoure:LLCtlPageViewDataSource!{
        didSet{
            reloadData()
        }
    }
    
    init(frame: CGRect,ctls:[UIViewController]) {
        super.init(frame: frame)
        initSubViews()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews() {
        containerScrollView = UIScrollView(frame: bounds)
        containerScrollView.delegate = self
        containerScrollView.backgroundColor = UIColor.black
        containerScrollView.isPagingEnabled = true
        containerScrollView.bounces = false
        containerScrollView.contentInset = UIEdgeInsets.zero
        containerScrollView.showsHorizontalScrollIndicator = false
        containerScrollView.showsVerticalScrollIndicator = false
        containerScrollView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        containerScrollView.isDirectionalLockEnabled = true
        addSubview(containerScrollView)
        if #available(iOS 11.0, *) {
            containerScrollView.contentInsetAdjustmentBehavior = .never
        }
    }
}

extension LLCtlPageView{
    internal func reloadCurrentIndex(index:NSInteger){
        containerScrollView.contentOffset = CGPoint.init(x: CGFloat(index)*self.bounds.width, y: 0)
    }
    
    internal func reloadData() {
        itemCount = dataSoure.numberOfItems(in: self)
        self.containerScrollView.contentSize = CGSize.init(width: CGFloat(itemCount)*self.bounds.width, height: self.bounds.height)
        
        reloadCurrentShowView()
    }
    
    fileprivate func reloadCurrentShowView() {
        guard itemCount > 0 else { return }
        
        let showPages = containerScrollView.getShowPageIndex(maxCount: itemCount - 1)
        var pages = [NSInteger]()
        let left = showPages.leftIndex - preLoadRange.lowerBound
        let right = showPages.rightIndex + preLoadRange.upperBound
        for index in left...right {
            if (0...itemCount-1).contains(index){
                pages.append(index)
            }
        }
        
        for index in pages {
            let showView = dataSoure.pageView(self, viewForItemAt: index)
            showView.frame = CGRect.init(x: CGFloat(index)*bounds.width, y: 0, width: bounds.width, height: bounds.height)
            if !containerScrollView.subviews.contains(showView){
                containerScrollView.addSubview(showView)
            }
        }
    }
}


extension LLCtlPageView:UIScrollViewDelegate{
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        reloadCurrentShowView()
    }
}

extension UIScrollView{
    func getShowPageIndex(maxCount:NSInteger) -> (leftIndex:NSInteger,rightIndex:NSInteger) {
        let index = self.contentOffset.x/self.bounds.width
        let leftItemIndex = max(0, min(maxCount, Int((index))))
        let rightItemIndex = max(0, min(maxCount, Int(ceil(index))))
        return (leftItemIndex,rightItemIndex)
    }
}


