//
//  FootballViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/29.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit

class FootballViewController: LLSegmentViewController {
    let footballImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "足球"

        let segmentCtlFrame =  CGRect.init(x: 0, y: 64, width: view.bounds.width, height:50)
        let containerFrame = CGRect.init(x: 0, y: segmentCtlFrame.maxY, width: view.bounds.width, height: view.bounds.height - segmentCtlFrame.maxY)
        layout(segmentCtlFrame:segmentCtlFrame, containerFrame: containerFrame)
        
        let titles = ["中国U-19", "中国超级联赛", "亚足联冠军联赛", "亚运会足球赛", "世界杯🎉"]
        var ctls = [UIViewController]()
        for title in titles {
            let ctl = TestViewController()
            ctl.title = title
            ctl.showTableView = false
            ctls.append(ctl)
        }

        let titleViewStyle = LLSegmentItemTitleViewStyle()
        titleViewStyle.selectedColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        titleViewStyle.unSelectedColor = UIColor.init(red: 0.2, green: 0.4, blue: 0.8, alpha: 1)
        titleViewStyle.itemWidth = LLSegmentAutomaticDimension
        titleViewStyle.titleLabelCenterOffsetY = -10
        
        segmentCtlView.delegate = self
        reloadViewControllers(ctls:ctls)
        segmentCtlView.indicatorView.bounds = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 30, height: 30))

        segmentCtlView.indicatorView.widthChangeStyle = .stationary(baseWidth: 30)
        segmentCtlView.indicatorView.delegate = self
        segmentCtlView.indicatorView.centerYGradientStyle = .bottom(margin: 12)
        segmentCtlView.indicatorView.backgroundColor = UIColor.clear
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        let ctlViewStyle = LLSegmentCtlViewStyle(itemSpacing: 0, segmentItemViewClass: LLSegmentItemBadgeTitleView.self, itemViewStyle: titleViewStyle, defaultSelectedIndex: 0)
        segmentCtlView.reloadData(ctlViewStyle: ctlViewStyle)

        let indicatorViewContentView = segmentCtlView.indicatorView.contentView
        let footballImg = UIImage.init(named: "football")
        footballImageView.image = footballImg
        footballImageView.frame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 20, height: 20))
        indicatorViewContentView.addSubview(footballImageView)
        footballImageView.center = CGPoint.init(x: indicatorViewContentView.bounds.width/2, y: indicatorViewContentView.bounds.height/2)
        footballImageView.autoresizingMask = [.flexibleTopMargin,.flexibleLeftMargin,.flexibleBottomMargin,.flexibleRightMargin]
    }
}

extension FootballViewController:LLIndicatorViewDelegate{
    func indicatorView(indicatorView: LLIndicatorView, percent: CGFloat) {
        footballImageView.transform = CGAffineTransform.init(rotationAngle: percent*CGFloat.pi*2)
    }
}

extension FootballViewController:LLSegmentCtlViewDelegate{
    func segMegmentCtlView(segMegmentCtlView: LLSegmentCtlView, clickItemAt sourceItemView: LLSegmentCtlItemView, to destinationItemView: LLSegmentCtlItemView) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.duration = 0.25
        rotateAnimation.toValue = sourceItemView.frame.origin.x > destinationItemView.frame.origin.x ? CGFloat.pi*2 : -CGFloat.pi*2
        footballImageView.layer.add(rotateAnimation, forKey: "rotate")
    }
}
