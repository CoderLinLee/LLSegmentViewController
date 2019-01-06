//
//  TitleImageItemView.swift
//  LLSegmentViewController
//
//  Created by lilin on 2019/1/5.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

public enum TitleImageButtonStyle {
    case titleTop(margin:CGFloat)
    case titleBottom(margin:CGFloat)
    case titleLeft(margin:CGFloat)
    case titleRight(margin:CGFloat)
}


class TitleImageButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
//        var titleRect = CGRect.init()
//        var imageRect = CGRect.init()
        
    }

}


class TitleImageItemView: LLSegmentBaseItemView {
    var titleImageBtn = TitleImageButton()
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        titleImageBtn.setTitleColor(UIColor.black, for: .normal)
        titleImageBtn.frame = bounds
        titleImageBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        titleImageBtn.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        titleImageBtn.isUserInteractionEnabled = false
        addSubview(titleImageBtn)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var associateViewCtl: UIViewController?{
        didSet{
            titleImageBtn.setTitle(associateViewCtl?.title, for: .normal)
        }
    }
    
    override func itemWidth() -> CGFloat {
        return 100
    }
}


//MARK:-自定义的使用
class TitleImageItemViewController: LLSegmentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContentView()
        loadCtls()
        setUpSegmentStyle()
    }
    
    func layoutContentView() {
        let segmentCtlFrame =  CGRect.init(x: 0, y: 64, width: view.bounds.width, height: 50)
        let containerFrame = CGRect.init(x: 0, y: segmentCtlFrame.maxY, width: view.bounds.width, height: view.bounds.height - segmentCtlFrame.maxY)
        layout(segmentCtlFrame:segmentCtlFrame, containerFrame: containerFrame)
    }

    func loadCtls() {
        let titles = ["螃蟹", "麻辣小龙虾", "苹果", "营养胡萝卜", "葡萄", "美味西瓜", "香蕉", "香甜菠萝", "鸡肉", "鱼", "海星"];
        let imageStrs = ["watermelon","lobster","grape","crab","carrot","apple","lobster","grape","crab","carrot","apple"];
        
        var ctls = [UIViewController]()
        for (index,title) in titles.enumerated() {
            let ctl = TestViewController()
            ctl.showTableView = false
            ctl.title = title
            ctl.tabBarItem.image = UIImage.init(named: imageStrs[index])
            ctl.tabBarItem.selectedImage = UIImage.init(named: imageStrs[index] + "_selected")
            ctls.append(ctl)
        }
        reloadViewControllers(ctls:ctls)
    }

    func setUpSegmentStyle() {
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        segmentCtlView.indicatorView.shapeStyle = .background(color: UIColor.red, img: nil)
        let titleViewStyle = LLSegmentItemTitleViewStyle()
        var ctlViewStyle = LLSegmentCtlViewStyle()
        ctlViewStyle.segmentItemViewClass = LLSegmentItemBadgeTitleView.self
        ctlViewStyle.itemViewStyle = titleViewStyle
        segmentCtlView.reloadData(ctlViewStyle: ctlViewStyle)
    }
}
