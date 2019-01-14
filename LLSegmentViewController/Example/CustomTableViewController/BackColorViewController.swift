//
//  BackColorViewController.swift
//  LLSegmentViewController
//
//  Created by apple on 2019/1/14.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

class BackColorViewController: SimpleTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    
    override func setUpSegmentStyle() {
        let tabItemStyle = LLSegmentItemTabbarViewStyle()
        tabItemStyle.unSelectedColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        tabItemStyle.selectedColor = UIColor.init(red: 0.7, green: 0.2, blue: 0.1, alpha: 1)
        tabItemStyle.itemWidth = UIScreen.main.bounds.width/CGFloat(ctls.count)
        tabItemStyle.badgeValueLabelOffset = CGPoint.init(x: 2, y: 5)
        
        var segmentCtlStyle = LLSegmentedControlStyle()
        segmentCtlStyle.segmentItemViewClass = LLSegmentItemTabbarView.self
        segmentCtlStyle.itemViewStyle = tabItemStyle
        segmentCtlView.clickAnimation = false
        segmentCtlView.indicatorView.shapeStyle = .background(color: UIColor.lightGray, img: #imageLiteral(resourceName: "tabbarItemBackground"))
        segmentCtlView.reloadData(ctlViewStyle: segmentCtlStyle)
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
    }


}
