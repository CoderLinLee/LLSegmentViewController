//
//  ChangeImageViewViewController.swift
//  LLSegmentViewController
//
//  Created by apple on 2019/1/7.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

class ChangeImageViewViewController: LLSegmentViewController {
    let edgeInsets = UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
    let leftImageView = UIImageView()
    let rightImageView = UIImageView()
    let images = [#imageLiteral(resourceName: "lotus"),#imageLiteral(resourceName: "river"),#imageLiteral(resourceName: "seaWave"),#imageLiteral(resourceName: "city")]
    let navigationBarHeight = mTopHeight()
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContentView()
        loadCtls()
        setUpSegmentStyle()
        setUpBoatView()
        setUpImgeViews()
    }

    func layoutContentView() {
        let frame = CGRect.init(x: 0, y: navigationBarHeight, width: UIScreen.main.bounds.width, height: 100)
        let segmentControlFrame = CGRect.init(x: edgeInsets.left, y: frame.minY + edgeInsets.top, width: frame.width - edgeInsets.left - edgeInsets.right, height: frame.height - edgeInsets.top - edgeInsets.bottom)
        let pageViewFrame = CGRect.init(x: 0, y: frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - frame.maxY)
        relayoutSegmentControlAndPageViewFrame(segmentControlFrame: segmentControlFrame, pageViewFrame: pageViewFrame)
    }
    
    func loadCtls() {
        let titles = ["荷花", "河流", "海洋", "城市"]
        var ctls = [UIViewController]()
        for title in titles {
            let ctl = TestViewController()
            ctl.title = title
            ctl.showTableView = false
            ctls.append(ctl)
        }
        reloadViewControllers(ctls:ctls)
    }

    func setUpSegmentStyle() {
        let titleViewStyle = LLSegmentItemTitleViewStyle()
        titleViewStyle.selectedColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        titleViewStyle.unSelectedColor = UIColor.init(red: 0.2, green: 0.4, blue: 0.8, alpha: 1)
        titleViewStyle.itemWidth = (self.view.bounds.width - edgeInsets.left - edgeInsets.right)/CGFloat(ctls.count)
        titleViewStyle.titleLabelCenterOffsetY = -10
        titleViewStyle.selectedTitleScale = 1
        
        segmentCtlView.delegate = self
        segmentCtlView.indicatorView.bounds = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 30, height: 30))
        
        segmentCtlView.indicatorView.widthChangeStyle = .stationary(baseWidth: 30)
        segmentCtlView.indicatorView.centerYGradientStyle = .bottom(margin: 0)
        segmentCtlView.indicatorView.backgroundColor = UIColor.clear
        segmentCtlView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        
        var ctlViewStyle = LLSegmentedControlStyle()
        ctlViewStyle.defaultSelectedIndex = 2
        ctlViewStyle.segmentItemViewClass = LLSegmentItemTitleView.self
        ctlViewStyle.itemViewStyle = titleViewStyle
        segmentCtlView.reloadData(ctlViewStyle: ctlViewStyle)
    }
    
    func setUpBoatView() {
        let indicatorViewContentView = segmentCtlView.indicatorView.contentView
        let boatImg = UIImage.init(named: "boat")
        
        let boatImageView = UIImageView()
        boatImageView.image = boatImg
        boatImageView.frame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 20, height: 20))
        indicatorViewContentView.addSubview(boatImageView)
        
        boatImageView.center = CGPoint.init(x: indicatorViewContentView.bounds.width/2, y: indicatorViewContentView.bounds.height/2)
        boatImageView.autoresizingMask = [.flexibleTopMargin,.flexibleLeftMargin,.flexibleBottomMargin,.flexibleRightMargin]
    }
    
    func setUpImgeViews() {
        leftImageView.frame = CGRect.init(x: 0, y: navigationBarHeight, width: view.bounds.width, height: edgeInsets.top + edgeInsets.bottom + segmentCtlView.bounds.height)
        rightImageView.frame = leftImageView.frame
        self.view.insertSubview(leftImageView, at: 0)
        self.view.insertSubview(rightImageView, at: 0)
    }
    
    func getImgAt(index:NSInteger) -> UIImage {
        return images[index]
    }
}


extension ChangeImageViewViewController:LLSegmentedControlDelegate{
    func segMegmentCtlView(segMegmentCtlView: LLSegmentedControl, totalPercent: CGFloat) {
        let leftIndex = segMegmentCtlView.leftItemView.index
        let rightIndex = segMegmentCtlView.rightItemView.index
        let leftPercent = segMegmentCtlView.leftItemView.percent
        let rightPercent = segMegmentCtlView.rightItemView.percent
        
        leftImageView.image = getImgAt(index: leftIndex)
        leftImageView.alpha = max(0, leftPercent)
        rightImageView.image = getImgAt(index: rightIndex)
        rightImageView.alpha = max(0, rightPercent)
    }
    
    func segMegmentCtlView(segMegmentCtlView: LLSegmentedControl, dragToSelected itemView: LLSegmentBaseItemView) {
        print(itemView.index)
    }
}
