//
//  WangYiItemView.swift
//  LLSegmentViewController
//
//  Created by lilin on 2019/1/10.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

class WangYiItemView: LLSegmentItemTitleView {
    let circularLayer = CAShapeLayer()
    let finalRadius:CGFloat = 3
    let finalLineWidth:CGFloat = 2

    required init(frame: CGRect) {
        super.init(frame: frame)

        circularLayer.strokeColor = UIColor.red.cgColor
        circularLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(circularLayer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func percentChange(percent: CGFloat) {
        super.percentChange(percent: percent)
        let center = CGPoint.init(x: titleLabel.frame.maxX + 5, y: titleLabel.frame.minY)
        let circularPath = UIBezierPath.init(arcCenter: center, radius: percent * finalRadius, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        circularLayer.path = circularPath.cgPath
        circularLayer.lineWidth = finalLineWidth*percent
        CATransaction.commit()
    }
}

//MARK:-自定义的使用
class WangYiItemViewController: TitleViewController {
    override func setUpSegmentStyle() {
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        if let indicatorWidthChangeStyle = indicatorViewWidthChangeStyle {
            segmentCtlView.indicatorView.widthChangeStyle = indicatorWidthChangeStyle
        }
        var ctlViewStyle = LLSegmentedControlStyle()
        ctlViewStyle.segmentItemViewClass = WangYiItemView.self
        ctlViewStyle.itemViewStyle = titleViewStyle
        segmentCtlView.reloadData(ctlViewStyle: ctlViewStyle)
    }
}


