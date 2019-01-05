//
//  TitleImageItemView.swift
//  LLSegmentViewController
//
//  Created by lilin on 2019/1/5.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit
//MARK: -定义button相对label的位置
enum YWButtonEdgeInsetsStyle {
    case Top
    case Left
    case Right
    case Bottom
}

extension UIButton {
    
    func layoutButton(style: YWButtonEdgeInsetsStyle, imageTitleSpace: CGFloat) {
        //得到imageView和titleLabel的宽高
        let imageWidth = self.imageView?.frame.size.width
        let imageHeight = self.imageView?.frame.size.height
        
        var labelWidth: CGFloat! = 0.0
        var labelHeight: CGFloat! = 0.0
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        
        if Double(version)! >= 8.0 {
            labelWidth = self.titleLabel?.intrinsicContentSize.width
            labelHeight = self.titleLabel?.intrinsicContentSize.height
        }else{
            labelWidth = self.titleLabel?.frame.size.width
            labelHeight = self.titleLabel?.frame.size.height
        }
        
        //初始化imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        
        //根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch style {
        case .Top:
            //上 左 下 右
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-imageTitleSpace/2, 0, 0, -labelWidth)
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWidth!, -imageHeight!-imageTitleSpace/2, 0)
            break;
            
        case .Left:
            imageEdgeInsets = UIEdgeInsetsMake(0, -imageTitleSpace/2, 0, imageTitleSpace)
            labelEdgeInsets = UIEdgeInsetsMake(0, imageTitleSpace/2, 0, -imageTitleSpace/2)
            break;
            
        case .Bottom:
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight!-imageTitleSpace/2, -labelWidth)
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight!-imageTitleSpace/2, -imageWidth!, 0, 0)
            break;
            
        case .Right:
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+imageTitleSpace/2, 0, -labelWidth-imageTitleSpace/2)
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWidth!-imageTitleSpace/2, 0, imageWidth!+imageTitleSpace/2)
            break;
            
        }
        
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
        
    }
    
}

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



class TitleImageItemViewController: LLSegmentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initCtls()
        initSegmentCtlView()
    }
    
    func initCtls() {
        let segmentCtlFrame =  CGRect.init(x: 0, y: 64, width: view.bounds.width, height: 50)
        let containerFrame = CGRect.init(x: 0, y: segmentCtlFrame.maxY, width: view.bounds.width, height: view.bounds.height - segmentCtlFrame.maxY)
        layout(segmentCtlFrame:segmentCtlFrame, containerFrame: containerFrame)
        
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

    
    func initSegmentCtlView() {
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        segmentCtlView.indicatorView.shapeStyle = .background(color: UIColor.red, img: nil)
        let titleViewStyle = LLSegmentItemTitleViewStyle()
        let ctlViewStyle = LLSegmentCtlViewStyle(itemSpacing: 0, segmentItemViewClass: TitleImageItemView.self, itemViewStyle: titleViewStyle, defaultSelectedIndex: 0)
        segmentCtlView.reloadData(ctlViewStyle: ctlViewStyle)
    }
}
