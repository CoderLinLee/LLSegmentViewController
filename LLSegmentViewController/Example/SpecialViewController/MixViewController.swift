//
//  MixViewController.swift
//  LLSegmentViewController
//
//  Created by apple on 2019/1/6.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

class MixIndicatorView: UIView {
    let ellipseView = UIView()
    let crossBarView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        ellipseView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        ellipseView.frame = CGRect.init(x: 0, y: 0, width: bounds.width, height: 20)
        ellipseView.center = CGPoint.init(x: bounds.width/2, y: bounds.height/2)
        ellipseView.layer.cornerRadius = 10
        ellipseView.autoresizingMask = [.flexibleWidth,.flexibleTopMargin,.flexibleBottomMargin]
        addSubview(ellipseView)

        let crossBarViewHight:CGFloat = 3
        crossBarView.backgroundColor = UIColor.blue
        crossBarView.frame = CGRect.init(x: 0, y: bounds.height - crossBarViewHight, width: bounds.width, height: crossBarViewHight)
        addSubview(crossBarView)
        crossBarView.autoresizingMask = [.flexibleWidth,.flexibleTopMargin,.flexibleBottomMargin]
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MixViewController: TitleViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addMixIndicatorView()
    }
    
    func addMixIndicatorView() {
        let indicatorViewContentView = segmentCtlView.indicatorView.contentView
        let mixIndicatorView = MixIndicatorView(frame: indicatorViewContentView.bounds)
        indicatorViewContentView.addSubview(mixIndicatorView)
        mixIndicatorView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
    override func setUpSegmentStyle() {
        titleViewStyle.titleLabelMaskEnabled = true
        
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        segmentCtlView.indicatorView.shapeStyle = .background(color: UIColor.clear, img: nil)
        var ctlViewStyle = LLSegmentCtlViewStyle()
        ctlViewStyle.segmentItemViewClass = LLSegmentItemTitleView.self
        ctlViewStyle.itemViewStyle = titleViewStyle
        segmentCtlView.reloadData(ctlViewStyle: ctlViewStyle)
    }
}
