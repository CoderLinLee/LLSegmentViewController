//
//  PersonDetailViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2019/1/24.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

class PersonDetailViewController: LLSegmentViewController {
    let lufeiImageViewHeight:CGFloat = 315
    var lufeiImageView:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContentView()
        loadCtls()
        setUpSegmentStyle()
        
        segmentCtlView.bottomSeparatorSyle = (0.5,UIColor.black)
        closeAutomaticallyAdjusts()
    }
    
    func layoutContentView() {
        loadLufeiImageView()
        
        self.layoutInfo.headView = lufeiImageView
        self.layoutInfo.segmentControlPositionType = .top(height: 50)
        self.relayoutSubViews()
    }
    
    func loadCtls() {
        let test1Ctl = factoryCtl(title: "能力", imageName:  "", selectedImageNameStr: "")
        
        let test2Ctl = factoryCtl(title: "爱好", imageName: "", selectedImageNameStr: "")
        
        let test3Ctl = factoryCtl(title: "队友", imageName: "", selectedImageNameStr: "")
        
        let ctls =  [test1Ctl,test2Ctl,test3Ctl]
        reloadViewControllers(ctls:ctls)
    }
    
    func setUpSegmentStyle() {
        let tabItemStyle = LLSegmentItemTitleViewStyle()
        tabItemStyle.itemWidth = UIScreen.main.bounds.width/CGFloat(ctls.count)
        tabItemStyle.titleFontSize = 15
        
        var segmentCtlStyle = LLSegmentedControlStyle()
        segmentCtlStyle.segmentItemViewClass = LLSegmentItemTitleView.self
        segmentCtlStyle.itemViewStyle = tabItemStyle
        segmentCtlView.reloadData(ctlViewStyle: segmentCtlStyle)
        segmentCtlView.clickAnimation = false
        segmentCtlView.backgroundColor = UIColor.white
        
        segmentCtlView.indicatorView.shapeStyle = .crossBar(widthChangeStyle: .stationary(baseWidth: 10), height: 3)
    }
    
    override func scrollView(scrollView: LLContainerScrollView, dragTop progress: CGFloat) {
        var lufeiImageViewFrame = lufeiImageView.frame
        let maxY = lufeiImageViewFrame.maxY
        lufeiImageViewFrame.size.height = lufeiImageViewHeight*(1+progress)
        lufeiImageViewFrame.origin.y = maxY - lufeiImageViewFrame.size.height
        lufeiImageView.frame = lufeiImageViewFrame
    }
}

extension PersonDetailViewController{
    func loadLufeiImageView() {
        lufeiImageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: lufeiImageViewHeight))
        lufeiImageView.image = #imageLiteral(resourceName: "lufei")
        lufeiImageView.contentMode = .scaleAspectFill
        lufeiImageView.backgroundColor = UIColor.red
        
        let titleLabel = UILabel(frame: CGRect.init(x: 20, y: lufeiImageView.bounds.height - 40, width: 150, height: 20))
        titleLabel.text = "路飞----戴草帽的少年"
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.red
        titleLabel.autoresizingMask = [.flexibleRightMargin,.flexibleTopMargin]
        lufeiImageView.addSubview(titleLabel)
    }
}



