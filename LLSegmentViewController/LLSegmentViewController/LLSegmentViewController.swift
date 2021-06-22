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
    //整体下拉
    case container
    //列表下拉
    case list
}

//分段控件的位置
public enum LLSegmentedCtontrolPositionType {
    //在导航条上面的
    case nav(size:CGSize)
    //在顶部
    case top(size:CGSize,offset:CGFloat)
    //在底部
    case bottom(size:CGSize,offset:CGFloat)
    //自定义位置
    case customFrame(segmentCtlFrame:CGRect,containerFrame:CGRect)
}

//控件布局位置信息
public class LLSubViewsLayoutInfo:NSObject{
    public var minimumHeight:CGFloat = 64
    public var segmentControlPositionType:LLSegmentedCtontrolPositionType = .top(size: CGSize.init(width: UIScreen.main.bounds.width, height: 50), offset: 0)
    public var refreshType = LLDragRefreshType.container
    public var headView:UIView?
}


open class LLSegmentViewController: UIViewController {
    public let layoutInfo = LLSubViewsLayoutInfo()
    public let segmentCtlView = LLSegmentedControl(frame: CGRect.zero, titles: [String]())
    public let pageView:LLCtlPageView = LLCtlPageView(frame: CGRect.zero, ctls: [UIViewController]())
    public let containerScrView = LLContainerScrollView()
    public private (set) var ctls = [UIViewController]()

    private let cellIdentifier = "cellIdentifier"
    private let layout = UICollectionViewFlowLayout()
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        initSubviews()
        relayoutSubViews()
        containerScrView.backgroundColor = UIColor.clear
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        if let screenEdgePanGestureRecognizer = getScreenEdgePanGestureRecognizer() {
            containerScrView.panGestureRecognizer.require(toFail: screenEdgePanGestureRecognizer)
            pageView.panGestureRecognizer.require(toFail: screenEdgePanGestureRecognizer)
        }
    }
}

extension LLSegmentViewController{
    open func closeAutomaticallyAdjusts() {
        if #available(iOS 11.0, *) {
            self.containerScrView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    open func relayoutSubViews() {
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
            
            self.navigationItem.titleView = segmentCtlView
        case .top(let size,let offset):
            let height = size.height
            containerHeight = screenH - (containerScrView.paralaxHeader.minimumHeight + height + offset)
            containerFrameY = height + offset
            
            segmentControlSize = size
            segmentCtlViewY = offset
            
        case .bottom(let size,let offset):
            containerHeight = screenH - (containerScrView.paralaxHeader.minimumHeight + size.height + offset)
            containerFrameY = 0
            
            segmentControlSize = size
            segmentCtlViewY = containerHeight
        case .customFrame(let segmentCtlFrame, let containerFrame):
            segmentCtlView.frame = segmentCtlFrame
            pageView.frame = containerFrame
            
            containerScrView.contentSize = CGSize.init(width: screenW, height: segmentCtlFrame.height + containerFrame.height)
            containerScrView.layoutParalaxHeader()
            return
        }
    

        let segmentCtlFrame = CGRect.init(origin: CGPoint.init(x: 0, y: segmentCtlViewY), size: segmentControlSize)
        segmentCtlView.frame = segmentCtlFrame
        
        let containerFrame = CGRect.init(x: 0, y: containerFrameY, width: screenW, height: containerHeight)
        pageView.frame = containerFrame
        
        containerScrView.contentSize = CGSize.init(width: screenW, height: screenH - (containerScrView.paralaxHeader.minimumHeight + mSafeBottomMargin()))
        containerScrView.layoutParalaxHeader()
    }
    
    //对于一些特殊的需要自己指定位置信息
    open func relayoutSegmentControlAndPageViewFrame(segmentControlFrame:CGRect,pageViewFrame:CGRect) {
        segmentCtlView.frame = segmentControlFrame
        pageView.frame = pageViewFrame
    }
    
    open func reloadViewControllers(ctls:[UIViewController]) {
        self.ctls = ctls
        
        var titles = [String]()
        for ctl in ctls{
            addChild(ctl)
            let title = ctl.ctlTitle()
            titles.append(title)
        }
        segmentCtlView.ctls = ctls
        segmentCtlView.titles = titles
        segmentCtlView.reloadData()

        pageView.reloadCurrentIndex(index: 0)
        pageView.reloadData()
    }
    
    open func insertOneViewController(ctl:UIViewController,index:NSInteger){
        if !self.children.contains(ctl) {
            addChild(ctl)
            let itemIndex = max(0, min(index, ctls.count))
            self.ctls.insert(ctl, at: itemIndex)
            
            pageView.reloadCurrentIndex(index: itemIndex)
            pageView.reloadData()
            
            segmentCtlView.titles.insert(ctl.ctlTitle(), at: index)
            segmentCtlView.ctlViewStyle.defaultSelectedIndex = itemIndex
            segmentCtlView.ctls = ctls
            segmentCtlView.reloadData()
        }
    }
    
    open func selected(at Index:NSInteger,animation:Bool)  {
        guard (ctls.count < Index && Index > 0) else {
            return
        }
        segmentCtlView.selected(at: Index, animation: animation)
    }
}

extension LLSegmentViewController :LLContainerScrollViewDagDelegate{
    open func scrollView(scrollView: LLContainerScrollView, dragTop offsetY: CGFloat) {
        
    }
    
    open func scrollView(scrollView: LLContainerScrollView, dragToMinimumHeight progress: CGFloat) {
        
    }

    open func scrollView(scrollView: LLContainerScrollView, shouldScrollWithSubView subView: UIScrollView) -> Bool {
        if subView == pageView {
            return false
        }
        return true
    }
}

extension LLSegmentViewController :LLCtlPageViewDataSource{
    open func numberOfItems(in pageView: LLCtlPageView) -> Int {
        return ctls.count
    }
    
    open func pageView(_ pageView: LLCtlPageView, viewForItemAt index: NSInteger) -> UIView {
        return ctls[index].view
    }
}

extension LLSegmentViewController{
    private func initSubviews() {
        layoutInfo.minimumHeight = (self.navigationController?.navigationBar.isHidden == true) ? 0 : mTopHeight()
        
        containerScrView.frame =  view.bounds
        containerScrView.dragDeleage = self
        containerScrView.paralaxHeader = self.layoutInfo
        containerScrView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        view.addSubview(containerScrView)
        
        pageView.dataSoure = self
        containerScrView.addSubview(pageView)

        containerScrView.addSubview(segmentCtlView)
        segmentCtlView.associateScrollerView = pageView
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
