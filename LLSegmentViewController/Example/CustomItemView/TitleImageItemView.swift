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

public class TitleImageModel{
    var title = ""
    var imgeStr = ""
    var style = TitleImageButtonStyle.titleTop(margin: 0)
    var imgViewSize = CGSize.init(width: 20, height: 20)
    public init(title:String,imgeStr:String,style:TitleImageButtonStyle) {
        self.title = title
        self.imgeStr = imgeStr
        self.style = style
    }
}

class TitleImageItemView: LLSegmentBaseItemView {
    let titleLabel = UILabel()
    let imageView = UIImageView()
    var model:TitleImageModel?
    let titleLabelFontSize:CGFloat = 13
    required init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.font = UIFont.systemFont(ofSize: titleLabelFontSize)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        addSubview(imageView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var associateViewCtl: UIViewController?{
        didSet{
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override func itemWidth() -> CGFloat {
        if let titleImgCtl = associateViewCtl as? TitleImageViewController{
            let layoutInfo = getLayoutInfo(model: titleImgCtl.model)
            return layoutInfo.contentSize.width + 2*10
        }
        return 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let titleImgCtl = associateViewCtl as? TitleImageViewController{
            model = titleImgCtl.model
            imageView.image = UIImage.init(named: titleImgCtl.model.imgeStr)
            titleLabel.text = model?.title
            
            let layoutInfo = getLayoutInfo(model: titleImgCtl.model)
            titleLabel.frame = layoutInfo.titleLabelFrame
            imageView.frame = layoutInfo.imageViewFrame
        }
    }
    
    private func getLayoutInfo(model:TitleImageModel) -> (titleLabelFrame:CGRect,imageViewFrame:CGRect,contentSize:CGSize) {
        let titleLabelSize = model.title.LLGetStrSize(font: titleLabelFontSize, w: 1000, h: 1000)
        let imgViewSize = model.imgViewSize
        var contentWidth:CGFloat = 0
        var contentHeight:CGFloat = 0

        var titleLabelFrame = CGRect.init(origin: CGPoint.zero, size: titleLabelSize)
        var imageViewFrame = CGRect.init(origin: CGPoint.zero, size: imgViewSize)
        let selfCenter = CGPoint.init(x: bounds.width/2, y: bounds.height/2)
        switch model.style {
        case .titleTop(let margin):
            contentHeight = titleLabelSize.height + imgViewSize.height + margin
            contentWidth = max(titleLabelSize.width, imgViewSize.width)
            
            imageViewFrame.origin.y = selfCenter.y + contentHeight/2 - imgViewSize.height
            imageViewFrame.origin.x = selfCenter.x - imgViewSize.width/2
            
            titleLabelFrame.origin.y = selfCenter.y - contentHeight/2
            titleLabelFrame.origin.x = selfCenter.x - titleLabelSize.width/2
            
        case .titleBottom(let margin):
            contentHeight = titleLabelSize.height + imgViewSize.height + margin
            contentWidth = max(titleLabelSize.width, imgViewSize.width)
            
            imageViewFrame.origin.y = selfCenter.y - contentHeight/2
            imageViewFrame.origin.x = selfCenter.x - imgViewSize.width/2
            
            titleLabelFrame.origin.y = selfCenter.y + contentHeight/2 - titleLabelSize.height
            titleLabelFrame.origin.x = selfCenter.x - titleLabelSize.width/2

        case .titleLeft(let margin):
            contentWidth = titleLabelSize.width + imgViewSize.width + margin
            contentHeight = max(titleLabelSize.height, imgViewSize.height)
            
            imageViewFrame.origin.x = selfCenter.x + contentWidth/2 - imgViewSize.width
            imageViewFrame.origin.y = selfCenter.y - imgViewSize.height/2
            
            titleLabelFrame.origin.x = selfCenter.x - contentWidth/2
            titleLabelFrame.origin.y = selfCenter.y - titleLabelSize.height/2
            
        case .titleRight(let margin):
            contentWidth = titleLabelSize.width + imgViewSize.width + margin
            contentHeight = max(titleLabelSize.height, imgViewSize.height)
            
            imageViewFrame.origin.x = selfCenter.x - contentWidth/2
            imageViewFrame.origin.y = selfCenter.y - imgViewSize.height/2
            
            titleLabelFrame.origin.x = selfCenter.x + contentWidth/2 - titleLabelSize.width
            titleLabelFrame.origin.y = selfCenter.y - titleLabelSize.height/2
        }
        return (titleLabelFrame,imageViewFrame,CGSize.init(width: contentWidth, height: contentHeight))
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
        let segmentCtlFrame =  CGRect.init(x: 0, y: 164, width: view.bounds.width, height: 50)
        let containerFrame = CGRect.init(x: 0, y: segmentCtlFrame.maxY, width: view.bounds.width, height: view.bounds.height - segmentCtlFrame.maxY)
        layout(segmentCtlFrame:segmentCtlFrame, containerFrame: containerFrame)
    }

    func loadCtls() {
        var ctls = [UIViewController]()
        let models = [TitleImageModel.init(title: "螃蟹", imgeStr: "watermelon", style: .titleTop(margin: 0)),
                      TitleImageModel.init(title: "麻辣小龙虾", imgeStr: "lobster", style: .titleBottom(margin: 0)),
                      TitleImageModel.init(title: "苹果", imgeStr: "grape", style: .titleLeft(margin: 0)),
                      TitleImageModel.init(title: "营养胡萝卜", imgeStr: "crab", style: .titleRight(margin: 0)),
                      TitleImageModel.init(title: "葡萄", imgeStr: "carrot", style: .titleTop(margin: 0)),
                      TitleImageModel.init(title: "美味西瓜", imgeStr: "apple", style: .titleTop(margin: 0)),
                      TitleImageModel.init(title: "香蕉", imgeStr: "grape", style: .titleTop(margin: 0))]
        for model in models {
            let ctl = TitleImageViewController()
            ctl.showTableView = true
            ctl.model = model
            ctls.append(ctl)
            ctl.tableViewDidScroll = { (oldContentOffset,newContentOffset) in
                self.reloadWhenScroll(oldContentOffset: oldContentOffset, newContentOffset: newContentOffset)
            }
        }
        reloadViewControllers(ctls:ctls)
    }

    func setUpSegmentStyle() {
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        segmentCtlView.indicatorView.shapeStyle = .background(color: UIColor.red, img: nil)
        let titleViewStyle = LLSegmentItemTitleViewStyle()
        var ctlViewStyle = LLSegmentCtlViewStyle()
        ctlViewStyle.segmentItemViewClass = TitleImageItemView.self
        ctlViewStyle.itemViewStyle = titleViewStyle
        segmentCtlView.reloadData(ctlViewStyle: ctlViewStyle)
    }
}

extension TitleImageItemViewController{
    func reloadWhenScroll(oldContentOffset:CGPoint,newContentOffset:CGPoint){
        var segmentCtlFrame = segmentCtlView.frame
        let subValue = newContentOffset.y - oldContentOffset.y
        print(subValue)
//        segmentCtlFrame.origin.y -= subValue
        if fabs(subValue) > 25 {
            if subValue > 0 {
                segmentCtlFrame.origin.y = 64
            }else{
                segmentCtlFrame.origin.y = 164
            }
            let containerFrame = CGRect.init(x: 0, y: segmentCtlFrame.maxY, width: view.bounds.width, height: view.bounds.height - segmentCtlFrame.maxY)
            layout(segmentCtlFrame:segmentCtlFrame, containerFrame: containerFrame)
        }
      
        
    }
}

class TitleImageViewController: TestViewController {
    var model:TitleImageModel!
}
