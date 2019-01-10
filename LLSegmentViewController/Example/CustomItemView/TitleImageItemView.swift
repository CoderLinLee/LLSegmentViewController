//
//  TitleImageItemView.swift
//  LLSegmentViewController
//
//  Created by lilin on 2019/1/5.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

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
        var ctls = [UIViewController]()
        let margin:CGFloat = 2
        let models = [LLTitleImageModel.init(title: "螃蟹", imgeStr: "watermelon", style: .titleTop(margin: margin)),
                      LLTitleImageModel.init(title: "麻辣小龙虾", imgeStr: "lobster", style: .titleBottom(margin: margin)),
                      LLTitleImageModel.init(title: "苹果", imgeStr: "grape", style: .titleLeft(margin: margin)),
                      LLTitleImageModel.init(title: "营养胡萝卜", imgeStr: "crab", style: .titleRight(margin: margin)),
                      LLTitleImageModel.init(title: "葡萄", imgeStr: "carrot", style: .titleTop(margin: margin)),
                      LLTitleImageModel.init(title: "美味西瓜", imgeStr: "apple", style: .titleTop(margin: margin)),
                      LLTitleImageModel.init(title: "香蕉", imgeStr: "grape", style: .titleTop(margin: margin))]
        for model in models {
            let ctl = TitleImageViewController()
            ctl.showTableView = true
            ctl.model = model
            ctl.title = model.title
            ctls.append(ctl)
        }
        reloadViewControllers(ctls:ctls)
    }

    func setUpSegmentStyle() {
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        segmentCtlView.indicatorView.shapeStyle = .background(color: UIColor.red, img: nil)
        let titleViewStyle = LLSegmentItemTitleViewStyle()
        var ctlViewStyle = LLSegmentCtlViewStyle()
        ctlViewStyle.segmentItemViewClass = LLSegmentItemTitleImageView.self
        ctlViewStyle.itemViewStyle = titleViewStyle
        segmentCtlView.reloadData(ctlViewStyle: ctlViewStyle)
    }
}


class TitleImageViewController: TestViewController,LLSegmentItemTitleImageViewProtocol {
    func loadImageView(titleLabel:UILabel,imageView: UIImageView, percent: CGFloat) {
        if percent < 0.5 {
            titleLabel.textColor = UIColor.lightGray
            imageView.image = UIImage.init(named: model.imgeStr)
        }else {
            titleLabel.textColor = UIColor.black
            imageView.image = UIImage.init(named: model.imgeStr + "_selected")
        }
    }
    
    var model:LLTitleImageModel!
}
