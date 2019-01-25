//
//  AttributeItemView.swift
//  LLSegmentViewController
//
//  Created by lilin on 2019/1/5.
//  Copyright © 2019年 lilin. All rights reserved.
//

import UIKit

class AttributeItemView: LLSegmentBaseItemView {
    let titleLabel = UILabel()
    required init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.frame = bounds
        titleLabel.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        addSubview(titleLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func titleChange(title: String) {
        //方式一：通过ctl.title传递数据
        let titles = title.components(separatedBy: "\n")
        if let fistTitle = titles.first,
            let lastTitle = titles.last {
            let contentStr = fistTitle + "\n" + lastTitle
            let firstAttributes = [NSAttributedStringKey.foregroundColor:UIColor.blue]
            let lastAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
            
            let attributedText = NSMutableAttributedString(string: contentStr, attributes: nil)
            attributedText.addAttributes(firstAttributes, range: NSRange.init(location: 0, length: fistTitle.count))
            attributedText.addAttributes(lastAttributes, range: NSRange.init(location: contentStr.count - lastTitle.count, length: lastTitle.count))
            attributedText.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15)], range: NSRange.init(location: 0, length: contentStr.count))
            titleLabel.attributedText = attributedText
        }
        
        //方式二：ctl转化为自己的viewControler，
        //            if let ctl = associateViewCtl as? CustomViewControler{
        //                let model = ctl.model
        //            }
        
    }
    
    override func itemWidth() -> CGFloat {
        return 100
    }
}


//MARK:-自定义的使用
class AttributeItemViewController: LLSegmentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContentView()
        loadCtls()
        setUpSegmentStyle()
    }
    
    func layoutContentView() {
        self.layoutInfo.segmentControlPositionType = .top(size: CGSize.init(width: UIScreen.main.bounds.width, height: 50))
        self.relayoutSubViews()
    }
    
    func loadCtls() {
        let titles = ["周一\n8月20号","周二\n8月21号","周三\n8月22号","周四\n8月23号","周五\n8月24号","周六\n8月25号","周七\n8月26号"]
        var ctls = [UIViewController]()
        for title in titles {
            let ctl = TestViewController()
            ctl.showTableView = false
            ctl.title = title
            ctls.append(ctl)
        }
        reloadViewControllers(ctls:ctls)
    }
    
    func setUpSegmentStyle() {
        segmentCtlView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        segmentCtlView.indicatorView.shapeStyle = .background(color: UIColor.red, img: nil)
        let titleViewStyle = LLSegmentItemTitleViewStyle()
        var ctlViewStyle = LLSegmentedControlStyle()
        ctlViewStyle.segmentItemViewClass = AttributeItemView.self
        ctlViewStyle.itemViewStyle = titleViewStyle
        segmentCtlView.reloadData(ctlViewStyle: ctlViewStyle)
    }
}
