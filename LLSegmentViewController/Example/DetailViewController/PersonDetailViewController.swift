//
//  PersonDetailViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2019/1/24.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

class PersonDetailViewController: LLSegmentViewController {
    let lufeiImageViewHeight:CGFloat = 250
    var lufeiImageView:UIImageView!
    let customNavBar = UIView()
    let backButtom = UIButton(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContentView()
        loadCtls()
        setUpSegmentStyle()
        
        segmentCtlView.bottomSeparatorStyle = (0.5,UIColor.black.withAlphaComponent(0.3))
        closeAutomaticallyAdjusts()
    }
    
    func layoutContentView() {
        loadLufeiImageView()
        
        self.layoutInfo.headView = lufeiImageView
        self.layoutInfo.segmentControlPositionType = .top(size: CGSize.init(width: UIScreen.main.bounds.width, height: 50),offset:0)
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
        let contentInset = UIEdgeInsets.init(top: 0, left: 30, bottom: 0, right: 30)
        let itemStyle = LLSegmentItemTitleViewStyle()
        itemStyle.itemWidth = (UIScreen.main.bounds.width - contentInset.left - contentInset.right)/CGFloat(ctls.count)
        itemStyle.titleFontSize = 15
        
        var segmentCtlStyle = LLSegmentedControlStyle()
        segmentCtlStyle.contentInset = contentInset
        segmentCtlStyle.segmentItemViewClass = LLSegmentItemTitleView.self
        segmentCtlStyle.itemViewStyle = itemStyle
        segmentCtlView.reloadData(ctlViewStyle: segmentCtlStyle)
        segmentCtlView.clickAnimation = false
        segmentCtlView.backgroundColor = UIColor.white
        
        segmentCtlView.indicatorView.shapeStyle = .crossBar(widthChangeStyle: .stationary(baseWidth: 10), height: 3)
    }
    
    override func scrollView(scrollView: LLContainerScrollView, dragTop offsetY: CGFloat) {
        var lufeiImageViewFrame = lufeiImageView.frame
        let maxY = lufeiImageViewFrame.maxY
        lufeiImageViewFrame.size.height = lufeiImageViewHeight + offsetY
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


extension PersonDetailViewController{
    func initCustomNavBar() {
        let navHeight:CGFloat = 44
        let topHeight = mTopHeight(mNavBarHeight: navHeight)
        customNavBar.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: topHeight)
        customNavBar.backgroundColor = UIColor.white
        view.addSubview(customNavBar)
        
        let titleLabel = UILabel()
        titleLabel.text = self.title
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint.init(x: customNavBar.bounds.width/2, y: topHeight - navHeight/2)
        customNavBar.addSubview(titleLabel)
        
        let backButtomHeight:CGFloat = 30
        backButtom.contentHorizontalAlignment = .left
        backButtom.setImage(#imageLiteral(resourceName: "pop-icon-back-normal"), for: .normal)
        backButtom.frame = CGRect.init(x: 20, y: topHeight - navHeight/2 - backButtomHeight/2, width: 50, height: backButtomHeight)
        view.addSubview(backButtom)
        backButtom.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
    }
    
    @objc func backBtnClick(){
        self.navigationController?.popViewController(animated: true)
    }
}


