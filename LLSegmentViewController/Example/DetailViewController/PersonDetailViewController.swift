//
//  PersonDetailViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2019/1/24.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

class PersonDetailViewController: LLSegmentViewController {
    let lufeiImageViewHeight:CGFloat = 310
    var lufeiImageView:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContentView()
        loadCtls()
        setUpSegmentStyle()
        
        if #available(iOS 11.0, *) {
            self.containerScrView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    func layoutContentView() {
        lufeiImageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: lufeiImageViewHeight))
        lufeiImageView.image = #imageLiteral(resourceName: "lufei")
        lufeiImageView.contentMode = .scaleAspectFit
        
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
        tabItemStyle.unSelectedColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        tabItemStyle.selectedColor = UIColor.init(red: 0.7, green: 0.2, blue: 0.1, alpha: 1)
        tabItemStyle.itemWidth = UIScreen.main.bounds.width/CGFloat(ctls.count)
        tabItemStyle.titleFontSize = 15
        
        var segmentCtlStyle = LLSegmentedControlStyle()
        segmentCtlStyle.segmentItemViewClass = LLSegmentItemTitleView.self
        segmentCtlStyle.itemViewStyle = tabItemStyle
        segmentCtlView.reloadData(ctlViewStyle: segmentCtlStyle)
        segmentCtlView.clickAnimation = false
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        
        segmentCtlView.indicatorView.shapeStyle = .crossBar(widthChangeStyle: .stationary(baseWidth: 10), height: 3)
    }
    
    override func scrollView(scrollView: LLContainerScrollView, dragTop progress: CGFloat) {
        var lufeiImageViewBounds = lufeiImageView.bounds
        lufeiImageViewBounds.size.height = lufeiImageViewHeight*(1+progress)
        lufeiImageView.bounds = lufeiImageViewBounds
    }
}
