//
//  GoodsDetailViewController.swift
//  LLSegmentViewController
//
//  Created by apple on 2019/1/26.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit
import SDCycleScrollView
import RollingNotice

class GoodsDetailViewController: LLSegmentViewController {
    let adViewHeight:CGFloat = 220
    let rollingNoticeViewHeight:CGFloat = 40
    let moreInfoViewHeight:CGFloat = 100
    let customNavBar = UIView()
    let backButtom = UIButton(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContentView()
        loadCtls()
        setUpSegmentStyle()
        
        segmentCtlView.bottomSeparatorStyle = (0.5,UIColor.black.withAlphaComponent(0.3))
    }
    
    func layoutContentView() {
        self.layoutInfo.headView = loadHeadView()
        self.layoutInfo.segmentControlPositionType = .top(size: CGSize.init(width: UIScreen.main.bounds.width, height: 50),offset:0)
        self.relayoutSubViews()
    }
    
    func loadCtls() {
        let titles = ["全部","服饰穿搭","生活百货","美食吃货","美容护理","母婴儿童","数码家电"]
        var ctls = [UIViewController]()
        for title in titles{
            let testCtl = TestViewController()
            testCtl.title = title
            ctls.append(testCtl)

        }
        reloadViewControllers(ctls:ctls)
    }
    
    func setUpSegmentStyle() {
        let itemStyle = LLSegmentItemTitleViewStyle()
        itemStyle.extraTitleSpace = 10
        itemStyle.titleFontSize = 15
        
        var segmentCtlStyle = LLSegmentedControlStyle()
        segmentCtlStyle.segmentItemViewClass = LLSegmentItemTitleView.self
        segmentCtlStyle.itemViewStyle = itemStyle
        segmentCtlView.reloadData(ctlViewStyle: segmentCtlStyle)
        segmentCtlView.clickAnimation = false
        segmentCtlView.backgroundColor = UIColor.white
        
        segmentCtlView.indicatorView.shapeStyle = .crossBar(widthChangeStyle: .stationary(baseWidth: 10), height: 3)
    }
    

}

extension GoodsDetailViewController{
    func loadHeadView()->UIView {
        let screenW = UIScreen.main.bounds.width
        let headView = UIView(frame: CGRect.init(x: 0, y: 0, width: screenW, height: adViewHeight + rollingNoticeViewHeight + moreInfoViewHeight))
        
        let adView = SDCycleScrollView(frame: CGRect.init(x: 0, y: 0, width: screenW, height: adViewHeight))
        adView.backgroundColor = UIColor.red
        adView.imageURLStringsGroup = ["h1","h2","h3","h4"]
        headView.addSubview(adView)
        
        let rollingNoticeView = GYRollingNoticeView(frame: CGRect.init(x: 0, y: adView.bounds.height, width: screenW, height: rollingNoticeViewHeight))
        rollingNoticeView.backgroundColor = UIColor.green
        rollingNoticeView.dataSource = self
        rollingNoticeView.delegate = self
        rollingNoticeView.register(GYNoticeViewCell.classForCoder(), forCellReuseIdentifier: "moreInfoViewCell")
        rollingNoticeView.reloadDataAndStartRoll()
        headView.addSubview(rollingNoticeView)
        
        let moreInfoViewLabel = UILabel(frame: CGRect.init(x: 0, y: rollingNoticeView.frame.maxY, width: screenW, height: moreInfoViewHeight))
        moreInfoViewLabel.text = "添加更多内容"
        moreInfoViewLabel.textAlignment = .center
        moreInfoViewLabel.backgroundColor = UIColor.brown
        headView.addSubview(moreInfoViewLabel)
        return headView
    }
}

extension GoodsDetailViewController:GYRollingNoticeViewDataSource,GYRollingNoticeViewDelegate{
    func numberOfRows(for rollingView: GYRollingNoticeView!) -> Int {
        return 4
    }
    
    func rollingNoticeView(_ rollingView: GYRollingNoticeView!, cellAt index: UInt) -> GYNoticeViewCell! {
        let cell = rollingView.dequeueReusableCell(withIdentifier: "moreInfoViewCell")!
        cell.textLabel.text = "广告标识轮播\(index)"
        cell.textLabel.font = UIFont.systemFont(ofSize: 15)
        return cell
    }
    
    func didClick(_ rollingView: GYRollingNoticeView!, for index: UInt) {
        print("点击了:",index)
    }
}

