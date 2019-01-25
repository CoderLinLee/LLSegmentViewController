//
//  LLSegmentViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/18.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit

//下拉刷新控件的位置
public enum LLDragRefreshType {
    case container
    case list
}

//分段控件的位置
public enum LLSegmentedCtontrolPositionType {
    case nav(size:CGSize)
    case top(size:CGSize)
    case bottom(size:CGSize)
}

//控件布局位置信息
public class LLSubViewsLayoutInfo:NSObject{
    public var minimumHeight:CGFloat = 64
    public var progress:CGFloat = 1
    public var segmentControlPositionType:LLSegmentedCtontrolPositionType = .top(size: CGSize.init(width: UIScreen.main.bounds.width, height: 50))
    public var refreshType = LLDragRefreshType.container
    public var headView:UIView?
}





 open class LLSegmentViewController: UIViewController {
    public let layoutInfo = LLSubViewsLayoutInfo()
    public let segmentCtlView = LLSegmentedControl(frame: CGRect.zero)
    public var ctls = [UIViewController]()
    private let cellIdentifier = "cellIdentifier"
    public var pageView:LLCtlPageView!
    public var containerScrView = LLContainerScrollView()

    let layout = UICollectionViewFlowLayout()
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        initSubviews()
        relayoutSubViews()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        if let screenEdgePanGestureRecognizer = getScreenEdgePanGestureRecognizer() {
            containerScrView.panGestureRecognizer.require(toFail: screenEdgePanGestureRecognizer)
            pageView.containerScrollView.panGestureRecognizer.require(toFail: screenEdgePanGestureRecognizer)
        }
    }
}

extension LLSegmentViewController{
    public func closeAutomaticallyAdjusts() {
        if #available(iOS 11.0, *) {
            self.containerScrView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    public func relayoutSubViews() {
        let screenW = UIScreen.main.bounds.width
        let screenH = UIScreen.main.bounds.height
        
        var segmentControlSize:CGSize = CGSize.zero
        var containerFrameY:CGFloat = 0
        var segmentCtlViewY:CGFloat = 0
        var containerHeight:CGFloat = 0

        switch layoutInfo.segmentControlPositionType {
        case .nav(let size):
            containerHeight = screenH - (containerScrView.paralaxHeader.minimumHeight)
            containerFrameY = 0
            
            segmentControlSize = size
            segmentCtlViewY = 0
            
        case .top(let size):
            let height = size.height
            containerHeight = screenH - (containerScrView.paralaxHeader.minimumHeight + height)
            containerFrameY = height
            
            segmentControlSize = size
            segmentCtlViewY = 0
            
        case .bottom(let size):
            containerHeight = screenH - (containerScrView.paralaxHeader.minimumHeight + size.height)
            containerFrameY = 0
            
            segmentControlSize = size
            segmentCtlViewY = containerHeight
        }
    

        let segmentCtlFrame = CGRect.init(origin: CGPoint.init(x: 0, y: segmentCtlViewY), size: segmentControlSize)
        segmentCtlView.frame = segmentCtlFrame
        
        let containerFrame = CGRect.init(x: 0, y: containerFrameY, width: screenW, height: containerHeight)
        pageView.frame = containerFrame
        
        containerScrView.contentSize = CGSize.init(width: screenW, height: screenH - (containerScrView.paralaxHeader.minimumHeight))
        containerScrView.layoutParalaxHeader()
    }
    
    //对于一些特殊的需要自己指定位置信息
    public func relayoutSegmentControlAndPageViewFrame(segmentControlFrame:CGRect,pageViewFrame:CGRect) {
        segmentCtlView.frame = segmentControlFrame
        pageView.frame = pageViewFrame
    }
    
    public func reloadViewControllers(ctls:[UIViewController]) {
        segmentCtlView.ctls = ctls
        self.ctls = ctls
        
        for ctl in ctls{
            addChildViewController(ctl)
        }
        pageView.reloadCurrentIndex(index: 0)
        pageView.reloadData()
    }
    
    public func insertOneViewController(ctl:UIViewController,index:NSInteger){
        if !self.childViewControllers.contains(ctl) {
            addChildViewController(ctl)
            let itemIndex = max(0, min(index, ctls.count))
            self.ctls.insert(ctl, at: itemIndex)
            
            pageView.reloadCurrentIndex(index: itemIndex)
            pageView.reloadData()
            
            segmentCtlView.ctls = ctls
            segmentCtlView.ctlViewStyle.defaultSelectedIndex = itemIndex
            segmentCtlView.reloadData()
        }
    }
    
    public func selected(at Index:NSInteger,animation:Bool)  {
        guard (ctls.count < Index && Index > 0) else {
            return
        }
        segmentCtlView.selected(at: Index, animation: animation)
    }
}

extension LLSegmentViewController :LLContainerScrollViewDagDelegate{
    public func scrollView(scrollView: LLContainerScrollView, dragTop offsetY: CGFloat) {
    }
    
    public func scrollView(scrollView: LLContainerScrollView, dragToMinimumHeight progress: CGFloat) {
    }

    public func scrollView(scrollView: LLContainerScrollView, shouldScrollWithSubView subView: UIScrollView) -> Bool {
        if subView == pageView.containerScrollView {
            return false
        }
        return true
    }
}

extension LLSegmentViewController :LLCtlPageViewDataSource{
    public func numberOfItems(in pageView: LLCtlPageView) -> Int {
        return ctls.count
    }
    
    public func pageView(_ pageView: LLCtlPageView, viewForItemAt index: NSInteger) -> UIView {
        return ctls[index].view
    }
}

extension LLSegmentViewController{
    private func initSubviews() {
        layoutInfo.minimumHeight = (self.navigationController?.navigationBar.isHidden == true) ? 0 : 64
        
        containerScrView.frame =  view.bounds
        containerScrView.dragDeleage = self
        containerScrView.paralaxHeader = self.layoutInfo
        containerScrView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        view.addSubview(containerScrView)
        
        pageView = LLCtlPageView(frame: CGRect.zero, ctls: [UIViewController]())
        pageView.dataSoure = self
        containerScrView.addSubview(pageView)

        containerScrView.addSubview(segmentCtlView)
        segmentCtlView.associateScrollerView = pageView.containerScrollView
    }
}

extension LLSegmentViewController{
    fileprivate func getScreenEdgePanGestureRecognizer() -> UIScreenEdgePanGestureRecognizer? {
        if let gestureRecognizers = self.navigationController?.view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if let recognizer = recognizer as? UIScreenEdgePanGestureRecognizer {
                    return recognizer
                }
            }
        }
        return nil;
    }
}

